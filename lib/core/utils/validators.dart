class Validators {
  const Validators._();

  /// 11-digit local phone format: `03XXXXXXXXX` (CLAUDE.md's mandated
  /// format app-wide — replaces the old 10-digit + separate country-code
  /// prefix scheme).
  static bool isValidPhoneLocal(String value) {
    return RegExp(r'^03\d{9}$').hasMatch(value);
  }

  static bool isRequired(String value) => value.trim().isNotEmpty;

  static bool isValidClassCode(String value) {
    if (value.isEmpty) return true;
    return RegExp(r'^[A-Za-z0-9]{6}$').hasMatch(value);
  }
}
