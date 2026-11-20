import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../domain/campus_directory/entities/campus.dart';
import '../../../domain/catalog/entities/subject.dart';
import '../../teacher_overview/viewmodel/teacher_overview_viewmodel.dart';
import '../viewmodel/teacher_students_viewmodel.dart';
import 'student_card.dart';

/// Filtered, sorted, and advanced paginated students roster list.
class StudentsList extends ConsumerStatefulWidget {
  const StudentsList({super.key});

  static const int _pageSize = 6;

  @override
  ConsumerState<StudentsList> createState() => _StudentsListState();
}

class _StudentsListState extends ConsumerState<StudentsList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    ref.read(teacherStudentsCurrentPageProvider.notifier).setPage(page);
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredStudents = ref.watch(teacherStudentsFilteredListProvider);
    final currentPage = ref.watch(teacherStudentsCurrentPageProvider);
    final currentTeacherId = ref.watch(
      currentTeacherProvider.select((t) => t?.id),
    );

    final subjectsById = ref.watch(
      teacherStudentsSubjectsByIdProvider.select(
        (async) => async.value ?? const <String, Subject>{},
      ),
    );
    final campusesById = ref.watch(
      teacherStudentsCampusesByIdProvider.select(
        (async) => async.value ?? const <String, Campus>{},
      ),
    );

    if (filteredStudents.isEmpty) {
      return ListView(
        controller: _scrollController,
        padding: EdgeInsets.all(context.dimens.lg),
        children: [
          EmptyStateView(
            message: context.l10n.teacherStudentsSearchNoMatch,
            icon: Icons.search_off_rounded,
          ),
        ],
      );
    }

    final totalStudents = filteredStudents.length;
    final totalPages = (totalStudents / StudentsList._pageSize).ceil();
    final effectivePage = currentPage
        .clamp(1, totalPages > 0 ? totalPages : 1)
        .toInt();

    final startIndex = (effectivePage - 1) * StudentsList._pageSize;
    final endIndex = (startIndex + StudentsList._pageSize).clamp(
      0,
      totalStudents,
    );
    final pageStudents = filteredStudents.sublist(startIndex, endIndex);

    return ListView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: context.dimens.lg,
        vertical: context.dimens.xs,
      ),
      children: [
        // Roster Counter Info Bar
        Padding(
          padding: EdgeInsets.only(bottom: context.dimens.xs),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.teacherStudentsShowingRange(
                  startIndex + 1,
                  endIndex,
                  totalStudents,
                ),
                style: context.textStyles.bodySmall?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              if (totalPages > 1)
                Text(
                  context.l10n.commonPageOfTotal(effectivePage, totalPages),
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),

        // Students Cards
        for (final (i, student) in pageStudents.indexed)
          FadeSlideIn(
            // Keyed per page so a page change replays the entrance.
            key: ValueKey('${effectivePage}_${student.id}'),
            delay: Duration(milliseconds: 40 * i),
            child: Padding(
              padding: EdgeInsets.only(bottom: context.dimens.sm),
              child: StudentCard(
                student: student,
                subjectNames: currentTeacherId == null
                    ? const <String>[]
                    : (student.subjectEnrollments ?? [])
                          .where((e) => e.teacherId == currentTeacherId)
                          .map(
                            (e) =>
                                subjectsById[e.subjectId]?.name ?? e.subjectId,
                          )
                          .toList(),
                campusName: campusesById[student.campusId]?.name,
                onTap: () => context.push(
                  AppRoutes.teacherStudentProgressDetailPath(student.id),
                ),
              ),
            ),
          ),

        // Modern Interactive Pagination Bar
        if (totalPages > 1) ...[
          SizedBox(height: context.dimens.sm),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.dimens.sm,
              vertical: context.dimens.xs / 2,
            ),
            decoration: BoxDecoration(
              color: context.colors.surface.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(context.dimens.radiusLg),
              border: Border.all(
                color: context.colors.divider.withValues(alpha: 0.7),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Previous Button
                IconButton(
                  tooltip: context.l10n.tchPreviousPage,
                  icon: const Icon(Icons.chevron_left_rounded),
                  color: context.colors.primary,
                  onPressed: effectivePage > 1
                      ? () => _goToPage(effectivePage - 1)
                      : null,
                ),
                SizedBox(width: context.dimens.xs),

                // Direct Page Selector Chips
                for (int p = 1; p <= totalPages; p++) ...[
                  InkWell(
                    borderRadius: BorderRadius.circular(
                      context.dimens.radiusSm,
                    ),
                    onTap: () => _goToPage(p),
                    child: Container(
                      constraints: BoxConstraints(
                        minWidth: context.dimens.xl,
                        minHeight: context.dimens.xl,
                      ),
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(
                        horizontal: context.dimens.xs / 2,
                      ),
                      decoration: BoxDecoration(
                        color: p == effectivePage
                            ? context.colors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          context.dimens.radiusSm,
                        ),
                      ),
                      child: Text(
                        '$p',
                        style: context.textStyles.bodySmall?.copyWith(
                          color: p == effectivePage
                              ? context.colors.onPrimary
                              : context.colors.textPrimary,
                          fontWeight: p == effectivePage
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],

                SizedBox(width: context.dimens.xs),
                // Next Button
                IconButton(
                  tooltip: context.l10n.tchNextPage,
                  icon: const Icon(Icons.chevron_right_rounded),
                  color: context.colors.primary,
                  onPressed: effectivePage < totalPages
                      ? () => _goToPage(effectivePage + 1)
                      : null,
                ),
              ],
            ),
          ),
        ],
        SizedBox(height: context.dimens.lg),
      ],
    );
  }
}
