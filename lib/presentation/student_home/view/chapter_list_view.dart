import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_config.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_bar_title.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../domain/catalog/entities/chapter.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../../domain/student_onboarding/entities/teacher_option.dart';
import '../../student_cart/viewmodel/student_cart_viewmodel.dart';
import '../../student_onboarding/viewmodel/student_onboarding_viewmodel.dart';
import '../../student_progress/viewmodel/student_progress_viewmodel.dart';
import '../../test_taking/viewmodel/free_attempts_provider.dart';
import '../viewmodel/student_home_viewmodel.dart';
import '../widgets/assign_teacher_sheet.dart';
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
  const ChapterListView({super.key, required this.subjectId, this.subjectName});

  final String subjectId;
  final String? subjectName;

  void _buyNow(
    BuildContext context,
    WidgetRef ref, {
    String? fallbackName,
  }) {
    _doBuyNow(context, ref, fallbackName: fallbackName);
  }

  Future<void> _doBuyNow(
    BuildContext context,
    WidgetRef ref, {
    String? fallbackName,
  }) async {
    var subject = ref.read(subjectByIdProvider(subjectId)).value ??
        await ref.read(subjectByIdProvider(subjectId).future);
    if (subject == null && fallbackName != null) {
      // bundlePrice: 0 is a placeholder only — the server looks up the real
      // Subject.bundlePrice from subjectId, this fallback object's price
      // never reaches it (see AddCartItemRequestDto, which has no price field).
      subject = Subject(
        id: subjectId,
        boardClassId: '',
        name: fallbackName,
        bundlePrice: 0,
      );
    }
    final tests =
        ref.read(testsForSubjectProvider(subjectId)).value ??
        await ref.read(testsForSubjectProvider(subjectId).future);
    if (subject != null && tests != null && tests.isNotEmpty) {
      await ref
          .read(studentCartViewModelProvider.notifier)
          .addSubjectBundle(subject, tests);
    }
    if (context.mounted) {
      context.go(AppRoutes.studentCart);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chaptersAsync = ref.watch(chaptersForSubjectProvider(subjectId));
    final purchasedIds = ref.watch(purchasedSubjectIdsProvider).value;
    final isOwned = purchasedIds?.contains(subjectId) ?? false;
    final remainingFree = ref.watch(remainingFreeAttemptsProvider).value ??
        AppConfig.freeAttemptsPerStudent;
    final tests = ref.watch(testsForSubjectProvider(subjectId)).value;
    final hasAttempted = ref.watch(hasCompletedAnyTestAttemptProvider);
    final cartIsMutating = ref.watch(cartMutationInProgressProvider);
    final resolvedSubject = ref.watch(subjectByIdProvider(subjectId)).value;
    final resolvedSubjectName = subjectName ?? resolvedSubject?.name;

    final bundlePrice = resolvedSubject?.bundlePrice;
    final subjectDiscountedPrice = resolvedSubject?.discountedPrice;
    final hasDiscount = bundlePrice != null &&
        subjectDiscountedPrice != null &&
        subjectDiscountedPrice < bundlePrice;
    final effectivePrice = subjectDiscountedPrice ?? bundlePrice;
    final discountPercent = hasDiscount
        ? (((bundlePrice - subjectDiscountedPrice) / bundlePrice) * 100).round()
        : null;

    final student = ref.watch(currentStudentProvider);
    final campusId = student?.campusId;
    final enrollment = student?.subjectEnrollments
        ?.where((e) => e.subjectId == subjectId)
        .firstOrNull;
    final assignedTeacherId = enrollment?.teacherId;
    final teachersAsync = campusId != null && campusId.isNotEmpty
        ? ref.watch(teachersForCampusProvider(campusId))
        : null;
    final assignedTeacher = assignedTeacherId != null
        ? (teachersAsync?.value ?? const <TeacherOption>[])
            .where((t) => t.id == assignedTeacherId)
            .firstOrNull
        : null;

    final title = resolvedSubjectName != null
        ? context.l10n.localizedSubjectName(resolvedSubjectName)
        : context.l10n.chapterListTitle;

    return Scaffold(
      appBar: AppBar(title: AppBarTitle(title)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.dimens.lg),
          child: Column(
            children: [
              if (student != null) ...[
                AppCard(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.dimens.md,
                    vertical: context.dimens.sm,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(context.dimens.xs),
                        decoration: BoxDecoration(
                          color: context.colors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_outline,
                          size: 20,
                          color: context.colors.primary,
                        ),
                      ),
                      SizedBox(width: context.dimens.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              context.l10n.subjectTeacherSelectTeacherLabel,
                              style: context.textStyles.labelSmall?.copyWith(
                                color: context.colors.textSecondary,
                              ),
                            ),
                            Text(
                              assignedTeacher?.name ??
                                  (assignedTeacherId != null
                                      ? context.l10n.chapterAssignedTeacherFallback
                                      : context.l10n.chapterSelfStudyLabel),
                              style: context.textStyles.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => AssignTeacherSheet.show(
                          context: context,
                          subjectId: subjectId,
                          subjectName: resolvedSubjectName ?? title,
                          currentTeacherId: assignedTeacherId,
                        ),
                        icon: Icon(
                          assignedTeacherId != null
                              ? Icons.edit_outlined
                              : Icons.add_circle_outline,
                          size: 16,
                        ),
                        label: Text(
                          assignedTeacherId != null ? context.l10n.commonChange : context.l10n.commonAssign,
                          style: context.textStyles.labelMedium?.copyWith(
                            color: context.colors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.dimens.md),
              ],
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
                              if (!isOwned && isFirstChapter && remainingFree > 0) ...[
                                StatusBadge(
                                  label: '$remainingFree free',
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
                  subjectName: resolvedSubjectName ?? title,
                  price: hasAttempted ? effectivePrice?.toString() : null,
                  originalPrice: hasAttempted && hasDiscount
                      ? bundlePrice.toString()
                      : null,
                  discountPercent: hasAttempted ? discountPercent : null,
                  loading: cartIsMutating,
                  onBuyNow: () =>
                      _buyNow(context, ref, fallbackName: resolvedSubjectName),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
