import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_error_view.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../domain/common/failure.dart';
import '../viewmodel/auth_viewmodel.dart';
import '../viewmodel/otp_timer_viewmodel.dart';
import '../widgets/otp_digit_box.dart';


class OtpVerifyView extends ConsumerWidget {
  const OtpVerifyView({
    super.key,
    this.phone = '',
    this.isBottomSheet = false,
  });

  final String phone;
  final bool isBottomSheet;

  String _formatCooldown(int seconds) {
    final minutes = seconds ~/ 60;
    final remainder = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainder.toString().padLeft(2, '0')}';
  }

  Future<void> _handleResend(BuildContext context, WidgetRef ref) async {
    final success = await ref
        .read(authViewModelProvider.notifier)
        .requestOtp(phone, roleRequiredMessage: context.l10n.roleSelectRequired);
    if (success) {
      ref.read(otpTimerViewModelProvider.notifier).startCooldown(phone);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final timerState = ref.watch(otpTimerViewModelProvider);
    final isOnCooldownForThisNumber =
        timerState.phoneNumber == phone && !timerState.canRequestNow;

    ref.listen(authViewModelProvider, (previous, next) {
      final err = next.error;
      if (err is Failure && previous?.error != err) {
        AppSnackbar.show(context, err.message);
      }
      if (next.hasValue && next.value != null && (previous?.value == null)) {
        if (isBottomSheet && Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      }
    });

    final failure = authState.error;
    final isVerified = authState.hasValue && authState.value != null;
    final isLoading = authState.isLoading;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isBottomSheet) ...[
          Text(
            context.l10n.otpSubtitle(phone),
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
            resetToken: failure,
            onCompleted: (code) => ref
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
                onPressed: () => _handleResend(context, ref),
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

    if (isBottomSheet) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.otpTitle)),
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
