import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_bar_title.dart';
import '../../../core/widgets/app_error_view.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../domain/common/failure.dart';
import '../viewmodel/auth_viewmodel.dart';
import '../viewmodel/otp_timer_viewmodel.dart';
import '../widgets/otp_digit_box.dart';

/// Shared 6-digit OTP verification UI. By default (`onVerifyCode`/`onResend`
/// left null) it drives itself entirely off `authViewModelProvider`, exactly
/// as the login flow always has. Passing `onVerifyCode`/`onResend` swaps the
/// verify/resend actions *and* the loading/success/error state they drive —
/// e.g. Teacher Profile phone-number change plugs in
/// `TeacherProfileViewModel.verifyPhoneChangeOtp`/`requestPhoneChangeOtp` so
/// the exact same `OtpDigitBox`/timer/error UI reacts to the real backend
/// call for that flow instead of the login one.
class OtpVerifyView extends ConsumerStatefulWidget {
  const OtpVerifyView({
    super.key,
    this.phone = '',
    this.isBottomSheet = false,
    this.onVerifyCode,
    this.onResend,
  });

  final String phone;
  final bool isBottomSheet;

  /// Returns `null` on success, or the `Failure` to display on rejection.
  final Future<Failure?> Function(String code)? onVerifyCode;

  /// Returns `null` on success (starts the resend cooldown), or the
  /// `Failure` to display on rejection.
  final Future<Failure?> Function()? onResend;

  @override
  ConsumerState<OtpVerifyView> createState() => _OtpVerifyViewState();
}

class _OtpVerifyViewState extends ConsumerState<OtpVerifyView> {
  bool _isLoading = false;
  bool _verified = false;
  Failure? _failure;
  int _resetToken = 0;

  bool get _isCustom => widget.onVerifyCode != null;

  String _formatCooldown(int seconds) {
    final minutes = seconds ~/ 60;
    final remainder = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainder.toString().padLeft(2, '0')}';
  }

  Future<void> _handleCustomVerify(String code) async {
    setState(() {
      _isLoading = true;
      _failure = null;
    });
    final failure = await widget.onVerifyCode!(code);
    if (!mounted) return;
    if (failure == null) {
      setState(() {
        _isLoading = false;
        _verified = true;
      });
      if (widget.isBottomSheet && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    } else {
      setState(() {
        _isLoading = false;
        _failure = failure;
        _resetToken++;
      });
    }
  }

  Future<void> _handleResend(WidgetRef ref) async {
    if (widget.onResend != null) {
      setState(() => _isLoading = true);
      final failure = await widget.onResend!();
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (failure == null) {
        ref.read(otpTimerViewModelProvider.notifier).startCooldown(widget.phone);
      } else {
        AppSnackbar.show(context, failure.message);
      }
      return;
    }

    final success = await ref
        .read(authViewModelProvider.notifier)
        .requestOtp(
          widget.phone,
          roleRequiredMessage: context.l10n.roleSelectRequired,
        );
    if (success) {
      ref.read(otpTimerViewModelProvider.notifier).startCooldown(widget.phone);
    }
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(otpTimerViewModelProvider);
    final isOnCooldownForThisNumber =
        timerState.phoneNumber == widget.phone && !timerState.canRequestNow;

    final bool isVerified;
    final bool isLoading;
    final Failure? failure;
    final Object? resetToken;

    if (_isCustom) {
      isVerified = _verified;
      isLoading = _isLoading;
      failure = _failure;
      resetToken = _resetToken;
    } else {
      final authState = ref.watch(authViewModelProvider);

      ref.listen(authViewModelProvider, (previous, next) {
        final err = next.error;
        if (err is Failure && previous?.error != err) {
          AppSnackbar.show(context, err.message);
        }
        if (next.hasValue && next.value != null && (previous?.value == null)) {
          if (widget.isBottomSheet && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        }
      });

      final authFailure = authState.error;
      failure = authFailure is Failure ? authFailure : null;
      isVerified = authState.hasValue && authState.value != null;
      isLoading = authState.isLoading;
      resetToken = failure;
    }

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!widget.isBottomSheet) ...[
          Text(
            context.l10n.otpSubtitle(widget.phone),
            style: context.textStyles.bodyMedium?.copyWith(
              color: context.colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.dimens.xl),
        ],
        if (isVerified)
          Column(
            children: [
              Icon(
                Icons.check_circle_outline,
                size: context.dimens.iconLg * 1.5,
                color: context.colors.success,
              ),
              SizedBox(height: context.dimens.md),
              Text(
                context.l10n.otpVerified,
                style: context.textStyles.titleMedium,
              ),
            ],
          )
        else ...[
          SizedBox(height: context.dimens.md),
          OtpDigitBox(
            length: AppConfig.otpLength,
            enabled: !isLoading,
            resetToken: resetToken,
            onCompleted: (code) => _isCustom
                ? _handleCustomVerify(code)
                : ref
                    .read(authViewModelProvider.notifier)
                    .verifyOtp(
                      code,
                      otpRequiredMessage: context.l10n.otpRequestRequired,
                    ),
          ),
          SizedBox(height: context.dimens.xl),
          if (isLoading) const LoadingIndicator(),
          if (!isLoading && failure is Failure)
            Padding(
              padding: EdgeInsets.only(top: context.dimens.md),
              child: AppErrorView(message: failure.message),
            ),
          if (!isLoading) ...[
            SizedBox(height: context.dimens.md),
            if (isOnCooldownForThisNumber)
              Text(
                context.l10n.otpResendIn(
                  _formatCooldown(timerState.secondsRemaining),
                ),
                style: context.textStyles.bodySmall?.copyWith(
                  color: context.colors.textSecondary,
                ),
              )
            else
              AppButton(
                label: context.l10n.otpResendCode,
                variant: AppButtonVariant.text,
                onPressed: () => _handleResend(ref),
              ),
            if (timerState.attemptLimitReached)
              Padding(
                padding: EdgeInsets.only(top: context.dimens.sm),
                child: Text(
                  context.l10n.otpResendLimitWarning,
                  textAlign: TextAlign.center,
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.error,
                  ),
                ),
              ),
          ],
        ],
      ],
    );

    if (widget.isBottomSheet) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(title: AppBarTitle(context.l10n.otpTitle)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: context.dimens.contentMaxWidth,
            ),
            child: Padding(
              padding: EdgeInsets.all(context.dimens.lg),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}
