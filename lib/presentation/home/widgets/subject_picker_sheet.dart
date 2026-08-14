import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_snackbar.dart';

class SubjectPickerSheet extends StatelessWidget {
  const SubjectPickerSheet({super.key});

  static const List<String> _otherSubjects = [
    'Physics',
    'Chemistry',
    'Mathematics',
    'Biology',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;

    return Padding(
      padding: EdgeInsets.all(dimens.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.subjectPickerTitle, style: context.textStyles.titleLarge),
          SizedBox(height: dimens.md),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.computer, color: colors.primary),
            title: Text(context.l10n.subjectPickerComputerScience),
            trailing: Icon(Icons.chevron_right, color: colors.primary),
            onTap: () {
              Navigator.of(context).pop();
              context.push(AppRoutes.diagnosticSelfAssessment);
            },
          ),
          for (final subject in _otherSubjects)
            Opacity(
              opacity: 0.5,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.lock_outline),
                title: Text(subject),
                trailing: Text(context.l10n.commonComingSoon),
                onTap: () {
                  Navigator.of(context).pop();
                  AppSnackbar.show(context, context.l10n.commonComingSoon);
                },
              ),
            ),
        ],
      ),
    );
  }
}
