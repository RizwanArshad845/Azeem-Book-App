import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';

class ReadinessGauge extends StatelessWidget {
  const ReadinessGauge({super.key, required this.percent});

  final double percent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = percent < 50
        ? colors.error
        : percent <= 75
            ? colors.warning
            : colors.success;

    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: CircularProgressIndicator(
              value: (percent / 100).clamp(0.0, 1.0),
              strokeWidth: 10,
              backgroundColor: colors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          Text(
            '${percent.round()}%',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: color),
          ),
        ],
      ),
    );
  }
}
