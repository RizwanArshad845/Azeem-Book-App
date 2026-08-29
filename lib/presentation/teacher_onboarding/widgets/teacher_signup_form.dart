import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../viewmodel/teacher_signup_form_providers.dart';
import '../viewmodel/teacher_signup_form_state.dart';
import 'teacher_signup_step1_card.dart';
import 'teacher_signup_step2_card.dart';

/// 100% Stateless & Riverpod-driven teacher registration form — zero [setState].
class TeacherSignupForm extends ConsumerWidget {
  const TeacherSignupForm({super.key});

  String _classIdsKey(Set<String> classIds) {
    final sorted = classIds.toList()..sort();
    return sorted.join(',');
  }

  void _handleNextStep1(
    BuildContext context,
    TeacherFormNotifier notifier,
  ) {
    if (notifier.validateStep1(
      requiredNameMsg: context.l10n.teacherSignupNameError,
      requiredCampusMsg: context.l10n.teacherSignupCampusError,
    )) {
      notifier.setStep(2);
    }
  }

  void _handleSubmit(
    BuildContext context,
    TeacherFormNotifier notifier,
  ) {
    // Step 1 is already guaranteed valid by the time step 2 is reachable —
    // `_handleNextStep1` only advances `currentStep` after `validateStep1`
    // passes, and the only way back to step 1 is `onBack`, which requires
    // re-validating step 1 to return here. Re-checking it at submit time
    // would set step-1 field errors the user can no longer see (step 2's
    // card is the one on screen), so only step 2 needs validating here.
    final isStep2Valid = notifier.validateStep2(
      requiredClassesMsg: context.l10n.teacherSignupClassesEmpty,
      requiredSubjectsMsg: context.l10n.teacherSignupSubjectsError,
    );

    if (!isStep2Valid) return;

    // Actual submission (`submitSignUp`) happens on the Review screen, once
    // the teacher has had a chance to double-check everything.
    context.push(AppRoutes.teacherOnboardingReview);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(teacherFormNotifierProvider);
    final notifier = ref.read(teacherFormNotifierProvider.notifier);

    final stepChild = formState.currentStep == 1
        ? TeacherSignupStep1Card(
            key: const ValueKey('step1'),
            name: formState.name,
            campus: formState.campus,
            studentCount: formState.studentCount,
            campusesAsync: ref.watch(teacherSignupCampusesProvider),
            nameError: formState.nameError,
            campusError: formState.campusError,
            onNameChanged: notifier.updateName,
            onCampusChanged: notifier.updateCampus,
            onStudentCountChanged: notifier.updateStudentCount,
            onNext: () => _handleNextStep1(context, notifier),
            onRetryCampuses: () =>
                ref.invalidate(teacherSignupCampusesProvider),
          )
        : TeacherSignupStep2Card(
            key: const ValueKey('step2'),
            selectedClassIds: formState.selectedClassIds,
            selectedSubjectIds: formState.selectedSubjectIds,
            boardClassesAsync: ref.watch(teacherSignupBoardClassesProvider),
            subjectsAsync: ref.watch(
              teacherSignupSubjectsForClassesProvider(
                _classIdsKey(formState.selectedClassIds),
              ),
            ),
            classesError: formState.classesError,
            subjectsError: formState.subjectsError,
            isSubmitting: false,
            onClassesChanged: notifier.updateClasses,
            onSubjectsChanged: notifier.updateSubjects,
            onBack: () => notifier.setStep(1),
            onSubmit: () => _handleSubmit(context, notifier),
            onRetryBoardClasses: () =>
                ref.invalidate(teacherSignupBoardClassesProvider),
            onRetrySubjects: () => ref.invalidate(
              teacherSignupSubjectsForClassesProvider(
                _classIdsKey(formState.selectedClassIds),
              ),
            ),
          );

    // A quick directional crossfade between steps reads as forward/backward
    // progress instead of the form instantly jump-cutting.
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        final offset = Tween<Offset>(
          begin: Offset(child.key == const ValueKey('step2') ? 0.08 : -0.08, 0),
          end: Offset.zero,
        ).animate(animation);
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: offset, child: child),
        );
      },
      child: stepChild,
    );
  }
}
