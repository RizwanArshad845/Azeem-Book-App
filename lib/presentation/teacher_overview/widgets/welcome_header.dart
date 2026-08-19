import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../domain/teacher_onboarding/entities/teacher.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key, required this.teacher});

  final Teacher teacher;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.teacherOverviewWelcome,
          style: context.textStyles.bodyMedium?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        SizedBox(height: context.dimens.xs / 2),
        Text(teacher.name, style: context.textStyles.headlineSmall),
      ],
    );
  }
}
