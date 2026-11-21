import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_dialog.dart';
import '../../../domain/auth/entities/user_role.dart';
import '../../../domain/common/failure.dart';
import '../viewmodel/auth_viewmodel.dart';

/// Handles the backend's account-state failures (`account_deleted`,
/// `phone_registered_other_role`, `phone_already_registered`) with a dialog
/// instead of a snackbar. Returns `true` when [failure] was one of them (the
/// caller must then skip its normal snackbar/error UI), `false` otherwise.
///
/// `account_deleted` is already shown app-wide by `App` (via
/// `SessionExpiryNotifier.onAccountDeleted`), so it only reports `true` here
/// to suppress the duplicate snackbar.
bool isAccountStateFailure(Failure failure) =>
    failure is AccountDeletedFailure ||
    failure is PhoneRegisteredOtherRoleFailure ||
    failure is PhoneAlreadyRegisteredFailure ||
    failure is AccountRegisteredOtherRoleFailure ||
    failure is EmailAlreadyRegisteredFailure;

bool handleAccountStateFailure(
  BuildContext context,
  WidgetRef ref,
  Failure failure,
) {
  switch (failure) {
    case AccountDeletedFailure():
      return true;
    case AccountRegisteredOtherRoleFailure(:final existingRole):
      _showOtherRoleDialog(context, ref, existingRole);
      return true;
    case PhoneRegisteredOtherRoleFailure(:final existingRole):
      // Signup only (phone numbers are unique across roles): the number is
      // taken, so the user must enter another one — let the form show it.
      _showPhoneTakenDialog(
        context,
        context.l10n.phoneRegisteredOtherRoleTitle,
        context.l10n.phoneRegisteredOtherRoleMessage(existingRole),
      );
      return true;
    case PhoneAlreadyRegisteredFailure():
      _showPhoneTakenDialog(
        context,
        context.l10n.phoneAlreadyRegisteredTitle,
        context.l10n.phoneAlreadyRegisteredMessage,
      );
      return true;
    case EmailAlreadyRegisteredFailure():
      _showAlreadyRegisteredDialog(context, ref);
      return true;
    default:
      return false;
  }
}

UserRole? _parseRole(String raw) => switch (raw) {
  'teacher' => UserRole.teacher,
  'student' => UserRole.student,
  _ => null,
};

/// Returns to the login flow: clears any local session (signup happens after
/// OTP verification, so one may exist) and routes to phone entry.
Future<void> _backToLogin(
  BuildContext context,
  WidgetRef ref, {
  UserRole? role,
}) async {
  // Everything that needs `context`/`ref` is read up front: navigating below
  // can dispose the widget those belong to.
  final auth = ref.read(authViewModelProvider.notifier);
  final router = GoRouter.of(context);
  final navigator = Navigator.of(context, rootNavigator: true);
  final hasSession = ref.read(currentUserProvider) != null;

  if (role != null) auth.selectRole(role);
  navigator.popUntil((route) => route is! PopupRoute);
  // Logging out also forgets the Google account, so the next sign-in shows
  // the account picker.
  if (hasSession) await auth.logout();
  router.go(AppRoutes.authSignIn);
}

Future<void> _showPhoneTakenDialog(
  BuildContext context,
  String title,
  String message,
) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AppDialog(
      title: title,
      subtitle: message,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(dialogContext.l10n.commonOk),
        ),
      ],
      child: const SizedBox.shrink(),
    ),
  );
}

Future<void> _showOtherRoleDialog(
  BuildContext context,
  WidgetRef ref,
  String existingRole,
) {
  final role = _parseRole(existingRole);
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AppDialog(
      title: dialogContext.l10n.accountRegisteredOtherRoleTitle,
      subtitle: dialogContext.l10n.accountRegisteredOtherRoleMessage(
        existingRole,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(dialogContext).pop();
            _backToLogin(context, ref);
          },
          child: Text(dialogContext.l10n.useDifferentGoogleAccount),
        ),
        if (role != null)
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _backToLogin(context, ref, role: role);
            },
            child: Text(dialogContext.l10n.phoneLogInAsRole(existingRole)),
          ),
      ],
      child: const SizedBox.shrink(),
    ),
  );
}

Future<void> _showAlreadyRegisteredDialog(BuildContext context, WidgetRef ref) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AppDialog(
      title: dialogContext.l10n.phoneAlreadyRegisteredTitle,
      subtitle: dialogContext.l10n.emailAlreadyRegisteredMessage,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(dialogContext).pop();
            _backToLogin(context, ref);
          },
          child: Text(dialogContext.l10n.phoneGoToLogin),
        ),
      ],
      child: const SizedBox.shrink(),
    ),
  );
}
