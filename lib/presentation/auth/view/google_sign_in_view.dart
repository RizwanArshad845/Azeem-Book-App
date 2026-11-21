import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/onboarding_scaffold.dart';
import '../../../core/widgets/onboarding_step_header.dart';
import '../../../domain/auth/entities/auth_session.dart';
import '../../../domain/auth/entities/user_role.dart';
import '../../../domain/common/failure.dart';
import '../viewmodel/auth_viewmodel.dart';
import '../widgets/account_state_failure_handler.dart';

/// Second screen of the auth flow — signs in with Google for the role picked
/// on `RoleSelectView`. On success the router redirect takes over (signup,
/// onboarding, pending approval or dashboard, from the session's `status`).
class GoogleSignInView extends ConsumerWidget {
  const GoogleSignInView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<AuthSession?>>(authViewModelProvider, (_, next) {
      final failure = next.error;
      if (failure == null || !context.mounted) return;
      if (failure is Failure && handleAccountStateFailure(context, ref, failure)) {
        return;
      }
      AppSnackbar.show(
        context,
        failure is Failure
            ? failure.localizedMessage(context)
            : context.l10n.commonErrorGeneric,
      );
    });

    final isLoading = ref.watch(authViewModelProvider).isLoading;
    final role = ref.read(authViewModelProvider.notifier).selectedRole;

    return OnboardingScaffold(
      appBarTitle: context.l10n.googleSignInTitle,
      role: role == UserRole.teacher
          ? OnboardingRole.teacher
          : OnboardingRole.student,
      onBack: Navigator.of(context).canPop()
          ? () => Navigator.of(context).pop()
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OnboardingStepHeader(
            title: context.l10n.phoneWelcomeTitle,
            subtitle: context.l10n.googleSignInSubtitle,
          ),
          SizedBox(height: context.dimens.lg),
          AppPrimaryButton(
            label: context.l10n.googleSignInButton,
            loading: isLoading,
            onPressed: isLoading
                ? null
                : () => ref
                      .read(authViewModelProvider.notifier)
                      .signInWithGoogle(),
          ),
        ],
      ),
    );
  }
}
