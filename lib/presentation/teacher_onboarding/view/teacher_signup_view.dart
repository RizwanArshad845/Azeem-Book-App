import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/onboarding_scaffold.dart';
import '../../../domain/teacher_onboarding/entities/teacher.dart';
import '../viewmodel/teacher_onboarding_viewmodel.dart';
import '../widgets/teacher_signup_form.dart';

/// Self-signup multi-step flow for teachers using standard OnboardingScaffold floating layout.
class TeacherSignupView extends ConsumerStatefulWidget {
  const TeacherSignupView({super.key});

  @override
  ConsumerState<TeacherSignupView> createState() => _TeacherSignupViewState();
}

class _TeacherSignupViewState extends ConsumerState<TeacherSignupView> {
  int _currentStep = 1;

  void _onStepChanged(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  void _onBack() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final onboarding = ref.watch(teacherOnboardingViewModelProvider);

    return OnboardingScaffold(
      appBarTitle: context.l10n.teacherSignupTitle,
      currentStep: _currentStep,
      totalSteps: 4,
      onBack: _currentStep > 1 ? _onBack : null,
      child: AsyncValueWidget<Teacher?>(
        value: onboarding,
        onRetry: () => ref.invalidate(teacherOnboardingViewModelProvider),
        data: (teacher) {
          if (teacher != null) {
            return EmptyStateView(
              icon: Icons.check_circle_outline,
              message: context.l10n.teacherAccountAlreadySetUp,
            );
          }
          return TeacherSignupForm(
            currentStep: _currentStep,
            onStepChanged: _onStepChanged,
          );
        },
      ),
    );
  }
}
