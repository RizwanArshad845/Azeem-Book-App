import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/validators.dart';
import '../viewmodel/onboarding_viewmodel.dart';
import '../widgets/onboarding_card_scaffold.dart';
import 'otp_sheet_view.dart';

class PhoneNumberView extends ConsumerStatefulWidget {
  const PhoneNumberView({super.key});

  @override
  ConsumerState<PhoneNumberView> createState() => _PhoneNumberViewState();
}

class _PhoneNumberViewState extends ConsumerState<PhoneNumberView> {
  late final TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(onboardingViewModelProvider).phoneNumber,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onContinue() {
    final value = _controller.text.trim();
    if (!Validators.isValidPhone10Digits(value)) {
      setState(() => _error = context.l10n.phoneInvalid);
      return;
    }
    setState(() => _error = null);
    ref.read(onboardingViewModelProvider.notifier).setPhone(value);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => OtpSheetView(phone: value),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;

    return OnboardingCardScaffold(
      icon: Icons.menu_book_rounded,
      title: context.l10n.phoneWelcomeTitle,
      subtitle: context.l10n.phoneSubtitle,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.phoneLabel,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: dimens.sm),

          Container(
            decoration: BoxDecoration(
              color: colors.surfaceVariant,
              borderRadius: BorderRadius.circular(dimens.radiusLg),
              border: Border.all(
                color: _error != null ? colors.error : colors.divider,
                width: 1.5,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: dimens.md, vertical: dimens.xs),
            child: Row(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.phone_android_rounded,
                      size: dimens.iconSm,
                      color: colors.primary,
                    ),
                    SizedBox(width: dimens.xs),
                    Text(
                      context.l10n.phoneCountryCode,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(width: dimens.sm),
                    Container(height: dimens.lg, width: 1, color: colors.divider),
                    SizedBox(width: dimens.sm),
                  ],
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: colors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: context.l10n.phoneHint,
                      hintStyle: TextStyle(color: colors.textSecondary, fontSize: 15),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: dimens.md),
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (_error != null) ...[
            SizedBox(height: dimens.xs),
            Padding(
              padding: EdgeInsets.only(left: dimens.xs),
              child: Text(
                _error!,
                style: TextStyle(
                  color: colors.error,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],

          SizedBox(height: dimens.lg),

          SizedBox(
            width: double.infinity,
            height: dimens.buttonHeight,
            child: ElevatedButton(
              onPressed: _onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(dimens.pillRadius),
                ),
              ),
              child: Text(
                context.l10n.phoneContinueButton,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
