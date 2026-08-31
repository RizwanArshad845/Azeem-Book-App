import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../extensions/context_extensions.dart';
import '../providers/locale_provider.dart';

/// Compact universal language switcher button featuring a round globe icon (🌐)
/// and the active language indicator ('EN' / 'اردو') for AppBars.
class AppLanguageToggleButton extends ConsumerWidget {
  const AppLanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final isUrdu = currentLocale?.languageCode == 'ur';
    final textStyle = context.textStyles.labelSmall;

    return Tooltip(
      message: isUrdu ? 'Switch to English' : 'اردو میں تبدیل کریں',
      child: InkWell(
        borderRadius: BorderRadius.circular(context.dimens.pillRadius),
        onTap: () => ref.read(localeProvider.notifier).toggleLocale(),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.dimens.sm,
            vertical: context.dimens.xs,
          ),
          margin: EdgeInsets.symmetric(horizontal: context.dimens.xs),
          decoration: BoxDecoration(
            color: context.colors.surfaceVariant.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(context.dimens.pillRadius),
            border: Border.all(
              color: context.colors.divider.withValues(alpha: 0.7),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.language_rounded,
                size: context.dimens.iconSm,
                color: context.colors.primary,
              ),
              SizedBox(width: context.dimens.xs),
              Text(
                isUrdu ? 'اردو' : 'EN',
                style: textStyle?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
