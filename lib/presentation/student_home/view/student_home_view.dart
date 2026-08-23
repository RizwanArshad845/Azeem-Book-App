import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/subject_icons.dart';
import '../../../core/utils/subject_illustration.dart';
import '../../../core/widgets/app_bar_actions.dart';
import '../../../core/widgets/app_dropdown_card.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/illustrated_list_card.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/promo_carousel.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/widgets/subject_view_toggle.dart';
import '../../../domain/auth/entities/user_role.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../student_cart/viewmodel/student_cart_viewmodel.dart';
import '../../test_taking/widgets/practice_question_bank_sheet.dart';
import '../viewmodel/student_home_viewmodel.dart';
import '../widgets/student_welcome_header.dart';
import '../widgets/subject_card.dart';

String _chapterListPath(String subjectId) =>
    AppRoutes.studentHomeSubjectChapters.replaceFirst(':subjectId', subjectId);

/// Student shell Home tab root (§10.2: "Selected subjects, promo carousel,
/// subject -> chapter -> test drill-down"). Redesigned per Reference #3:
/// includes PromoCarousel (infinite auto-advancing banners), course filter
/// dropdown, list/grid view toggle, and IllustratedListCards with subject art.
/// Student shell Home tab root (§10.2: "Selected subjects, promo carousel,
/// subject -> chapter -> test drill-down"). Redesigned per Reference #3:
/// includes PromoCarousel (infinite auto-advancing banners), course filter
/// dropdown, list/grid view toggle, and IllustratedListCards with subject art.
class StudentHomeView extends ConsumerWidget {
  const StudentHomeView({super.key});

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
            const Color(0xFF1E6B52),
            context.colors.secondary,
          ],
          onTap: () => context.push(AppRoutes.studentCart),
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
            const Color(0xFF2A7B62),
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
    final subjectsAsync = ref.watch(enrolledSubjectsProvider);
    final student = ref.watch(currentStudentProvider);
    final purchasedIds = ref.watch(purchasedSubjectIdsProvider).value;
    final cartState = ref.watch(studentCartViewModelProvider).value;
    final cartItems = cartState?.items;

    final viewMode = ref.watch(subjectViewModeProvider);
    final selectedFilter = ref.watch(studentHomeCourseFilterProvider);
    final dismissedPromoIds = ref.watch(dismissedPromoBannersProvider);

    final hasLiveTests = (liveTestsAsync.value?.isNotEmpty ?? false);
    final banners = _buildBanners(context, hasLiveTests, dismissedPromoIds);

    final filterAll = context.l10n.filterAllCourses;
    final filterScience = context.l10n.filterScienceStream;
    final filterGeneral = context.l10n.filterGeneralStream;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.homeNavHome),
        actions: const [AppBarActions(role: UserRole.student)],
      ),
      body: SafeArea(
        child: student == null
            ? const LoadingIndicator()
            : RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(liveTestsProvider);
                  ref.invalidate(enrolledSubjectsProvider);
                },
                child: ListView(
                  padding: EdgeInsets.all(context.dimens.lg),
                  children: [
                    StudentWelcomeHeader(student: student),
                    if (banners.isNotEmpty) ...[
                      SizedBox(height: context.dimens.md),
                      PromoCarousel(
                        banners: banners,
                        onDismiss: (id) => ref
                            .read(dismissedPromoBannersProvider.notifier)
                            .dismiss(id),
                      ),
                    ],
                    SizedBox(height: context.dimens.lg),
                    AppDropdownCard<String>(
                      label: context.l10n.filterCoursesLabel,
                      items: [filterAll, filterScience, filterGeneral],
                      selectedItem: selectedFilter == 'All Courses'
                          ? filterAll
                          : selectedFilter,
                      icon: Icons.filter_list_rounded,
                      onChanged: (val) {
                        if (val != null) {
                          ref
                              .read(studentHomeCourseFilterProvider.notifier)
                              .setFilter(val);
                        }
                      },
                    ),
                    SizedBox(height: context.dimens.md),
                    Row(
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
                          onChanged: (mode) => ref
                              .read(subjectViewModeProvider.notifier)
                              .set(mode),
                        ),
                      ],
                    ),
                    SizedBox(height: context.dimens.md),
                    AsyncValueWidget<List<Subject>>(
                      value: subjectsAsync,
                      skeleton: const SkeletonList(itemCount: 4),
                      onRetry: () => ref.invalidate(enrolledSubjectsProvider),
                      data: (subjects) {
                        if (subjects.isEmpty) {
                          return EmptyStateView(
                            message: context.l10n.studentHomeNoSubjects,
                          );
                        }

                        if (viewMode == SubjectViewMode.grid) {
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: subjects.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: context.dimens.md,
                              crossAxisSpacing: context.dimens.md,
                              childAspectRatio: 0.88,
                            ),
                            itemBuilder: (context, index) {
                              final subject = subjects[index];
                              return SubjectCard(subject: subject);
                            },
                          );
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: subjects.length,
                          separatorBuilder: (_, _) =>
                              SizedBox(height: context.dimens.sm + 2),
                          itemBuilder: (context, index) {
                            final subject = subjects[index];
                            final isOwned =
                                purchasedIds?.contains(subject.id) ?? false;
                            final isInCart = cartItems != null &&
                                cartItems.any((i) => i.subjectId == subject.id);

                            return IllustratedListCard(
                              title: context.l10n
                                  .localizedSubjectName(subject.name),
                              imageAsset: subjectIllustration(subject.name),
                              fallbackIcon: subjectIcon(subject.name),
                              badge: isOwned
                                  ? StatusBadge(
                                      label: context.l10n.subjectCardOwnedBadge,
                                      color: context.colors.success,
                                    )
                                  : isInCart
                                      ? StatusBadge(
                                          label: context.l10n.subjectCardInCartBadge,
                                          color: context.colors.primary,
                                        )
                                      : null,
                              meta: Text(
                                context.l10n.subjectCardExploreHint,
                                style: context.textStyles.bodySmall?.copyWith(
                                  color: context.colors.textSecondary,
                                ),
                              ),
                              onTap: () =>
                                  context.push(_chapterListPath(subject.id)),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
