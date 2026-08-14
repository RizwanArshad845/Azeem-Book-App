import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_config.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../viewmodel/onboarding_viewmodel.dart';
import '../widgets/otp_digit_box.dart';

class OtpSheetView extends ConsumerStatefulWidget {
  const OtpSheetView({super.key, required this.phone});

  final String phone;

  @override
  ConsumerState<OtpSheetView> createState() => _OtpSheetViewState();
}

class _OtpSheetViewState extends ConsumerState<OtpSheetView> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  String? _error;
  Timer? _lockoutTimer;

  @override
  void initState() {
    super.initState();
    _controllers =
        List.generate(AppConfig.otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(AppConfig.otpLength, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _lockoutTimer?.cancel();
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < AppConfig.otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (_code.length == AppConfig.otpLength) {
      _verify();
    }
  }

  void _verify() {
    final router = GoRouter.of(context);
    final success =
        ref.read(onboardingViewModelProvider.notifier).verifyOtp(_code);

    if (success) {
      Navigator.of(context).pop();
      router.go(AppRoutes.onboardingPersonalInfo);
      return;
    }

    final locked = ref.read(onboardingViewModelProvider).otpLocked;
    if (locked) {
      setState(() => _error = context.l10n.otpTooManyAttempts);
      _lockoutTimer =
          Timer(const Duration(seconds: AppConfig.otpLockoutRestartSeconds), () {
        if (!mounted) return;
        ref.read(onboardingViewModelProvider.notifier).resetOtp();
        Navigator.of(context).pop();
      });
    } else {
      setState(() => _error = context.l10n.otpIncorrect);
      for (final c in _controllers) {
        c.clear();
      }
      _focusNodes[0].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final locked = ref.watch(
      onboardingViewModelProvider.select((s) => s.otpLocked),
    );

    return Padding(
      padding: EdgeInsets.only(
        left: context.dimens.lg,
        right: context.dimens.lg,
        top: context.dimens.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + context.dimens.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.otpTitle, style: context.textStyles.titleLarge),
          SizedBox(height: context.dimens.xs),
          Text(
            context.l10n.otpSubtitle('${context.l10n.phoneCountryCode} ${widget.phone}'),
            style: TextStyle(color: context.colors.textSecondary),
          ),
          SizedBox(height: context.dimens.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              AppConfig.otpLength,
              (i) => OtpDigitBox(
                controller: _controllers[i],
                focusNode: _focusNodes[i],
                hasError: _error != null,
                onChanged: (value) => _onDigitChanged(i, value),
              ),
            ),
          ),
          if (_error != null) ...[
            SizedBox(height: context.dimens.sm),
            Text(_error!, style: TextStyle(color: context.colors.error)),
          ],
          SizedBox(height: context.dimens.lg),
          AppButton(
            label: context.l10n.otpVerifyButton,
            onPressed: locked ? null : _verify,
          ),
        ],
      ),
    );
  }
}
