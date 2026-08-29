import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../domain/common/failure.dart';
import '../viewmodel/auth_viewmodel.dart';
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
    final notifier = ref.read(authViewModelProvider.notifier);
    final phoneNumber = '${context.l10n.phoneCountryCode} ${_controller.text.trim()}';
    notifier
        .submitPhoneNumber(
          _controller.text,
          invalidPhoneMessage: context.l10n.phoneInvalid,
          roleRequiredMessage: context.l10n.roleSelectRequired,
        )
        .then((success) {
      if (!mounted) return;
      if (success) {
        AppBottomSheet.show(
          context: context,
          title: context.l10n.otpTitle,
          subtitle: context.l10n.otpSubtitle(phoneNumber),
          child: OtpVerifyView(
            phone: phoneNumber,
            isBottomSheet: true,
          ),
        );
      } else {
        final failure = ref.read(authViewModelProvider).error;
        AppSnackbar.show(
          context,
          failure is Failure ? failure.message : context.l10n.commonErrorGeneric,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final isLoading = authState.isLoading;
    final failure = authState.error;
    final isValidationFailure = failure is ValidationFailure;
    final currentLocale = ref.watch(localeProvider);
    final isUrdu = currentLocale?.languageCode == 'ur';

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.phoneTitle),
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(right: context.dimens.md),
              child: InkWell(
                borderRadius: BorderRadius.circular(context.dimens.pillRadius),
                onTap: () {
                  ref.read(localeProvider.notifier).setLocale(
                        isUrdu ? const Locale('en') : const Locale('ur'),
                      );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.dimens.sm,
                    vertical: context.dimens.xs / 2,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius:
                        BorderRadius.circular(context.dimens.pillRadius),
                    border: Border.all(color: context.colors.divider),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.language_rounded,
                        size: context.dimens.iconSm,
                        color: context.colors.primary,
                      ),
                      SizedBox(width: context.dimens.xs / 2),
                      Text(
                        context.l10n.langToggleLabel,
                        style: context.textStyles.labelSmall?.copyWith(
                          color: context.colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.l10n.phoneSubtitle,
                    style: context.textStyles.bodyMedium?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                  SizedBox(height: context.dimens.lg),
                  AppTextField(
                    label: context.l10n.phoneLabel,
                    hint: context.l10n.phoneHint,
                    controller: _controller,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    errorText: isValidationFailure ? failure.message : null,
                    prefixText: '${context.l10n.phoneCountryCode} ',
                  ),
                  SizedBox(height: context.dimens.lg),
                  AppPrimaryButton(
                    label: context.l10n.phoneContinueButton,
                    loading: isLoading,
                    onPressed: isLoading ? null : _handleSubmit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
