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
      // Long values (school name, subject lists) wrap instead of overflowing.
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textStyles.bodyMedium?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          SizedBox(width: context.dimens.md),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: context.textStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
