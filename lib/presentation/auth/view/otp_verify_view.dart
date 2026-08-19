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

/// Final screen of the generic OTP auth flow (§10.2). Deliberately does not
/// navigate on success — router redirect logic (unauthenticated -> auth,
/// role shell selection) is wired in a later batch once teacher/student
/// onboarding exist. This screen just lets the `AsyncValue` resolve to the
/// verified `AuthSession`.
class OtpVerifyView extends ConsumerWidget {
  const OtpVerifyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    ref.listen(authViewModelProvider, (previous, next) {
      final err = next.error;
      if (err is Failure && previous?.error != err) {
        AppSnackbar.show(context, err.message);
      }
    });

    final failure = authState.error;
    final isVerified = authState.hasValue && authState.value != null;
    final isLoading = authState.isLoading;

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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.l10n.otpSubtitle(''),
                    style: context.textStyles.bodyMedium?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: context.dimens.xl),
                  if (isVerified)
                    Column(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: context.dimens.iconLg * 1.5,
                          color: context.colors.success,
                        ),
                        SizedBox(height: context.dimens.md),
                        Text(context.l10n.otpVerifyButton, style: context.textStyles.titleMedium),
                      ],
                    )
                  else ...[
                    OtpDigitBox(
                      length: AppConfig.otpLength,
                      enabled: !isLoading,
                      resetToken: failure,
                      onCompleted: (code) => ref
                          .read(authViewModelProvider.notifier)
                          .verifyOtp(code),
                    ),
                    SizedBox(height: context.dimens.lg),
                    if (isLoading) const LoadingIndicator(),
                    if (!isLoading && failure is Failure)
                      Padding(
                        padding: EdgeInsets.only(top: context.dimens.md),
                        child: AppErrorView(message: failure.message),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
