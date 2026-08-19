import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';

class TeacherInfoRow extends StatelessWidget {
  const TeacherInfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.dimens.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.textStyles.bodyMedium?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          Text(value, style: context.textStyles.bodyMedium),
        ],
      ),
    );
  }
}
