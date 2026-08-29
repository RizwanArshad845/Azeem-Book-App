import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../viewmodel/teacher_students_viewmodel.dart';

/// Filter & sorting bar for the Teacher Students directory.
class StudentsFilterBar extends ConsumerWidget {
  const StudentsFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campusesAsync = ref.watch(teacherStudentsCampusesByIdProvider);
    final selectedCampusId = ref.watch(teacherStudentsCampusFilterProvider);
    final currentSort = ref.watch(teacherStudentsSortProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Search Bar + Sort Menu
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(context.dimens.radiusMd),
                  border: Border.all(
                    color: context.colors.divider.withValues(alpha: 0.7),
                  ),
                ),
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
                    hintText: context.l10n.teacherSearchHint,
                    hintStyle: context.textStyles.bodySmall?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: context.dimens.md,
                      vertical: context.dimens.sm,
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
                  size: 20,
                ),
              ),
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      value: TeacherStudentsSort.recentlyJoined,
                      child: Row(
                        children: [
                          const Icon(Icons.schedule_rounded, size: 18),
                          const SizedBox(width: 8),
                          Text(context.l10n.teacherSortRecentlyJoined),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: TeacherStudentsSort.topPerformers,
                      child: Row(
                        children: [
                          const Icon(Icons.emoji_events_outlined, size: 18),
                          const SizedBox(width: 8),
                          Text(context.l10n.teacherSortTopPerformers),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: TeacherStudentsSort.alphabetical,
                      child: Row(
                        children: [
                          const Icon(Icons.sort_by_alpha_rounded, size: 18),
                          const SizedBox(width: 8),
                          Text(context.l10n.teacherSortAlphabetical),
                        ],
                      ),
                    ),
                  ],
            ),
          ],
        ),
        SizedBox(height: context.dimens.sm),

        // 2. Campus Filter Chips
        campusesAsync.when(
          data: (campusesMap) {
            final campuses = campusesMap.values.toList();
            if (campuses.isEmpty) return const SizedBox.shrink();

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  ChoiceChip(
                    label: Text(context.l10n.teacherAllCampuses),
                    selected: selectedCampusId == null,
                    onSelected: (_) {
                      ref
                          .read(teacherStudentsCampusFilterProvider.notifier)
                          .setCampus(null);
                      ref
                          .read(teacherStudentsCurrentPageProvider.notifier)
                          .setPage(1);
                    },
                  ),
                  SizedBox(width: context.dimens.xs),
                  for (final campus in campuses) ...[
                    ChoiceChip(
                      label: Text(campus.name),
                      selected: selectedCampusId == campus.id,
                      onSelected: (selected) {
                        ref
                            .read(teacherStudentsCampusFilterProvider.notifier)
                            .setCampus(selected ? campus.id : null);
                        ref
                            .read(teacherStudentsCurrentPageProvider.notifier)
                            .setPage(1);
                      },
                    ),
                    SizedBox(width: context.dimens.xs),
                  ],
                ],
              ),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}
