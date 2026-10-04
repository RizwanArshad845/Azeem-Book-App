/// Support address shown in the "Account deleted" dialog and used as the
/// `mailto:` target. Deliberately hardcoded rather than read from the
/// backend's `contactEmail` (which is `null` unless the server sets
/// `ACCOUNT_RECOVERY_EMAIL`).
// TODO(support-email): placeholder — replace with the real support address
// before release.
const String kSupportEmail = 'support@example.com';

/// Subject line prefilled on the "Email support" `mailto:` link.
const String kAccountRecoveryEmailSubject = 'Account recovery request';
