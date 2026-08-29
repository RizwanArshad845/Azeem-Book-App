class AppAssets {
  const AppAssets._();

  static const String logo = 'assets/images/azeem_academy_logo.png';

  /// Illustration assets (see `assets/illustrations/README.md`). These are
  /// optional — widgets fall back to native icons when a file is absent — so
  /// they can be dropped in later without code changes.
  static const String _illustrations = 'assets/illustrations';

  static const String testPaper = '$_illustrations/test_paper.png';
  static const String practiceBank = '$_illustrations/practice_bank.png';
  static const String attemptsHint = '$_illustrations/attempts_hint.png';
  static const String trophy = '$_illustrations/trophy.png';
  static const String promoLive = '$_illustrations/promo_live.png';
  static const String promoDiscount = '$_illustrations/promo_discount.png';
  static const String emptyTests = '$_illustrations/empty_tests.png';
  static const String subjectGeneric = '$_illustrations/subject_generic.png';

  /// Builds a per-subject illustration path from a file stem, e.g.
  /// `subjectIllustrationPath('physics')` → `.../subject_physics.png`.
  static String subjectIllustrationPath(String stem) =>
      '$_illustrations/subject_$stem.png';
}
