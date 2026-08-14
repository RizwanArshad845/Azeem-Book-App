class AppDimens {
  const AppDimens._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 20;
  static const double radiusXl = 24;
  static const double pillRadius = 26;

  static const double iconSm = 16;
  static const double iconMd = 24;
  static const double iconLg = 32;
  static const double avatarLg = 68;

  /// Caps the width of centered form content (auth/onboarding cards) on
  /// wide screens.
  static const double contentMaxWidth = 420;

  /// Standard tappable button height, matching `AppTheme`'s button themes —
  /// used when a screen needs a custom button style that can't go through
  /// the shared button theme (e.g. a pill shape) but should still match its
  /// height.
  static const double buttonHeight = 52;

  /// Size of the blurred brand-logo watermark on onboarding backgrounds.
  static const double logoWatermarkSize = 360;

  static const double fontSm = 12;
  static const double fontMd = 14;
  static const double fontLg = 18;
  static const double fontXl = 24;
}
