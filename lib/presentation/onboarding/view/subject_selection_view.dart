import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_dropdown.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../viewmodel/onboarding_viewmodel.dart';
import '../widgets/onboarding_card_scaffold.dart';

class SubjectSelectionView extends ConsumerWidget {
  const SubjectSelectionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final dimens = context.dimens;
    final state = ref.watch(onboardingViewModelProvider);
    final optionsAsync = ref.watch(subjectOptionsProvider);
    final notifier = ref.read(onboardingViewModelProvider.notifier);

    return OnboardingCardScaffold(
      icon: Icons.collections_bookmark_rounded,
      title: context.l10n.subjectSelectionTitle,
      subtitle: context.l10n.subjectSelectionSubtitle,
      child: optionsAsync.when(
        data: (allSubjects) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // List of Subject Selection Dropdowns
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.subjectCount,
                separatorBuilder: (_, _) => SizedBox(height: dimens.md),
                itemBuilder: (context, index) {
                  final selectedElsewhere = {
                    for (var i = 0; i < state.subjects.length; i++)
                      if (i != index && state.subjects[i].isNotEmpty)
                        state.subjects[i],
                  };
                  final available = allSubjects
                      .where((s) => !selectedElsewhere.contains(s))
                      .toList();
                  return AppDropdown<String>(
                    label: context.l10n.subjectSelectionLabel(index + 1),
                    items: available,
                    selectedItem:
                        state.subjects[index].isEmpty ? null : state.subjects[index],
                    onChanged: (value) => notifier.setSubjectAt(index, value ?? ''),
                  );
                },
              ),
              SizedBox(height: dimens.xl),

              // Confirm / Complete Button
              SizedBox(
                width: double.infinity,
                height: dimens.buttonHeight,
                child: ElevatedButton(
                  onPressed: state.isSubjectSelectionComplete
                      ? () {
                          notifier.submit();
                          context.go(AppRoutes.home);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    disabledBackgroundColor: colors.surfaceVariant,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(dimens.pillRadius),
                    ),
                  ),
                  child: Text(
                    context.l10n.commonConfirm,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: LoadingIndicator(),
        ),
        error: (_, _) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            context.l10n.commonErrorGeneric,
            style: TextStyle(color: colors.error),
          ),
        ),
      ),
    );
  }
}
