import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../viewmodel/home_viewmodel.dart';
import '../widgets/home_feature_card.dart';
import '../widgets/subject_picker_sheet.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final header = ref.watch(homeHeaderProvider);
    final dimens = context.dimens;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.appTitle)),
      body: ListView(
        padding: EdgeInsets.all(dimens.lg),
        children: [
          Text(
            context.l10n.homeGreeting(header.name),
            style: context.textStyles.headlineSmall,
          ),
          SizedBox(height: dimens.xs),
          Text(header.college, style: TextStyle(color: context.colors.textSecondary)),
          SizedBox(height: dimens.xl),
          HomeFeatureCard(
            title: context.l10n.homeDiagnosticTestTitle,
            subtitle: context.l10n.homeDiagnosticTestSubtitle,
            icon: Icons.quiz_outlined,
            onTap: () => showModalBottomSheet<void>(
              context: context,
              builder: (_) => const SubjectPickerSheet(),
            ),
          ),
          SizedBox(height: dimens.md),
          HomeFeatureCard(
            title: context.l10n.homeAiGuessPapersTitle,
            subtitle: context.l10n.homeAiGuessPapersSubtitle,
            icon: Icons.auto_awesome_outlined,
            enabled: false,
            onTap: () => AppSnackbar.show(context, context.l10n.commonComingSoon),
          ),
          SizedBox(height: dimens.md),
          HomeFeatureCard(
            title: context.l10n.homeStudyPlanTitle,
            subtitle: context.l10n.homeStudyPlanSubtitle,
            icon: Icons.map_outlined,
            enabled: false,
            onTap: () => AppSnackbar.show(context, context.l10n.commonComingSoon),
          ),
        ],
      ),
    );
  }
}
