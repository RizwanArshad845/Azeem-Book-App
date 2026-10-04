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
    failure is PhoneAlreadyRegisteredFailure;

bool handleAccountStateFailure(
  BuildContext context,
  WidgetRef ref,
  Failure failure,
) {
  switch (failure) {
    case AccountDeletedFailure():
      return true;
    case PhoneRegisteredOtherRoleFailure(:final existingRole):
      _showOtherRoleDialog(context, ref, existingRole);
      return true;
    case PhoneAlreadyRegisteredFailure():
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
  bool keepPhone = true,
}) async {
  // Everything that needs `context`/`ref` is read up front: closing the OTP
  // bottom sheet below disposes the widget those belong to.
  final auth = ref.read(authViewModelProvider.notifier);
  final router = GoRouter.of(context);
  final navigator = Navigator.of(context, rootNavigator: true);
  final hasSession = ref.read(currentUserProvider) != null;

  if (role != null) auth.selectRole(role);
  if (!keepPhone) auth.clearEnteredPhoneNumber();
  // Close the OTP sheet (a popup route) if this came from verifying a code.
  navigator.popUntil((route) => route is! PopupRoute);
  if (hasSession) await auth.logout();
  router.go(AppRoutes.authPhone);
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
      title: dialogContext.l10n.phoneRegisteredOtherRoleTitle,
      subtitle: dialogContext.l10n.phoneRegisteredOtherRoleMessage(
        existingRole,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(dialogContext).pop();
            _backToLogin(context, ref, keepPhone: false);
          },
          child: Text(dialogContext.l10n.phoneUseDifferentNumber),
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
      subtitle: dialogContext.l10n.phoneAlreadyRegisteredMessage,
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
