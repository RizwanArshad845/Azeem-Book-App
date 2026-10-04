import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_snackbar.dart';
import 'assign_teacher_sheet.dart';

/// Assigned-teacher summary card shown at the top of `ChapterListView`.
///
/// Displays the subject's assigned teacher (or a "no teacher" fallback) with a
/// Change/Assign button that opens [AssignTeacherSheet]. Once the subject's
/// bundle is bought ([isPaid]) the teacher is locked: the button is replaced
/// by a lock icon and the sheet can't be opened.
class TeacherAssignmentCard extends StatelessWidget {
  const TeacherAssignmentCard({
    super.key,
    required this.subjectId,
    required this.subjectTitle,
    required this.assignedTeacherId,
    required this.assignedTeacherName,
    this.isPaid = false,
  });

  final String subjectId;
  final String subjectTitle;
  final String? assignedTeacherId;

  /// Bundle bought -> teacher is read-only for this subject.
  final bool isPaid;

  /// Pre-resolved teacher display name, or null if unresolved/unassigned.
  final String? assignedTeacherName;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      // Locked: tapping anywhere on the card explains why the teacher can't
      // be changed (instead of silently doing nothing).
      onTap: isPaid
          ? () => AppSnackbar.show(
              context,
              context.l10n.teacherLockedTapMessage,
            )
          : null,
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
                  assignedTeacherName ??
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
          if (isPaid)
            Padding(
              padding: EdgeInsets.all(context.dimens.sm),
              child: Icon(
                Icons.lock_outline,
                size: 20,
                color: context.colors.textSecondary,
              ),
            )
          else
          TextButton.icon(
            onPressed: () => AssignTeacherSheet.show(
              context: context,
              subjectId: subjectId,
              subjectName: subjectTitle,
              currentTeacherId: assignedTeacherId,
            ),
            icon: Icon(
              assignedTeacherId != null
                  ? Icons.edit_outlined
                  : Icons.add_circle_outline,
              size: 16,
            ),
            label: Text(
              assignedTeacherId != null
                  ? context.l10n.commonChange
                  : context.l10n.commonAssign,
              style: context.textStyles.labelMedium?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
