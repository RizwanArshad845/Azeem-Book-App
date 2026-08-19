import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_list_row.dart';
import '../../../domain/student_onboarding/entities/student.dart';

/// One scannable row for a `Student` enrolled with the current teacher
/// (§10.1 — cards, not tables): name, phone, and the subject(s) enrolled
/// with this teacher specifically (not every subject the student is
/// enrolled in overall). [subjectNames] is resolved by the caller from
/// `teacherStudentsSubjectsByIdProvider` since `SubjectEnrollment` only
/// carries a `subjectId`.
class StudentCard extends StatelessWidget {
  const StudentCard({
    super.key,
    required this.student,
    required this.subjectNames,
    required this.onTap,
  });

  final Student student;
  final List<String> subjectNames;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final secondaryStyle = context.textStyles.bodySmall?.copyWith(
      color: context.colors.textSecondary,
    );

    return AppListRow(
      onTap: onTap,
      title: student.name,
      titleStyle: context.textStyles.titleSmall,
      titleMaxLines: 1,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(student.phoneNumber, style: secondaryStyle),
          if (subjectNames.isNotEmpty) ...[
            SizedBox(height: context.dimens.xs / 2),
            Text(
              subjectNames.join(', '),
              style: secondaryStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: context.colors.textSecondary,
        size: context.dimens.iconMd,
      ),
    );
  }
}
