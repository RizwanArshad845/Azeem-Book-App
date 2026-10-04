import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_bar_title.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../domain/teacher_onboarding/entities/teacher.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';
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
    extends ConsumerState<TeacherPendingApprovalView>
    with WidgetsBindingObserver {
  bool _isChecking = false;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Re-check approval when the app comes back to the foreground (no tight
  /// polling timer — there is no push yet, so this is how an approval made
  /// while the app was backgrounded gets noticed).
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _checkStatus(silent: true);
  }

  Future<void> _handleCheckStatus() => _checkStatus();

  /// Asks `GET /auth/session-status`. `DASHBOARD` updates the session, and
  /// the router redirect then moves the teacher to the dashboard; anything
  /// else keeps them here. [silent] suppresses the "still pending" snackbar
  /// (used for the automatic on-resume check).
  Future<void> _checkStatus({bool silent = false}) async {
    if (_isChecking || _isLoggingOut) return;
    setState(() => _isChecking = true);
    try {
      final status =
          await ref.read(authViewModelProvider.notifier).refreshSessionStatus();
      if (!mounted) return;
      if (status == 'DASHBOARD') {
        // Pick up the now-approved teacher record for the dashboard screens.
        ref.invalidate(teacherOnboardingViewModelProvider);
        return;
      }
      if (!silent) {
        AppSnackbar.show(
          context,
          status == null
              ? context.l10n.commonErrorGeneric
              : context.l10n.teacherPendingStillPendingMessage,
        );
      }
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
            // The routing status (not this lookup) decides we're on this
            // screen, so Refresh/Log out must stay reachable even when the
            // teacher record is missing — treat "no record" as still pending.
            final isStillPending =
                teacher == null ||
                teacherOnboardingStageOf(teacher) ==
                    TeacherOnboardingStage.pendingApproval;

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
                      if (teacher != null) ...[
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
                      ],
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
