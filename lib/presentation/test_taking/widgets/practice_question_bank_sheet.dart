import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_config.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/attempts_banner.dart';
import '../../student_cart/viewmodel/student_cart_viewmodel.dart';
import '../viewmodel/free_attempts_provider.dart';

/// "How Practice Question Bank works?" explainer sheet (attempts_limit
/// reference): a remaining-free-attempts banner + Upgrade, three how-it-works
/// bullets, and an "Okay, Got it!" button.
class PracticeQuestionBankSheet extends ConsumerWidget {
  const PracticeQuestionBankSheet({
    super.key,
    this.subjectId,
    this.onUpgrade,
  });

  final String? subjectId;
  final VoidCallback? onUpgrade;

  static Future<void> show(
    BuildContext context, {
    String? subjectId,
    VoidCallback? onUpgrade,
  }) {
    return AppBottomSheet.show<void>(
      context: context,
      showCloseButton: false,
      child: PracticeQuestionBankSheet(
        subjectId: subjectId,
        onUpgrade: onUpgrade,
      ),
    );
  }

  Future<void> _handleUpgrade(BuildContext context, WidgetRef ref) async {
    final router = GoRouter.of(context);
    Navigator.of(context).pop();

    if (onUpgrade != null) {
      onUpgrade!();
    } else if (subjectId != null) {
      try {
        await ref
            .read(studentCartViewModelProvider.notifier)
            .addSubjectBundleById(subjectId!);
      } catch (_) {}
    }

    router.go(AppRoutes.studentCart);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remaining = ref.watch(remainingFreeAttemptsProvider).value ??
        AppConfig.freeAttemptsPerStudent;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AttemptsBanner(
          message: context.l10n.attemptsRemaining(
            remaining,
            AppConfig.freeAttemptsPerStudent,
          ),
          upgradeLabel: context.l10n.attemptsUpgrade,
          onUpgrade: () => _handleUpgrade(context, ref),
        ),
        SizedBox(height: context.dimens.lg),
        Text(
          context.l10n.practiceHowTitle,
          style: context.textStyles.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: context.dimens.md),
        _bullet(context, context.l10n.practiceBullet1),
        _bullet(context, context.l10n.practiceBullet2),
        _bullet(context, context.l10n.practiceBullet3),
        SizedBox(height: context.dimens.lg),
        AppPrimaryButton(
          label: context.l10n.practiceOkayGotIt,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _bullet(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.dimens.sm + 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: context.dimens.xs),
            child: Icon(
              Icons.check_circle,
              size: context.dimens.iconSm + 2,
              color: context.colors.success,
            ),
          ),
          SizedBox(width: context.dimens.sm),
          Expanded(
            child: Text(text, style: context.textStyles.bodyMedium),
          ),
        ],
      ),
    );
  }
}
