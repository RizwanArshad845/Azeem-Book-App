import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_text_field.dart';
import '../viewmodel/teacher_students_viewmodel.dart';

class StudentSearchField extends ConsumerWidget {
  const StudentSearchField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppTextField(
      label: context.l10n.teacherStudentsSearch,
      hint: context.l10n.teacherStudentsSearchHint,
      onChanged: (value) => ref
          .read(teacherStudentsSearchQueryProvider.notifier)
          .setQuery(value),
    );
  }
}
