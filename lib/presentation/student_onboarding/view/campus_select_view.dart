import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_dropdown.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/section_progress_indicator.dart';
import '../../../domain/campus_directory/entities/campus.dart';
import '../viewmodel/student_onboarding_viewmodel.dart';

/// Step 1/3 of student onboarding (§10.2: onboarding pushed outside the
/// shell) — picks the student's campus, which later scopes the per-subject
/// teacher picker (`SubjectTeacherSelectView`) to teachers at this campus.
class CampusSelectView extends ConsumerStatefulWidget {
  const CampusSelectView({super.key});

  @override
  ConsumerState<CampusSelectView> createState() => _CampusSelectViewState();
}

class _CampusSelectViewState extends ConsumerState<CampusSelectView> {
  Campus? _selected;

  void _continue() {
    final selected = _selected;
    if (selected == null) return;
    ref
        .read(studentOnboardingViewModelProvider.notifier)
        .selectCampus(selected.id);
    context.push(AppRoutes.studentOnboardingBoardClass);
  }

  @override
  Widget build(BuildContext context) {
    final campusesAsync = ref.watch(campusesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.campusSelectTitle)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.dimens.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionProgressIndicator(currentStep: 0, totalSteps: 3),
              SizedBox(height: context.dimens.lg),
              Text(
                context.l10n.campusSelectSubtitle,
                style: context.textStyles.titleMedium,
              ),
              SizedBox(height: context.dimens.lg),
              Expanded(
                child: AsyncValueWidget<List<Campus>>(
                  value: campusesAsync,
                  onRetry: () => ref.invalidate(campusesProvider),
                  data: (campuses) => AppDropdown<Campus>(
                    label: context.l10n.campusLabel,
                    items: campuses,
                    selectedItem: _selected,
                    itemAsString: (c) => '${c.name} (${c.city})',
                    onChanged: (campus) =>
                        setState(() => _selected = campus),
                  ),
                ),
              ),
              SizedBox(height: context.dimens.lg),
              AppPrimaryButton(
                label: context.l10n.commonContinue,
                onPressed: _selected == null ? null : _continue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
