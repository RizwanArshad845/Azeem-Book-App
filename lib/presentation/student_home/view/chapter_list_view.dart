import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../domain/catalog/entities/chapter.dart';
import '../viewmodel/student_home_viewmodel.dart';
import '../../../core/widgets/status_badge.dart';

String _testListPath(String subjectId, String chapterId) => AppRoutes
    .studentHomeChapterTests
    .replaceFirst(':subjectId', subjectId)
    .replaceFirst(':chapterId', chapterId);

/// Chapters for a tapped subject (§10.2 subject -> chapter drill-down),
/// ordered by `Chapter.order`. The `order == 1` chapter carries a "2 free"
/// badge since that's where the 2 seeded `isFreeSample` tests per subject
/// live (§9.1 Chapter / Test).
class ChapterListView extends ConsumerWidget {
  const ChapterListView({
    super.key,
    required this.subjectId,
    this.subjectName,
  });

  final String subjectId;

  /// Optional — shown as the app bar title when the caller already has it
  /// (avoids an extra lookup just for a heading).
  final String? subjectName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chaptersAsync = ref.watch(chaptersForSubjectProvider(subjectId));

    return Scaffold(
      appBar: AppBar(title: Text(subjectName ?? context.l10n.chapterListTitle)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.dimens.lg),
          child: AsyncValueWidget<List<Chapter>>(
            value: chaptersAsync,
            onRetry: () =>
                ref.invalidate(chaptersForSubjectProvider(subjectId)),
            data: (chapters) {
              if (chapters.isEmpty) {
                return EmptyStateView(
                  message: context.l10n.chapterListEmpty,
                );
              }
              return ListView.separated(
                itemCount: chapters.length,
                separatorBuilder: (_, _) => SizedBox(height: context.dimens.sm),
                itemBuilder: (context, index) {
                  final chapter = chapters[index];
                  final isFirstChapter = chapter.order == 1;
                  return AppCard(
                    onTap: () => context.push(
                      _testListPath(subjectId, chapter.id),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.chapterOrderLabel(chapter.order),
                                style: context.textStyles.labelSmall
                                    ?.copyWith(
                                      color: context.colors.textSecondary,
                                    ),
                              ),
                              SizedBox(height: context.dimens.xs / 2),
                              Text(
                                chapter.title,
                                style: context.textStyles.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                        if (isFirstChapter) ...[
                          StatusBadge(
                            label: context.l10n.chapterFreeBadge,
                            color: context.colors.success,
                          ),
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
