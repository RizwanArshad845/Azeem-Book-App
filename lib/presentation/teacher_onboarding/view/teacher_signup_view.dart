import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/onboarding_scaffold.dart';
import '../../../domain/teacher_onboarding/entities/teacher.dart';
import '../../auth/widgets/onboarding_logout_action.dart';
import '../viewmodel/teacher_onboarding_viewmodel.dart';
import '../viewmodel/teacher_signup_form_state.dart';
import '../widgets/teacher_signup_form.dart';

/// Clean multi-step self-signup form for teachers using OnboardingScaffold — 100% Riverpod, zero [setState].
class TeacherSignupView extends ConsumerWidget {
  const TeacherSignupView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboarding = ref.watch(teacherOnboardingViewModelProvider);
    final formState = ref.watch(teacherFormNotifierProvider);
    final notifier = ref.read(teacherFormNotifierProvider.notifier);

    return OnboardingScaffold(
      appBarTitle: context.l10n.teacherSignupTitle,
      role: OnboardingRole.teacher,
      currentStep: formState.currentStep,
      totalSteps: 3,
      onBack: formState.currentStep == 2
          ? () => notifier.setStep(1)
          : null,
      onLogout: () => confirmOnboardingLogout(context, ref),
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
          return const TeacherSignupForm();
        },
      ),
    );
  }
}
