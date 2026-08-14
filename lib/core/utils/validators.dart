class Validators {
  const Validators._();

  static bool isValidPhone10Digits(String value) {
    return RegExp(r'^\d{10}$').hasMatch(value);
  }

  static bool isRequired(String value) => value.trim().isNotEmpty;

  static bool isValidClassCode(String value) {
    if (value.isEmpty) return true;
    return RegExp(r'^[A-Za-z0-9]{6}$').hasMatch(value);
  }
}
