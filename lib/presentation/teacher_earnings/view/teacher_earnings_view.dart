import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_bar_title.dart';
import '../../../core/widgets/app_frosted_card.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/blurred_logo_backdrop.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../domain/earnings/entities/earnings_record.dart';
import '../../teacher_overview/viewmodel/teacher_overview_viewmodel.dart';
import '../../teacher_students/viewmodel/teacher_students_viewmodel.dart';
import '../viewmodel/teacher_earnings_viewmodel.dart';
import '../widgets/earnings_projected_calculator_card.dart';
import '../widgets/earnings_record_card.dart';

const int _earningsPageSize = 6;

/// Current page for the paginated commission ledger (kept local to this file
/// since `teacher_earnings_viewmodel.dart` predates this rameel-branch work
/// and is out of scope for these fixes — mirrors the small-Notifier pattern
/// used by `teacher_students_viewmodel.dart`'s `TeacherStudentsCurrentPageNotifier`).
class _TeacherEarningsCurrentPageNotifier extends Notifier<int> {
  @override
  int build() => 1;

  void setPage(int page) => state = page;
}

final _teacherEarningsCurrentPageProvider =
    NotifierProvider<_TeacherEarningsCurrentPageNotifier, int>(
      _TeacherEarningsCurrentPageNotifier.new,
    );

/// Redesigned Teacher Earnings view with actual financial breakdown,
/// motivating projected earnings simulator, and detailed transaction ledger.
class TeacherEarningsView extends ConsumerWidget {
  const TeacherEarningsView({super.key});

  static final NumberFormat _currencyFormatter = NumberFormat.currency(
    symbol: 'Rs. ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final earningsAsync = ref.watch(teacherEarningsProvider);
    final actualEarnings = ref.watch(
      teacherOverviewStatsProvider.select((s) => s.actualEarnings),
    );
    final (
      remainingStudents,
      declaredStudents,
      totalStudents,
      goalProgress,
    ) = ref.watch(
      teacherOverviewStatsProvider.select(
        (s) => (
          s.remainingStudents,
          s.declaredStudents,
          s.totalStudents,
          s.goalProgressPercent,
        ),
      ),
    );
    final studentsById = ref.watch(teacherStudentNamesByIdProvider);
    final currentPage = ref.watch(_teacherEarningsCurrentPageProvider);
    final studentsLoadingForCalc = ref.watch(teacherStudentsLoadingProvider);

    return Scaffold(
      appBar: AppBar(title: AppBarTitle(context.l10n.teacherEarningsTitle)),
      body: BlurredLogoBackdrop(
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(teacherEarningsProvider);
              ref.invalidate(teacherStudentsProvider);
              ref.read(_teacherEarningsCurrentPageProvider.notifier).setPage(1);
            },
            child: AsyncValueWidget<List<EarningsRecord>>(
              value: earningsAsync,
              onRetry: () => ref.invalidate(teacherEarningsProvider),
              skeleton: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.dimens.lg,
                  vertical: context.dimens.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Skeleton(
                      width: double.infinity,
                      height: 90,
                      radius: context.dimens.radiusMd,
                    ),
                    SizedBox(height: context.dimens.lg),
                    const _EarningsCalculatorSkeleton(),
                    SizedBox(height: context.dimens.xl),
                    const SkeletonList(itemCount: 4, itemHeight: 70),
                  ],
                ),
              ),
              data: (records) {
                final total = records.fold<double>(
                  0,
                  (sum, record) => sum + record.amount,
                );

                final totalRecords = records.length;
                final totalPages = totalRecords == 0
                    ? 1
                    : (totalRecords / _earningsPageSize).ceil();
                final effectivePage = currentPage.clamp(1, totalPages);
                final startIndex = (effectivePage - 1) * _earningsPageSize;
                final endIndex = (startIndex + _earningsPageSize).clamp(
                  0,
                  totalRecords,
                );
                final pageRecords = records.sublist(
                  startIndex.clamp(0, totalRecords),
                  endIndex,
                );

                return ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: context.dimens.lg,
                    vertical: context.dimens.sm,
                  ),
                  children: [
                    // 1. Actual Earnings Summary Card (Frosted Glass)
                    AppFrostedCard(
                      padding: EdgeInsets.all(context.dimens.lg),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(context.dimens.md),
                            decoration: BoxDecoration(
                              color: context.colors.success.withValues(
                                alpha: 0.12,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.savings_outlined,
                              color: context.colors.success,
                              size: context.dimens.iconLg,
                            ),
                          ),
                          SizedBox(width: context.dimens.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.l10n.teacherEarningsTotal,
                                  style: context.textStyles.bodySmall?.copyWith(
                                    color: context.colors.textSecondary,
                                  ),
                                ),
                                SizedBox(height: context.dimens.xs / 3),
                                Text(
                                  _currencyFormatter.format(
                                    total > 0 ? total : actualEarnings,
                                  ),
                                  style: context.textStyles.headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: context.colors.success,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.dimens.sm,
                              vertical: context.dimens.xs,
                            ),
                            decoration: BoxDecoration(
                              color: context.colors.surfaceVariant.withValues(
                                alpha: 0.6,
                              ),
                              borderRadius: BorderRadius.circular(
                                context.dimens.radiusSm,
                              ),
                            ),
                            child: Text(
                              context.l10n.teacherPurchasesCount(
                                records.length,
                              ),
                              style: context.textStyles.labelSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.dimens.lg),

                    // 2. Interactive Projected Earnings Simulator Card
                    studentsLoadingForCalc
                        ? const _EarningsCalculatorSkeleton()
                        : EarningsProjectedCalculatorCard(
                            actualEarnings: actualEarnings,
                            remainingStudents: remainingStudents,
                            declaredStudents: declaredStudents,
                            onboardedStudents: totalStudents,
                            goalProgress: goalProgress,
                          ),
                    SizedBox(height: context.dimens.xl),

                    // 3. Transactions History Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.l10n.teacherCommissionHistory,
                          style: context.textStyles.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          context.l10n.teacherEarningsTransactionCount(
                            records.length,
                          ),
                          style: context.textStyles.bodySmall?.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.dimens.sm),

                    // 4. Records List (Frosted Cards, paginated to bound the
                    // number of concurrent BackdropFilter blur layers)
                    if (records.isEmpty) ...[
                      EmptyStateView(
                        icon: Icons.account_balance_wallet_outlined,
                        message: context.l10n.teacherEarningsEmpty,
                      ),
                    ] else ...[
                      Padding(
                        padding: EdgeInsets.only(bottom: context.dimens.xs),
                        child: Text(
                          context.l10n.teacherEarningsShowingRange(
                            startIndex + 1,
                            endIndex,
                            totalRecords,
                          ),
                          style: context.textStyles.bodySmall?.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ),
                      for (final (i, record) in pageRecords.indexed)
                        FadeSlideIn(
                          // Keyed per page so a page change replays the
                          // entrance instead of reusing settled state.
                          key: ValueKey('${effectivePage}_${record.id}'),
                          delay: Duration(milliseconds: 40 * i),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: context.dimens.sm),
                            child: EarningsRecordCard(
                              record: record,
                              studentName: studentsById[record.studentId],
                            ),
                          ),
                        ),
                      if (totalPages > 1) ...[
                        SizedBox(height: context.dimens.sm),
                        _EarningsPaginationBar(
                          currentPage: effectivePage,
                          totalPages: totalPages,
                          onPageSelected: (page) => ref
                              .read(
                                _teacherEarningsCurrentPageProvider.notifier,
                              )
                              .setPage(page),
                        ),
                      ],
                    ],
                    SizedBox(height: context.dimens.xl),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Placeholder matching [EarningsProjectedCalculatorCard]'s footprint while
/// [teacherStudentsProvider] (which the real card's `remainingStudents` value
/// depends on) hasn't resolved yet.
class _EarningsCalculatorSkeleton extends StatelessWidget {
  const _EarningsCalculatorSkeleton();

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      width: double.infinity,
      height: 200,
      radius: context.dimens.radiusXl,
    );
  }
}

class _EarningsPaginationBar extends StatelessWidget {
  const _EarningsPaginationBar({
    required this.currentPage,
    required this.totalPages,
    required this.onPageSelected,
  });

  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: context.dimens.xs),
      decoration: BoxDecoration(
        color: context.colors.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(context.dimens.radiusLg),
        border: Border.all(
          color: context.colors.divider.withValues(alpha: 0.7),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Default IconButton constraints give a >=48dp tap target.
          IconButton(
            tooltip: context.l10n.tchPreviousPage,
            icon: const Icon(Icons.chevron_left_rounded),
            color: context.colors.primary,
            onPressed: currentPage > 1
                ? () => onPageSelected(currentPage - 1)
                : null,
          ),
          Text(
            context.l10n.commonPageOfTotal(currentPage, totalPages),
            style: context.textStyles.bodyMedium?.copyWith(
              color: context.colors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            tooltip: context.l10n.tchNextPage,
            icon: const Icon(Icons.chevron_right_rounded),
            color: context.colors.primary,
            onPressed: currentPage < totalPages
                ? () => onPageSelected(currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }
}
