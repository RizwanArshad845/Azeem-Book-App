sealed class Failure {
  const Failure();

  String get message;
}

class AssetLoadFailure extends Failure {
  const AssetLoadFailure([this.details]);

  final String? details;

  @override
  String get message =>
      'Failed to load required data.${details != null ? ' $details' : ''}';
}

class ParsingFailure extends Failure {
  const ParsingFailure([this.details]);

  final String? details;

  @override
  String get message =>
      'Failed to parse data.${details != null ? ' $details' : ''}';
}

class ValidationFailure extends Failure {
  const ValidationFailure(this.message);

  @override
  final String message;
}

class UnknownFailure extends Failure {
  const UnknownFailure([this.details]);

  final String? details;

  @override
  String get message =>
      'Something went wrong.${details != null ? ' $details' : ''}';
}

class NetworkFailure extends Failure {
  const NetworkFailure([this.details]);

  final String? details;

  @override
  String get message =>
      'No internet connection.${details != null ? ' $details' : ''}';
}

class ServerFailure extends Failure {
  const ServerFailure([this.details]);

  final String? details;

  @override
  String get message =>
      'Something went wrong on our end.${details != null ? ' $details' : ''}';
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([this.details]);

  final String? details;

  @override
  String get message =>
      'You are not authorized to do this.${details != null ? ' $details' : ''}';
}

/// Backend `account_deleted` (403 on OTP request/verify/signup, 401 on any
/// authenticated call): the account was soft-deleted and only support can
/// restore it. [contactEmail] is the backend's optional override; the app
/// shows its own hardcoded support email regardless.
class AccountDeletedFailure extends Failure {
  const AccountDeletedFailure([this.contactEmail]);

  final String? contactEmail;

  @override
  String get message => 'This account has been deleted.';
}

/// Backend `phone_registered_other_role` (409): the number already belongs to
/// an account of the other role. [existingRole] is `"teacher"` or `"student"`.
class PhoneRegisteredOtherRoleFailure extends Failure {
  const PhoneRegisteredOtherRoleFailure(this.existingRole);

  final String existingRole;

  @override
  String get message =>
      'This number is already registered as a $existingRole account.';
}

/// Backend `phone_already_registered` (409): signup race — the same number
/// was registered a moment ago. Retrying signup won't help; log in instead.
class PhoneAlreadyRegisteredFailure extends Failure {
  const PhoneAlreadyRegisteredFailure();

  @override
  String get message => 'An account with this phone number already exists.';
}

/// Backend `teacher_not_selectable` (400): the chosen teacher is from another
/// campus, not approved, or deleted. The teacher list should be refreshed.
class TeacherNotSelectableFailure extends Failure {
  const TeacherNotSelectableFailure();

  @override
  String get message => "This teacher isn't available for your campus.";
}

/// Backend `teacher_locked_after_purchase` (400): the subject's bundle was
/// already bought, so its teacher can no longer be set, changed or removed.
class TeacherLockedAfterPurchaseFailure extends Failure {
  const TeacherLockedAfterPurchaseFailure();

  @override
  String get message => "The teacher can't be changed after purchase.";
}

/// Backend `already_enrolled` (409): `POST` for a subject the student already
/// has — use `PATCH` (or just refresh) instead.
class AlreadyEnrolledFailure extends Failure {
  const AlreadyEnrolledFailure();

  @override
  String get message => 'You are already enrolled in this subject.';
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([this.details]);

  final String? details;

  @override
  String get message => 'Not found.${details != null ? ' $details' : ''}';
}
