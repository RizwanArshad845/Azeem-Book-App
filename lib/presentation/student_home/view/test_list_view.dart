import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_bar_title.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/illustrated_list_card.dart';
import '../../../core/widgets/meta_row.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../domain/catalog/entities/test.dart';
import '../../student_cart/viewmodel/student_cart_viewmodel.dart';
import '../../test_taking/viewmodel/free_attempts_provider.dart';
import '../../test_taking/widgets/expected_test_preview_sheet.dart';
import '../../test_taking/widgets/practice_question_bank_sheet.dart';
import '../viewmodel/student_home_viewmodel.dart';

/// Tests for a tapped chapter (§10.2 chapter -> test drill-down): an
/// illustrated card per test with a meta row (question count | duration |
/// Free/Unlock). Buy Now lives only on the Chapters screen (`ChapterListView`)
/// — not here.
class TestListView extends ConsumerWidget {
  const TestListView({
    super.key,
    required this.subjectId,
    required this.chapterId,
  });

  final String subjectId;
  final String chapterId;

  Future<void> _openTest(
    BuildContext context,
    WidgetRef ref,
    Test test,
    bool isOwned,
  ) async {
    // Free-attempts gate only applies to unpurchased subjects — once a
    // subject is bought, its tests are always startable regardless of the
    // student's (global, lifetime) free-attempt count.
    if (!isOwned && ref.read(attemptsExhaustedProvider)) {
      await PracticeQuestionBankSheet.show(context, subjectId: subjectId);
      return;
    }
    final start = await ExpectedTestPreviewSheet.show(context, test);
    if (start == true && context.mounted) {
      context.push(AppRoutes.testTakingPath(test.id));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testsAsync = ref.watch(testsForChapterProvider(chapterId));
    final purchasedIds = ref.watch(purchasedSubjectIdsProvider).value;
    final isOwned = purchasedIds?.contains(subjectId) ?? false;
    final attemptsExhausted = ref.watch(attemptsExhaustedProvider);

    return Scaffold(
      appBar: AppBar(title: AppBarTitle(context.l10n.testListTitle)),
      body: SafeArea(
        child: AsyncValueWidget<List<Test>>(
          value: testsAsync,
          onRetry: () => ref.invalidate(testsForChapterProvider(chapterId)),
          skeleton: Padding(
            padding: EdgeInsets.all(context.dimens.lg),
            child: const SkeletonList(itemCount: 5),
          ),
          data: (tests) {
            if (tests.isEmpty) {
              return EmptyStateView(message: context.l10n.testListEmpty);
            }
            return ListView(
              padding: EdgeInsets.all(context.dimens.lg),
              children: [
                for (var i = 0; i < tests.length; i++)
                  Padding(
                    padding: EdgeInsets.only(bottom: context.dimens.sm + 4),
                    child: FadeSlideIn(
                      delay: Duration(milliseconds: 40 * i),
                      child: _TestCard(
                        test: tests[i],
                        isOwned: isOwned,
                        attemptsExhausted: attemptsExhausted,
                        onTap: () => _openTest(context, ref, tests[i], isOwned),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TestCard extends StatelessWidget {
  const _TestCard({
    required this.test,
    required this.isOwned,
    required this.attemptsExhausted,
    required this.onTap,
  });

  final Test test;
  final bool isOwned;
  final bool attemptsExhausted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final lockItem = !isOwned
        ? (test.isFreeSample && !attemptsExhausted
            ? MetaItem(
                context.l10n.testBadgeFree,
                icon: Icons.lock_open,
                color: context.colors.success,
              )
            : MetaItem(
                context.l10n.testUnlock,
                icon: Icons.lock_outline,
                color: context.colors.secondary,
              ))
        : null;

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
        if (lockItem != null) lockItem,
      ]),
      onTap: onTap,
    );
  }
}

