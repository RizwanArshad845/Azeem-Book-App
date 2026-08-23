/// Up to two initials from a full [name] for gradient avatar badges — e.g.
/// "Ali Raza" -> "AR", a lone "Ali" -> "A". Shared by every "welcome
/// {name}"-style header (teacher overview, student home) instead of each
/// feature reimplementing the same parsing.
String nameInitials(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
  return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
      .toUpperCase();
}
