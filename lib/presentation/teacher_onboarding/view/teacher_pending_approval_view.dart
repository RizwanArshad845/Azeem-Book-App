import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_bar_title.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../domain/teacher_onboarding/entities/teacher.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
import '../../auth/widgets/onboarding_logout_action.dart';
import '../viewmodel/teacher_onboarding_viewmodel.dart';
import '../widgets/teacher_info_row.dart';

/// Shown once a self-signup Teacher is created and awaiting Admin approval
/// (`approvalStatus: pendingAdminApproval`, §9.1).
class TeacherPendingApprovalView extends ConsumerStatefulWidget {
  const TeacherPendingApprovalView({super.key});

  @override
  ConsumerState<TeacherPendingApprovalView> createState() =>
      _TeacherPendingApprovalViewState();
}

class _TeacherPendingApprovalViewState
    extends ConsumerState<TeacherPendingApprovalView> {
  bool _isChecking = false;
  bool _isLoggingOut = false;

  Future<void> _handleCheckStatus() async {
    setState(() => _isChecking = true);
    try {
      ref.invalidate(teacherOnboardingViewModelProvider);
      final updatedTeacher =
          await ref.read(teacherOnboardingViewModelProvider.future);
      if (!mounted) return;
      if (updatedTeacher == null ||
          teacherOnboardingStageOf(updatedTeacher) ==
              TeacherOnboardingStage.pendingApproval) {
        AppSnackbar.show(
          context,
          context.l10n.teacherPendingStillPendingMessage,
        );
      }
    } catch (_) {
      if (!mounted) return;
      AppSnackbar.show(
        context,
        context.l10n.teacherPendingStillPendingMessage,
      );
    } finally {
      if (mounted) {
        setState(() => _isChecking = false);
      }
    }
  }

  Future<void> _handleLogout() async {
    setState(() => _isLoggingOut = true);
    try {
      await ref.read(authViewModelProvider.notifier).logout();
    } finally {
      if (mounted) {
        setState(() => _isLoggingOut = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final onboarding = ref.watch(teacherOnboardingViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: AppBarTitle(context.l10n.teacherPendingTitle)),
      body: SafeArea(
        child: AsyncValueWidget<Teacher?>(
          value: onboarding,
          onRetry: () => ref.invalidate(teacherOnboardingViewModelProvider),
          data: (teacher) {
            if (teacher == null) {
              return EmptyStateView(
                icon: Icons.person_search_outlined,
                message: context.l10n.teacherPendingNotFound,
              );
            }

            final stage = teacherOnboardingStageOf(teacher);
            final isStillPending =
                stage == TeacherOnboardingStage.pendingApproval;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: context.dimens.contentMaxWidth,
                ),
                child: Padding(
                  padding: EdgeInsets.all(context.dimens.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        isStillPending
                            ? Icons.hourglass_top_outlined
                            : Icons.check_circle_outline,
                        size: context.dimens.iconLg * 1.5,
                        color: isStillPending
                            ? context.colors.warning
                            : context.colors.success,
                      ),
                      SizedBox(height: context.dimens.md),
                      Text(
                        isStillPending
                            ? context.l10n.teacherPendingAccountStatus
                            : context.l10n.teacherApprovedAccountStatus,
                        textAlign: TextAlign.center,
                        style: context.textStyles.titleMedium,
                      ),
                      SizedBox(height: context.dimens.sm),
                      Text(
                        isStillPending
                            ? context.l10n.teacherPendingNote
                            : context.l10n.teacherApprovedNote(teacher.name),
                        textAlign: TextAlign.center,
                        style: context.textStyles.bodyMedium?.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                      SizedBox(height: context.dimens.lg),
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TeacherInfoRow(label: context.l10n.nameLabel, value: teacher.name),
                            TeacherInfoRow(
                              label: context.l10n.phoneLabel,
                              value: teacher.phoneNumber,
                            ),
                            TeacherInfoRow(
                              label: context.l10n.teacherSignupSubjectsLabel,
                              value: teacher.subjectIds.length.toString(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: context.dimens.xl),
                      AppButton(
                        label: context.l10n.teacherPendingCheckStatus,
                        loading: _isChecking || onboarding.isLoading,
                        onPressed: (_isChecking || onboarding.isLoading || _isLoggingOut)
                            ? null
                            : _handleCheckStatus,
                      ),
                      SizedBox(height: context.dimens.sm),
                      AppButton(
                        label: context.l10n.backToLogin,
                        variant: AppButtonVariant.outlined,
                        loading: _isLoggingOut,
                        onPressed: (_isChecking || onboarding.isLoading || _isLoggingOut)
                            ? null
                            : _handleLogout,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
