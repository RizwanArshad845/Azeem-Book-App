import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../domain/teacher_onboarding/entities/teacher.dart';
import '../viewmodel/teacher_onboarding_viewmodel.dart';
import '../widgets/teacher_signup_form.dart';

/// Self-signup form (§9.1): only reached when `TeacherOnboardingViewModel`
/// resolved to `null` — no salesman-seeded record matched the logged-in
/// phone number. Single scrollable screen, one primary action ("Submit for
/// approval") per §10.1.
class TeacherSignupView extends ConsumerWidget {
  const TeacherSignupView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboarding = ref.watch(teacherOnboardingViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.teacherSignupTitle)),
      body: SafeArea(
        child: AsyncValueWidget<Teacher?>(
          value: onboarding,
          onRetry: () => ref.invalidate(teacherOnboardingViewModelProvider),
          data: (teacher) {
            if (teacher != null) {
              // A record already exists for this phone number (seeded or a
              // signup already submitted) — nothing left to fill in here.
              return EmptyStateView(
                icon: Icons.check_circle_outline,
                message: context.l10n.teacherAccountAlreadySetUp,
              );
            }
            return const TeacherSignupForm();
          },
        ),
      ),
    );
  }
}
