import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../viewmodel/teacher_students_viewmodel.dart';

/// Top summary counters strip for filtering students by Active (Paid) vs Free status.
class StudentsSummaryStrip extends ConsumerWidget {
  const StudentsSummaryStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allStudents = ref.watch(teacherStudentsProvider).value ?? [];
    final activeFilter = ref.watch(teacherStudentsStatusFilterProvider);

    final total = allStudents.length;
    final active =
        allStudents.where((s) {
          return (s.subjectEnrollments ?? []).any((e) => e.discountApplied);
        }).length;
    final free = total - active;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _StatPill(
            label: context.l10n.teacherAllStudents,
            count: total,
            isSelected: activeFilter == 'all',
            color: context.colors.primary,
            onTap: () {
              ref
                  .read(teacherStudentsStatusFilterProvider.notifier)
                  .setStatus('all');
              ref.read(teacherStudentsCurrentPageProvider.notifier).setPage(1);
            },
          ),
          SizedBox(width: context.dimens.sm),
          _StatPill(
            label: context.l10n.teacherActivePaid,
            count: active,
            isSelected: activeFilter == 'active',
            color: const Color(0xFF059669), // Emerald
            onTap: () {
              ref
                  .read(teacherStudentsStatusFilterProvider.notifier)
                  .setStatus('active');
              ref.read(teacherStudentsCurrentPageProvider.notifier).setPage(1);
            },
          ),
          SizedBox(width: context.dimens.sm),
          _StatPill(
            label: context.l10n.teacherFreeUnpaid,
            count: free,
            isSelected: activeFilter == 'free',
            color: const Color(0xFF64748B), // Slate
            onTap: () {
              ref
                  .read(teacherStudentsStatusFilterProvider.notifier)
                  .setStatus('free');
              ref.read(teacherStudentsCurrentPageProvider.notifier).setPage(1);
            },
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(context.dimens.radiusLg),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: context.dimens.md,
          vertical: context.dimens.xs * 1.5,
        ),
        decoration: BoxDecoration(
          color: isSelected ? color : context.colors.surface,
          borderRadius: BorderRadius.circular(context.dimens.radiusLg),
          border: Border.all(
            color: isSelected ? color : context.colors.divider,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: context.textStyles.labelMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : context.colors.textPrimary,
              ),
            ),
            SizedBox(width: context.dimens.xs),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? Colors.white.withValues(alpha: 0.25)
                        : color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: isSelected ? Colors.white : color,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
