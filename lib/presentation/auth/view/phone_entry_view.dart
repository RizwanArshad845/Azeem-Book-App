import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../domain/common/failure.dart';
import '../viewmodel/auth_viewmodel.dart';

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
    notifier
        .submitPhoneNumber(
          _controller.text,
          invalidPhoneMessage: context.l10n.phoneInvalid,
        )
        .then((success) {
      if (!mounted) return;
      if (success) {
        context.push(AppRoutes.authOtp);
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

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.phoneTitle)),
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
