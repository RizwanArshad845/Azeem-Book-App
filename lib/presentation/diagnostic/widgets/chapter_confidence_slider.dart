import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';

class ChapterConfidenceSlider extends StatelessWidget {
  const ChapterConfidenceSlider({
    super.key,
    required this.title,
    required this.rating,
    required this.onChanged,
  });

  final String title;
  final int rating;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.dimens.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w600, color: colors.textPrimary),
                ),
              ),
              Text('$rating/5', style: TextStyle(color: colors.primary, fontWeight: FontWeight.w700)),
            ],
          ),
          Slider(
            value: rating.toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            activeColor: colors.primary,
            onChanged: (value) => onChanged(value.round()),
          ),
        ],
      ),
    );
  }
}
