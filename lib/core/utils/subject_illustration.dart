import '../constants/app_assets.dart';

/// Maps a catalog `Subject.name` (as seeded in `catalog_dummy_datasource.dart`)
/// to a per-subject illustration asset path, parallel to [subjectIcon]. Returns
/// the generic-subject illustration for unmatched names so callers always get a
/// path; the widget layer still applies an `errorBuilder` native-icon fallback
/// when the actual file is missing from `assets/illustrations/` (Round-2 rule:
/// illustration first, icon fallback — see CLAUDE.md §Student Class & Subject).
///
/// Matching mirrors [subjectIcon]: case-insensitive substring, most-specific
/// first so "computer science" isn't shadowed by the generic "science" check.
String subjectIllustration(String subjectName) {
  final name = subjectName.toLowerCase();

  if (name.contains('computer')) {
    return AppAssets.subjectIllustrationPath('computer');
  }
  if (name.contains('physics')) {
    return AppAssets.subjectIllustrationPath('physics');
  }
  if (name.contains('chem')) return AppAssets.subjectIllustrationPath('chemistry');
  if (name.contains('bio')) return AppAssets.subjectIllustrationPath('biology');
  if (name.contains('math')) return AppAssets.subjectIllustrationPath('maths');
  if (name.contains('english')) {
    return AppAssets.subjectIllustrationPath('english');
  }
  if (name.contains('urdu')) return AppAssets.subjectIllustrationPath('urdu');
  if (name.contains('account')) {
    return AppAssets.subjectIllustrationPath('accounting');
  }
  if (name.contains('econom')) {
    return AppAssets.subjectIllustrationPath('economics');
  }
  // Generic "Science" placeholder subject — after the specific matches above.
  if (name.contains('science')) {
    return AppAssets.subjectIllustrationPath('generic');
  }

  return AppAssets.subjectGeneric;
}
