import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_error_view.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../domain/common/failure.dart';
import '../viewmodel/auth_viewmodel.dart';
import '../widgets/otp_digit_box.dart';


class OtpVerifyView extends ConsumerWidget {
  const OtpVerifyView({
    super.key,
    this.phone = '',
    this.isBottomSheet = false,
  });

  final String phone;
  final bool isBottomSheet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

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
