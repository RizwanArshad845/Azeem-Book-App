import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../extensions/context_extensions.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 120});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.logo,
      width: size,
      height: size,
      errorBuilder: (context, error, stackTrace) => _placeholder(context),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: BorderRadius.circular(context.dimens.radiusLg),
      ),
      child: Icon(
        Icons.menu_book_rounded,
        color: context.colors.secondary,
        size: size * 0.55,
      ),
    );
  }
}
