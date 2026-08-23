import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/illustrated_list_card.dart';
import '../../../core/widgets/meta_row.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../domain/catalog/entities/test.dart';
import '../../student_cart/viewmodel/student_cart_viewmodel.dart';
import '../../test_taking/viewmodel/free_attempts_provider.dart';
import '../../test_taking/widgets/expected_test_preview_sheet.dart';
import '../../test_taking/widgets/practice_question_bank_sheet.dart';
import '../viewmodel/student_home_viewmodel.dart';

/// Tests for a tapped chapter (§10.2 chapter -> test drill-down), redesigned to
/// the reference test-list look: an illustrated card per test with a meta row
/// (question count | duration | Free/Unlock), a "Personalized Practice"
/// section, and a sticky "Buy Now" bar when the subject isn't owned.
class TestListView extends ConsumerWidget {
  const TestListView({
    super.key,
    required this.subjectId,
    required this.chapterId,
  });

  final String subjectId;
  final String chapterId;

  Future<void> _openTest(BuildContext context, WidgetRef ref, Test test) async {
    // Global free-attempts gate: once exhausted, all tests lock behind the
    // upgrade/payment path — surface the explainer sheet instead of starting.
    if (ref.read(attemptsExhaustedProvider)) {
      await PracticeQuestionBankSheet.show(context);
      return;
    }
    final start = await ExpectedTestPreviewSheet.show(context, test);
    if (start == true && context.mounted) {
      context.push(AppRoutes.testTakingPath(test.id));
    }
  }

  Future<void> _buyNow(BuildContext context, WidgetRef ref) async {
    final subject = await ref.read(subjectByIdProvider(subjectId).future);
    final tests = ref.read(testsForSubjectProvider(subjectId)).value;
    if (subject != null && tests != null && tests.isNotEmpty) {
      await ref
          .read(studentCartViewModelProvider.notifier)
          .addSubjectBundle(subject, tests);
    }
    if (context.mounted) context.push(AppRoutes.studentCart);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testsAsync = ref.watch(testsForChapterProvider(chapterId));
    final purchasedIds = ref.watch(purchasedSubjectIdsProvider).value;
    final isOwned = purchasedIds?.contains(subjectId) ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.testListTitle)),
      body: SafeArea(
        child: AsyncValueWidget<List<Test>>(
          value: testsAsync,
          onRetry: () => ref.invalidate(testsForChapterProvider(chapterId)),
          data: (tests) {
            if (tests.isEmpty) {
              return EmptyStateView(message: context.l10n.testListEmpty);
            }
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(context.dimens.lg),
                    children: [
                      for (var i = 0; i < tests.length; i++)
                        Padding(
                          padding: EdgeInsets.only(bottom: context.dimens.sm + 4),
                          child: FadeSlideIn(
                            delay: Duration(milliseconds: 40 * i),
                            child: _TestCard(
                              test: tests[i],
                              onTap: () => _openTest(context, ref, tests[i]),
                            ),
                          ),
                        ),
                      SizedBox(height: context.dimens.md),
                      _PersonalizedPracticeSection(
                        onTap: () => PracticeQuestionBankSheet.show(context),
                      ),
                    ],
                  ),
                ),
                if (!isOwned)
                  _BuyNowBar(onBuy: () => _buyNow(context, ref)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TestCard extends StatelessWidget {
  const _TestCard({required this.test, required this.onTap});

  final Test test;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final lockItem = test.isFreeSample
        ? MetaItem(context.l10n.testBadgeFree,
            icon: Icons.lock_open, color: context.colors.success)
        : MetaItem(context.l10n.testUnlock,
            icon: Icons.lock_outline, color: context.colors.secondary);

    return IllustratedListCard(
      title: test.title,
      imageAsset: AppAssets.testPaper,
      fallbackIcon: Icons.assignment_outlined,
      cornerBadge: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: context.colors.primary,
          shape: BoxShape.circle,
          border: Border.all(color: context.colors.surface, width: 2),
        ),
        child: Icon(Icons.check, size: 10, color: context.colors.onPrimary),
      ),
      badge: test.isLive ? const StatusBadge.live() : null,
      meta: MetaRow([
        MetaItem('${test.questionCount} ${context.l10n.metaQuestions}'),
        MetaItem('${test.durationMinutes} ${context.l10n.metaMinutes}'),
        lockItem,
      ]),
      onTap: onTap,
    );
  }
}

class _PersonalizedPracticeSection extends StatelessWidget {
  const _PersonalizedPracticeSection({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.personalizedPracticeTitle,
          style: context.textStyles.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: context.dimens.sm),
        IllustratedListCard(
          title: context.l10n.practiceBankCardTitle,
          imageAsset: AppAssets.practiceBank,
          fallbackIcon: Icons.track_changes,
          meta: Padding(
            padding: EdgeInsets.only(top: context.dimens.xs),
            child: Text(
              context.l10n.practiceBankCardSubtitle,
              style: context.textStyles.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ),
          onTap: onTap,
        ),
      ],
    );
  }
}

class _BuyNowBar extends StatelessWidget {
  const _BuyNowBar({required this.onBuy});

  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        context.dimens.lg,
        context.dimens.sm,
        context.dimens.lg,
        context.dimens.md,
      ),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(top: BorderSide(color: context.colors.divider)),
      ),
      child: AppPrimaryButton(
        label: context.l10n.buyNow,
        icon: Icons.shopping_cart_outlined,
        onPressed: onBuy,
      ),
    );
  }
}
