import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/widgets/app_card.dart';

class TeacherLanguageCard extends ConsumerWidget {
  const TeacherLanguageCard({super.key, required this.isEnglish});

  final bool isEnglish;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.profileLanguage, style: context.textStyles.titleSmall),
          SizedBox(height: context.dimens.sm),
          Wrap(
            spacing: context.dimens.sm,
            children: [
              ChoiceChip(
                label: Text(context.l10n.profileEnglish),
                selected: isEnglish,
                onSelected: (_) => ref
                    .read(localeProvider.notifier)
                    .setLocale(const Locale('en')),
              ),
              ChoiceChip(
                label: Text(context.l10n.profileUrdu),
                selected: !isEnglish,
                onSelected: (_) => ref
                    .read(localeProvider.notifier)
                    .setLocale(const Locale('ur')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
