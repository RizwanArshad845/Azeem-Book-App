import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../domain/catalog/entities/chapter.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../../domain/catalog/entities/test.dart';
import '../../../domain/student_cart/usecases/price_for_subject_bundle.dart';
import '../../../domain/student_onboarding/entities/subject_enrollment.dart';
import '../../student_cart/viewmodel/student_cart_viewmodel.dart';
import '../../student_onboarding/viewmodel/student_onboarding_viewmodel.dart';
import '../viewmodel/student_home_viewmodel.dart';

String _testListPath(String subjectId, String chapterId) => AppRoutes
    .studentHomeChapterTests
    .replaceFirst(':subjectId', subjectId)
    .replaceFirst(':chapterId', chapterId);

/// Display-only mirror of `CartRepositoryImpl._teacherDiscountMultiplier`
/// (20% off), used purely so the "Add to cart" button can show the
/// prospective discounted price *before* the bundle is actually added — the
/// authoritative price/discount is still computed server-side by
/// `CartRepositoryImpl.addSubjectBundle` when the button is pressed. Same
/// documented-duplication approach `CheckoutUseCase._teacherCommissionRate`
/// already uses for a different constant.
const _displayTeacherDiscountMultiplier = 0.8;

/// Chapters for a tapped subject (§10.2 subject -> chapter drill-down),
/// ordered by `Chapter.order`. The `order == 1` chapter carries a "2 free"
/// badge since that's where the 2 seeded `isFreeSample` tests per subject
/// live (§9.1 Chapter / Test).
///
/// Also the subject-bundle purchase entry point (§2 of the cart-UI plan):
/// a header above the chapter list shows "Purchased" once the subject is
/// owned, or an "Add to cart" button with the bundle price otherwise.
/// Chapters/tests stay browsable regardless of purchase state — this is
/// preview browsing, not a paywall on browsing itself.
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _BundlePurchaseHeader(subjectId: subjectId),
              Expanded(
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
            ],
          ),
        ),
      ),
    );
  }
}

/// Bundle-purchase header: resolves the `Subject`/its `Test`s/the student's
/// purchased-subject-ids independently of the chapter list below, so a slow
/// or failed lookup here never blocks chapter browsing. Renders nothing
/// until every piece it needs has resolved (no loading spinner competing
/// with the chapter list's own `AsyncValueWidget`).
class _BundlePurchaseHeader extends ConsumerWidget {
  const _BundlePurchaseHeader({required this.subjectId});

  final String subjectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subject = ref.watch(subjectByIdProvider(subjectId)).value;
    final tests = ref.watch(testsForSubjectProvider(subjectId)).value;
    final purchasedIds = ref.watch(purchasedSubjectIdsProvider).value;

    if (subject == null || tests == null || tests.isEmpty || purchasedIds == null) {
      return const SizedBox.shrink();
    }

    final isPurchased = purchasedIds.contains(subjectId);

    if (isPurchased) {
      return Padding(
        padding: EdgeInsets.only(bottom: context.dimens.lg),
        child: Align(
          alignment: Alignment.centerLeft,
          child: StatusBadge(
            label: context.l10n.chapterListPurchasedBadge,
            color: context.colors.success,
          ),
        ),
      );
    }

    final subjectEnrollments =
        ref.watch(studentOnboardingViewModelProvider).value?.subjectEnrollments ??
        const <SubjectEnrollment>[];
    final enrollment = subjectEnrollments
        .where((e) => e.subjectId == subjectId)
        .firstOrNull;
    final discountApplied = enrollment?.discountApplied ?? false;

    final basePrice = priceForSubjectBundle(tests);
    final discountedPrice =
        discountApplied ? basePrice * _displayTeacherDiscountMultiplier : null;
    final payablePrice = discountedPrice ?? basePrice;

    return Padding(
      padding: EdgeInsets.only(bottom: context.dimens.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (discountedPrice != null) ...[
            Row(
              children: [
                Text(
                  'Rs. ${basePrice.toStringAsFixed(0)}',
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                SizedBox(width: context.dimens.sm),
                StatusBadge(
                  label: context.l10n.subjectTeacherSelectDiscountApplied,
                  color: context.colors.success,
                ),
              ],
            ),
            SizedBox(height: context.dimens.sm),
          ],
          AppPrimaryButton(
            label: context.l10n.chapterListAddToCartButton(
              payablePrice.toStringAsFixed(0),
            ),
            onPressed: () => _addToCart(context, ref, subject, tests),
          ),
        ],
      ),
    );
  }

  Future<void> _addToCart(
    BuildContext context,
    WidgetRef ref,
    Subject subject,
    List<Test> tests,
  ) async {
    await ref
        .read(studentCartViewModelProvider.notifier)
        .addSubjectBundle(subject, tests);
    if (!context.mounted) return;
    AppSnackbar.show(context, context.l10n.chapterListAddedToCart);
  }
}
