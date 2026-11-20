import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../viewmodel/teacher_students_viewmodel.dart';

/// Search, sort and status filter chips (All / Active / Free, each showing
/// its count) for the Teacher Students directory. The chips replace the old
/// separate summary strip so the roster gets more vertical space.
class StudentsFilterBar extends ConsumerWidget {
  const StudentsFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSort = ref.watch(teacherStudentsSortProvider);
    final statusFilter = ref.watch(teacherStudentsStatusFilterProvider);
    final (allCount, activeCount, freeCount) = ref.watch(
      teacherStudentsStatusCountsProvider,
    );

    void selectStatus(String status) {
      ref.read(teacherStudentsStatusFilterProvider.notifier).setStatus(status);
      ref.read(teacherStudentsCurrentPageProvider.notifier).setPage(1);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Search Bar + Sort Menu
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (val) {
                  ref
                      .read(teacherStudentsSearchQueryProvider.notifier)
                      .setQuery(val);
                  ref
                      .read(teacherStudentsCurrentPageProvider.notifier)
                      .setPage(1);
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: context.colors.surface,
                  hintText: context.l10n.teacherSearchHint,
                  hintStyle: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: context.dimens.iconMd,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: context.dimens.md,
                    vertical: context.dimens.sm,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      context.dimens.radiusMd,
                    ),
                    borderSide: BorderSide(
                      color: context.colors.divider.withValues(alpha: 0.7),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      context.dimens.radiusMd,
                    ),
                    borderSide: BorderSide(
                      color: context.colors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: context.dimens.sm),

            // Sort Dropdown Button
            PopupMenuButton<TeacherStudentsSort>(
              initialValue: currentSort,
              tooltip: context.l10n.commonSort,
              onSelected: (sort) {
                ref.read(teacherStudentsSortProvider.notifier).setSort(sort);
              },
              icon: Container(
                padding: EdgeInsets.all(context.dimens.sm),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(context.dimens.radiusMd),
                  border: Border.all(
                    color: context.colors.divider.withValues(alpha: 0.7),
                  ),
                ),
                child: Icon(
                  Icons.sort_rounded,
                  color: context.colors.primary,
                  size: context.dimens.iconMd,
                ),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: TeacherStudentsSort.recentlyJoined,
                  child: Row(
                    children: [
                      Icon(Icons.schedule_rounded, size: context.dimens.iconSm),
                      SizedBox(width: context.dimens.sm),
                      Text(context.l10n.teacherSortRecentlyJoined),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: TeacherStudentsSort.topPerformers,
                  child: Row(
                    children: [
                      Icon(
                        Icons.emoji_events_outlined,
                        size: context.dimens.iconSm,
                      ),
                      SizedBox(width: context.dimens.sm),
                      Text(context.l10n.teacherSortTopPerformers),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: TeacherStudentsSort.alphabetical,
                  child: Row(
                    children: [
                      Icon(
                        Icons.sort_by_alpha_rounded,
                        size: context.dimens.iconSm,
                      ),
                      SizedBox(width: context.dimens.sm),
                      Text(context.l10n.teacherSortAlphabetical),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: context.dimens.sm),

        // 2. Status filter chips with counts
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _StatusChip(
                label: context.l10n.teacherAllStudents,
                count: allCount,
                selected: statusFilter == 'all',
                onSelected: () => selectStatus('all'),
              ),
              SizedBox(width: context.dimens.sm),
              _StatusChip(
                label: context.l10n.teacherActivePaid,
                count: activeCount,
                selected: statusFilter == 'active',
                onSelected: () => selectStatus('active'),
              ),
              SizedBox(width: context.dimens.sm),
              _StatusChip(
                label: context.l10n.teacherFreeUnpaid,
                count: freeCount,
                selected: statusFilter == 'free',
                onSelected: () => selectStatus('free'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fg = selected ? colors.onPrimary : colors.textPrimary;
    return ChoiceChip(
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => onSelected(),
      selectedColor: colors.primary,
      backgroundColor: colors.surface,
      side: BorderSide(color: selected ? colors.primary : colors.divider),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.dimens.pillRadius),
      ),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: context.textStyles.labelMedium?.copyWith(
              color: fg,
              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          SizedBox(width: context.dimens.xs),
          Text(
            '$count',
            style: context.textStyles.labelMedium?.copyWith(
              color: selected ? colors.onPrimary : colors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
