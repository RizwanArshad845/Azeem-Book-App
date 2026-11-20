import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_bar_actions.dart';
import '../../../core/widgets/app_bar_title.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/delayed_loader.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/greeting_hero_card.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/promo_carousel.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../core/widgets/subject_view_toggle.dart';
import '../../../domain/auth/entities/user_role.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../student_cart/viewmodel/student_cart_viewmodel.dart';
import '../../test_taking/widgets/practice_question_bank_sheet.dart';
import '../viewmodel/student_home_viewmodel.dart';
import '../viewmodel/study_activity_viewmodel.dart';
import '../widgets/add_subject_sheet.dart';
import '../widgets/continue_learning_card.dart';
import '../widgets/subject_card.dart';

/// Student shell Home tab root (§10.2: "Selected subjects, promo carousel,
/// subject -> chapter -> test drill-down"). Redesigned per Reference #3:
/// includes PromoCarousel (infinite auto-advancing banners), list/grid view
/// toggle, and IllustratedListCards with subject art.
///
/// Split into `_PromoSection`/`_SubjectsSection` (audit S1) so each owns only
/// the providers it needs — this root only watches `currentStudentProvider`
/// for the initial loading gate.
class StudentHomeView extends ConsumerWidget {
  const StudentHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.watch(currentStudentProvider);
    final streak = ref.watch(studyStreakProvider);
    // An onboarded student can add more subjects any time (needs a board
    // class — the backend rejects enrolment without one).
    final canAddSubjects = (student?.boardClassId ?? '').isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(context.l10n.homeNavHome),
        actions: const [AppBarActions(role: UserRole.student)],
      ),
      floatingActionButton: canAddSubjects
          ? Padding(
              // The shell Scaffold uses `extendBody: true` under a floating
              // nav bar, which grows `padding.bottom` by the bar's height but
              // leaves `viewPadding` alone — and the FAB float location only
              // clears `viewPadding`. Lift it by the difference so it sits
              // above the nav bar instead of behind it.
              padding: EdgeInsets.only(
                bottom: (MediaQuery.paddingOf(context).bottom -
                        MediaQuery.viewPaddingOf(context).bottom)
                    .clamp(0.0, double.infinity),
              ),
              child: FloatingActionButton.extended(
                heroTag: 'add-subject-fab',
                onPressed: () => AddSubjectSheet.show(context),
                backgroundColor: context.colors.accent,
                foregroundColor: context.colors.onAccent,
                icon: const Icon(Icons.add_rounded),
                label: Text(
                  context.l10n.addSubjectButton,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: student == null
            ? const DelayedLoader(child: LoadingIndicator())
            : RefreshIndicator(
                onRefresh: () async {
                  clearCatalogCache(ref);
                  ref.invalidate(liveTestsProvider);
                  ref.invalidate(enrolledSubjectsProvider);
                  ref.invalidate(purchasedSubjectIdsProvider);
                  ref.invalidate(studentCartViewModelProvider);
                },
                child: ListView(
                  // Extra bottom room so the last subject card can scroll
                  // clear of the floating "Add subject" button.
                  padding: EdgeInsets.only(
                    top: context.dimens.lg,
                    bottom: context.dimens.xxl * 2,
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.dimens.lg,
                      ),
                      child: GreetingHeroCard(
                        name: student.name,
                        greeting: context.l10n.studentHomeWelcomeName(
                          student.name,
                        ),
                        subtitle: streak > 0
                            ? null
                            : context.l10n.stuWelcomeSubtitleNeutral,
                        footer: streak > 0 ? _StreakChip(days: streak) : null,
                      ),
                    ),
                    const ContinueLearningCard(),
                    const _PromoSection(),
                    SizedBox(height: context.dimens.xl),
                    _SubjectsSection(canAddSubjects: canAddSubjects),
                  ],
                ),
              ),
      ),
    );
  }
}

/// Owns the live-tests/promo-banner watches so the Home root doesn't have to.
class _PromoSection extends ConsumerWidget {
  const _PromoSection();

  List<PromoBanner> _buildBanners(
    BuildContext context,
    bool hasLiveTests,
    Set<String> dismissedPromoIds,
  ) {
    final banners = <PromoBanner>[];

    if (hasLiveTests && !dismissedPromoIds.contains('live_tests')) {
      banners.add(
        PromoBanner(
          id: 'live_tests',
          title: context.l10n.liveTestsTitle,
          subtitle: context.l10n.liveTestScheduledSingle,
          fallbackIcon: Icons.podcasts,
          imageAsset: AppAssets.promoLive,
          gradientColors: [
            context.colors.primary,
            context.colors.secondary,
          ],
          onTap: () => context.push(AppRoutes.studentLiveTests),
        ),
      );
    }

    if (!dismissedPromoIds.contains('discount')) {
      banners.add(
        PromoBanner(
          id: 'discount',
          title: context.l10n.promoTeacherDiscountTitle,
          subtitle: context.l10n.promoTeacherDiscountSubtitle,
          fallbackIcon: Icons.local_offer_outlined,
          imageAsset: AppAssets.promoDiscount,
          gradientColors: [
            context.colors.secondary,
            context.colors.primary,
          ],
          onTap: () => context.go(AppRoutes.studentCart),
        ),
      );
    }

    if (!dismissedPromoIds.contains('practice_bank')) {
      banners.add(
        PromoBanner(
          id: 'practice_bank',
          title: context.l10n.promoPracticeBankTitle,
          subtitle: context.l10n.promoPracticeBankSubtitle,
          fallbackIcon: Icons.track_changes_outlined,
          imageAsset: AppAssets.practiceBank,
          gradientColors: [
            context.colors.primary,
            context.colors.accent,
          ],
          onTap: () => PracticeQuestionBankSheet.show(context),
        ),
      );
    }

    return banners;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveTestsAsync = ref.watch(liveTestsProvider);
    final dismissedPromoIds = ref.watch(dismissedPromoBannersProvider);
    final hasLiveTests = liveTestsAsync.value?.isNotEmpty ?? false;
    final banners = _buildBanners(context, hasLiveTests, dismissedPromoIds);

    if (banners.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: context.dimens.lg),
      child: PromoCarousel(
        // A slim strip: secondary to the "Continue" card above it.
        height: 100,
        banners: banners,
        onDismiss: (id) =>
            ref.read(dismissedPromoBannersProvider.notifier).dismiss(id),
      ),
    );
  }
}

/// Owns the subject-list/grid watches (enrolled subjects, purchased ids,
/// cart, view mode) so the Home root doesn't have to.
class _SubjectsSection extends ConsumerWidget {
  const _SubjectsSection({required this.canAddSubjects});

  final bool canAddSubjects;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectsAsync = ref.watch(enrolledSubjectsProvider);
    final viewMode = ref.watch(subjectViewModeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.dimens.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.menu_book_outlined,
                    color: context.colors.textSecondary,
                    size: context.dimens.iconSm,
                  ),
                  SizedBox(width: context.dimens.xs),
                  Text(
                    context.l10n.subjectSelectionTitle,
                    style: context.textStyles.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SubjectViewToggle(
                mode: viewMode,
                onChanged: (mode) =>
                    ref.read(subjectViewModeProvider.notifier).set(mode),
              ),
            ],
          ),
        ),
        SizedBox(height: context.dimens.md),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.dimens.lg),
          child: AsyncValueWidget<List<Subject>>(
            value: subjectsAsync,
            skeleton: const SkeletonList(itemCount: 4),
            onRetry: () => ref.invalidate(enrolledSubjectsProvider),
            data: (subjects) {
              if (subjects.isEmpty) {
                return EmptyStateView(
                  icon: Icons.menu_book_outlined,
                  message: context.l10n.studentHomeNoSubjects,
                  actionLabel:
                      canAddSubjects ? context.l10n.addSubjectButton : null,
                  onAction: canAddSubjects
                      ? () => AddSubjectSheet.show(context)
                      : null,
                );
              }

              Widget item(int index) => FadeSlideIn(
                delay: Duration(milliseconds: 40 * index.clamp(0, 8)),
                child: SubjectCard(
                  subject: subjects[index],
                  grid: viewMode == SubjectViewMode.grid,
                ),
              );

              if (viewMode == SubjectViewMode.grid) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: subjects.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: context.dimens.md,
                    crossAxisSpacing: context.dimens.md,
                    childAspectRatio: 0.78,
                  ),
                  itemBuilder: (context, index) => item(index),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: subjects.length,
                separatorBuilder: (_, _) => SizedBox(height: context.dimens.sm),
                itemBuilder: (context, index) => item(index),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Small translucent "🔥 N-day streak" pill for the greeting hero card.
class _StreakChip extends StatelessWidget {
  const _StreakChip({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.dimens.sm,
          vertical: context.dimens.xs / 2,
        ),
        decoration: BoxDecoration(
          color: context.colors.onPrimary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(context.dimens.pillRadius),
        ),
        child: Text(
          context.l10n.stuStreakChip(days),
          style: context.textStyles.labelMedium?.copyWith(
            color: context.colors.onPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
