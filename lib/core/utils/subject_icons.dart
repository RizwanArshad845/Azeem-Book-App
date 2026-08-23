import 'package:flutter/material.dart';

/// Single source of truth mapping a catalog `Subject.name` (as seeded in
/// `catalog_dummy_datasource.dart`) to a distinct native Flutter icon, per
/// CLAUDE.md's "Student Class & Subject Rules": "Native Flutter icons must
/// be used for subject representation" — every subject needs its own icon,
/// not one generic icon repeated everywhere.
///
/// Matching is case-insensitive substring based so seed-data label variants
/// — "Math" (9th/10th) vs "Mathematics" (11th/12th Pre-Engineering) — both
/// resolve to the same icon without needing a separate entry per variant.
/// Order matters: more specific checks (e.g. "computer science") run before
/// the generic "science" fallback so they aren't shadowed by it.
IconData subjectIcon(String subjectName) {
  final name = subjectName.toLowerCase();

  if (name.contains('computer')) return Icons.terminal_outlined;
  if (name.contains('physics')) return Icons.science_outlined;
  if (name.contains('chem')) return Icons.biotech_outlined;
  if (name.contains('bio')) return Icons.eco_outlined;
  if (name.contains('math')) return Icons.calculate_outlined;
  if (name.contains('english')) return Icons.menu_book_outlined;
  if (name.contains('urdu')) return Icons.language_outlined;
  // Generic "Science" (9th/10th combined-science placeholder subject) —
  // checked last so it never shadows the more specific physics/chem/bio/
  // computer-science matches above.
  if (name.contains('science')) return Icons.explore_outlined;

  return Icons.book_outlined;
}
