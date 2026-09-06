import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/onboarding_scaffold.dart';
import '../../../core/widgets/onboarding_step_header.dart';
import '../../../domain/auth/entities/user_role.dart';
import '../../../domain/common/failure.dart';
import '../viewmodel/auth_viewmodel.dart';
import '../viewmodel/otp_timer_viewmodel.dart';
import 'otp_verify_view.dart';

/// Second screen of the generic OTP auth flow (§10.2) — collects the phone
/// number and requests an OTP for the role picked on `RoleSelectView`.
class PhoneEntryView extends ConsumerStatefulWidget {
  const PhoneEntryView({super.key});

  @override
  ConsumerState<PhoneEntryView> createState() => _PhoneEntryViewState();
}

class _PhoneEntryViewState extends ConsumerState<PhoneEntryView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final phoneNumber = _controller.text.trim();

    // If we already requested an OTP for this exact number and the resend
    // cooldown hasn't expired, just reopen the sheet on the code the user
    // was already sent instead of firing a duplicate SMS.
    final timerState = ref.read(otpTimerViewModelProvider);
    if (timerState.phoneNumber == phoneNumber && !timerState.canRequestNow) {
      _openOtpSheet(phoneNumber);
      return;
    }

    final notifier = ref.read(authViewModelProvider.notifier);
    notifier
        .submitPhoneNumber(
          phoneNumber,
          invalidPhoneMessage: context.l10n.phoneInvalid,
          roleRequiredMessage: context.l10n.roleSelectRequired,
        )
        .then((success) {
      if (!mounted) return;
      if (success) {
        ref.read(otpTimerViewModelProvider.notifier).startCooldown(phoneNumber);
        _openOtpSheet(phoneNumber);
      } else {
        final failure = ref.read(authViewModelProvider).error;
        if (failure is! ValidationFailure) {
          AppSnackbar.show(
            context,
            failure is Failure ? failure.message : context.l10n.commonErrorGeneric,
          );
        }
      }
    });
  }

  void _openOtpSheet(String phoneNumber) {
    AppBottomSheet.show(
      context: context,
      title: context.l10n.otpTitle,
      subtitle: context.l10n.otpSubtitle(phoneNumber),
      child: OtpVerifyView(
        phone: phoneNumber,
        isBottomSheet: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final role = ref.read(authViewModelProvider.notifier).selectedRole;
    final isLoading = authState.isLoading;
    final failure = authState.error;
    final isValidationFailure = failure is ValidationFailure;

    return OnboardingScaffold(
      appBarTitle: context.l10n.phoneTitle,
      role: role == UserRole.teacher
          ? OnboardingRole.teacher
          : OnboardingRole.student,
      onBack: Navigator.of(context).canPop()
          ? () => Navigator.of(context).pop()
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OnboardingStepHeader(
            title: context.l10n.phoneWelcomeTitle,
            subtitle: context.l10n.phoneSubtitle,
          ),
          SizedBox(height: context.dimens.lg),
          AppTextField(
            label: context.l10n.phoneLabel,
            hint: context.l10n.phoneHint,
            controller: _controller,
            keyboardType: TextInputType.phone,
            maxLength: 11,
            errorText: isValidationFailure ? failure.message : null,
          ),
          SizedBox(height: context.dimens.lg),
          AppPrimaryButton(
            label: context.l10n.phoneContinueButton,
            loading: isLoading,
            onPressed: isLoading ? null : _handleSubmit,
          ),
        ],
      ),
    );
  }
}
