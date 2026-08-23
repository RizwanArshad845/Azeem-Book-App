import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../domain/catalog/entities/test.dart';
import '../../test_taking/widgets/expected_test_preview_sheet.dart';
import '../viewmodel/student_home_viewmodel.dart';
import '../../../core/widgets/status_badge.dart';

String _kindLabel(BuildContext context, TestKind kind) => switch (kind) {
  TestKind.subjectWiseGuessPaper => context.l10n.testKindGuessPaper,
  TestKind.subjectWiseSimplePaper => context.l10n.testKindSimplePaper,
  TestKind.chapterWise => context.l10n.testKindChapterWise,
};

/// Tests for a tapped chapter (§10.2 chapter -> test drill-down). Each test
/// shows its `kind`, a "Free" badge for `isFreeSample`, and a "Live" badge
/// for `isLive` (§9.1 Test).
class TestListView extends ConsumerWidget {
  const TestListView({
    super.key,
    required this.subjectId,
    required this.chapterId,
  });

  final String subjectId;
  final String chapterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testsAsync = ref.watch(testsForChapterProvider(chapterId));

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.testListTitle)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.dimens.lg),
          child: AsyncValueWidget<List<Test>>(
            value: testsAsync,
            onRetry: () => ref.invalidate(testsForChapterProvider(chapterId)),
            data: (tests) {
              if (tests.isEmpty) {
                return EmptyStateView(
                  message: context.l10n.testListEmpty,
                );
              }
              return ListView.separated(
                itemCount: tests.length,
                separatorBuilder: (_, _) => SizedBox(height: context.dimens.sm),
                itemBuilder: (context, index) {
                  final test = tests[index];
                  return AppCard(
                    onTap: () async {
                      // Expected-test-preview first (CLAUDE.md §5): shows
                      // chapters covered + question count before the
                      // student commits to starting the attempt.
                      final start = await ExpectedTestPreviewSheet.show(
                        context,
                        test,
                      );
                      if (start == true && context.mounted) {
                        context.push(AppRoutes.testTakingPath(test.id));
                      }
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                test.title,
                                style: context.textStyles.bodyLarge,
                              ),
                              SizedBox(height: context.dimens.xs / 2),
                              Text(
                                _kindLabel(context, test.kind),
                                style: context.textStyles.bodySmall
                                    ?.copyWith(
                                      color: context.colors.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        if (test.isFreeSample) ...[
                          StatusBadge(
                            label: context.l10n.testBadgeFree,
                            color: context.colors.success,
                          ),
                          SizedBox(width: context.dimens.sm),
                        ],
                        if (test.isLive) ...[
                          const StatusBadge.live(),
                          SizedBox(width: context.dimens.sm),
                        ],
                        Icon(
                          Icons.chevron_right,
                          color: context.colors.textSecondary,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
