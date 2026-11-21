import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../viewmodel/teacher_signup_form_providers.dart';
import '../viewmodel/teacher_signup_form_state.dart';
import 'teacher_signup_step1_card.dart';
import 'teacher_signup_step2_card.dart';

/// Riverpod-driven teacher registration form — zero [setState]. Owns the
/// `TextEditingController`s for the name and phone fields since they're the
/// only widgets in this subtree that survive step 1 <-> step 2 switching;
/// everything else stays derived straight from Riverpod state.
class TeacherSignupForm extends ConsumerStatefulWidget {
  const TeacherSignupForm({super.key});

  @override
  ConsumerState<TeacherSignupForm> createState() => _TeacherSignupFormState();
}

class _TeacherSignupFormState extends ConsumerState<TeacherSignupForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final formState = ref.read(teacherFormNotifierProvider);
    var name = formState.name;
    // First visit: prefill the name from the Google account.
    final googleName = ref.read(currentUserProvider)?.name?.trim();
    if (name.isEmpty && googleName != null && googleName.isNotEmpty) {
      name = googleName;
      // Deferred: providers can't be modified while the tree is building.
      Future.microtask(() {
        if (mounted) {
          ref.read(teacherFormNotifierProvider.notifier).updateName(googleName);
        }
      });
    }
    _nameController = TextEditingController(text: name);
    _phoneController = TextEditingController(text: formState.phoneNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

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
      invalidPhoneMsg: context.l10n.phoneInvalid,
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
  Widget build(BuildContext context) {
    final formState = ref.watch(teacherFormNotifierProvider);
    final notifier = ref.read(teacherFormNotifierProvider.notifier);

    // Resync only when something external changed the name (initial hydration,
    // or a future reset) — during normal typing `onNameChanged` already keeps
    // `formState.name` equal to `_nameController.text`, so this is a no-op.
    if (_nameController.text != formState.name) {
      _nameController.text = formState.name;
    }

    final stepChild = formState.currentStep == 1
        ? TeacherSignupStep1Card(
            key: const ValueKey('step1'),
            nameController: _nameController,
            phoneController: _phoneController,
            campus: formState.campus,
            studentCount: formState.studentCount,
            campusesAsync: ref.watch(teacherSignupCampusesProvider),
            nameError: formState.nameError,
            phoneError: formState.phoneError,
            campusError: formState.campusError,
            isNextEnabled: formState.isStep1Valid,
            onNameChanged: notifier.updateName,
            onPhoneChanged: notifier.updatePhoneNumber,
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
            uniqueBoardClassesAsync: ref.watch(
              teacherSignupUniqueBoardClassesProvider,
            ),
            subjectsAsync: ref.watch(
              teacherSignupSubjectsForClassesProvider(
                _classIdsKey(formState.selectedClassIds),
              ),
            ),
            classesError: formState.classesError,
            subjectsError: formState.subjectsError,
            isSubmitting: false,
            isContinueEnabled: formState.isStep2Valid,
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
