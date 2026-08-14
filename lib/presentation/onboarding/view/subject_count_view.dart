import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_config.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../viewmodel/onboarding_viewmodel.dart';
import '../widgets/onboarding_card_scaffold.dart';
import '../widgets/subject_counter_card.dart';

class SubjectCountView extends ConsumerStatefulWidget {
  const SubjectCountView({super.key});

  @override
  ConsumerState<SubjectCountView> createState() => _SubjectCountViewState();
}

class _SubjectCountViewState extends ConsumerState<SubjectCountView> {
  late int _count;

  @override
  void initState() {
    super.initState();
    _count = ref.read(onboardingViewModelProvider).subjectCount;
  }

  void _onNext() {
    ref.read(onboardingViewModelProvider.notifier).setSubjectCount(_count);
    context.push(AppRoutes.onboardingSubjects);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimens = context.dimens;

    return OnboardingCardScaffold(
      icon: Icons.format_list_numbered_rounded,
      title: context.l10n.subjectCountTitle,
      subtitle: context.l10n.subjectCountSubtitle,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SubjectCounterCard(
            count: _count,
            minCount: AppConfig.subjectCountMin,
            maxCount: AppConfig.subjectCountMax,
            onIncrement: () => setState(() => _count++),
            onDecrement: () => setState(() => _count--),
          ),
          SizedBox(height: dimens.xl),

          // Next Button
          SizedBox(
            width: double.infinity,
            height: dimens.buttonHeight,
            child: ElevatedButton(
              onPressed: _onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(dimens.pillRadius),
                ),
              ),
              child: Text(
                context.l10n.commonNext,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
