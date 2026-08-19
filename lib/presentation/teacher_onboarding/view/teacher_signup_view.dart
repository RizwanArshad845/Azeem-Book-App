import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/onboarding_scaffold.dart';
import '../../../domain/teacher_onboarding/entities/teacher.dart';
import '../viewmodel/teacher_onboarding_viewmodel.dart';
import '../widgets/teacher_signup_form.dart';

/// Self-signup form for teachers using standard OnboardingScaffold floating layout.
class TeacherSignupView extends ConsumerWidget {
  const TeacherSignupView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboarding = ref.watch(teacherOnboardingViewModelProvider);

    return OnboardingScaffold(
      appBarTitle: context.l10n.teacherSignupTitle,
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
