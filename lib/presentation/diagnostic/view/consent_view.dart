import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../viewmodel/consent_viewmodel.dart';
import '../viewmodel/question_bank_provider.dart';
import '../viewmodel/test_timer_viewmodel.dart';
import '../viewmodel/test_viewmodel.dart';

class ConsentView extends ConsumerWidget {
  const ConsentView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final acknowledged = ref.watch(consentViewModelProvider);
    final questionBankAsync = ref.watch(questionBankProvider);
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.consentTitle)),
      body: Padding(
        padding: EdgeInsets.all(context.dimens.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.videocam_outlined, size: 56, color: colors.primary),
            SizedBox(height: context.dimens.lg),
            Text(context.l10n.consentBody, style: context.textStyles.bodyLarge),
            const Spacer(),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: acknowledged,
              onChanged: (value) =>
                  ref.read(consentViewModelProvider.notifier).setAcknowledged(value ?? false),
              title: Text(context.l10n.consentCheckboxLabel),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: colors.primary,
            ),
            SizedBox(height: context.dimens.md),
            AppButton(
              label: context.l10n.consentStartButton,
              onPressed: acknowledged && questionBankAsync.hasValue
                  ? () {
                      ref.read(testViewModelProvider.notifier).acknowledgeConsent(true);
                      ref
                          .read(testViewModelProvider.notifier)
                          .startTest(questionBankAsync.requireValue);
                      ref.read(testTimerViewModelProvider.notifier).start();
                      context.go(AppRoutes.diagnosticTest);
                    }
                  : null,
            ),
            if (questionBankAsync.isLoading) ...[
              SizedBox(height: context.dimens.sm),
              const LoadingIndicator(),
            ],
          ],
        ),
      ),
    );
  }
}
