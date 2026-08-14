import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

class ChapterScoreTile extends StatelessWidget {
  const ChapterScoreTile({
    super.key,
    required this.title,
    required this.scorePercent,
    required this.bandColor,
  });

  final String title;
  final double scorePercent;
  final Color bandColor;

  @override
  Widget build(BuildContext context) {
    final dimens = context.dimens;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: dimens.sm),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: bandColor, shape: BoxShape.circle),
          ),
          SizedBox(width: dimens.sm),
          Expanded(
            child: Text(title, style: TextStyle(color: context.colors.textPrimary)),
          ),
          Text(
            '${scorePercent.round()}%',
            style: TextStyle(fontWeight: FontWeight.w700, color: bandColor),
          ),
        ],
      ),
    );
  }
}
