import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../domain/catalog/entities/chapter.dart';
import '../../student_cart/viewmodel/student_cart_viewmodel.dart';
import '../../student_progress/viewmodel/student_progress_viewmodel.dart';
import '../viewmodel/student_home_viewmodel.dart';
import '../widgets/subject_bundle_header.dart';

String _testListPath(String subjectId, String chapterId) => AppRoutes
    .studentHomeChapterTests
    .replaceFirst(':subjectId', subjectId)
    .replaceFirst(':chapterId', chapterId);

/// Chapters for a tapped subject (§10.2 subject -> chapter drill-down),
/// ordered by `Chapter.order`. The `order == 1` chapter carries a "2 free"
/// badge since that's where the 2 seeded `isFreeSample` tests per subject
/// live (§9.1 Chapter / Test).
///
/// Includes the bundle purchase header with urgency discount badge, price,
/// and instant Buy Now / Cart navigation.
class ChapterListView extends ConsumerWidget {
  const ChapterListView({
    super.key,
    required this.subjectId,
    this.subjectName,
  });

  final String subjectId;
  final String? subjectName;

  Future<void> _buyNow(BuildContext context, WidgetRef ref) async {
    final subject = await ref.read(subjectByIdProvider(subjectId).future);
    final tests = ref.read(testsForSubjectProvider(subjectId)).value;
    if (subject != null && tests != null && tests.isNotEmpty) {
      await ref
          .read(studentCartViewModelProvider.notifier)
          .addSubjectBundle(subject, tests);
    }
    if (context.mounted) {
      context.push(AppRoutes.studentCart);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chaptersAsync = ref.watch(chaptersForSubjectProvider(subjectId));
    final purchasedIds = ref.watch(purchasedSubjectIdsProvider).value;
    final isOwned = purchasedIds?.contains(subjectId) ?? false;
    final tests = ref.watch(testsForSubjectProvider(subjectId)).value;
    final price = ref.watch(subjectBundlePriceProvider(subjectId));
    final hasAttempted = ref.watch(hasCompletedAnyTestAttemptProvider);

    final title = subjectName != null
        ? context.l10n.localizedSubjectName(subjectName!)
        : context.l10n.chapterListTitle;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.dimens.lg),
          child: Column(
            children: [
              Expanded(
                child: AsyncValueWidget<List<Chapter>>(
                  value: chaptersAsync,
                  skeleton: const SkeletonList(itemCount: 5),
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
                      separatorBuilder: (_, _) =>
                          SizedBox(height: context.dimens.sm),
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
                                      context.l10n.chapterOrderLabel(
                                        chapter.order,
                                      ),
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
              if (!isOwned && tests != null && tests.isNotEmpty) ...[
                SizedBox(height: context.dimens.md),
                SubjectBundleHeader(
                  subjectName: title,
                  price: hasAttempted ? price?.toStringAsFixed(0) : null,
                  onBuyNow: () => _buyNow(context, ref),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

