import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Arabic-script block (U+0600–U+06FF) — matches any Urdu text, including
/// Urdu inside an otherwise-English subject (MOBILE_CHANGES.md §8.4).
final _urduScript = RegExp(r'[؀-ۿ]');

bool containsUrdu(String text) => _urduScript.hasMatch(text);

/// Bundled family name, as declared in `pubspec.yaml` once
/// `assets/fonts/JameelNooriNastaleeq.ttf` is added. Until then Flutter
/// can't find it and uses [_nastaliqFallback] — so the app works (in a
/// Nastaleeq face) with or without the bundled file.
const urduFontFamily = 'JameelNooriNastaleeq';

final String? _nastaliqFallback = GoogleFonts.notoNastaliqUrdu().fontFamily;

/// Urdu styling on top of [base]: Nastaleeq face and a tall line height —
/// Nastaleeq letters stack vertically and clip below ~1.8.
TextStyle urduTextStyle(TextStyle? base) {
  final size = base?.fontSize ?? 16;
  return (base ?? const TextStyle()).copyWith(
    fontFamily: urduFontFamily,
    fontFamilyFallback: [?_nastaliqFallback],
    // Nastaleeq reads small at Latin sizes.
    fontSize: size + 2,
    height: 2.0,
    // Bold synthetic weights smear Nastaleeq joins.
    fontWeight: FontWeight.normal,
  );
}

/// Drop-in for `Text` on content that may be Urdu (questions, options,
/// chapter/test titles, results). Urdu text — detected from the text itself,
/// or forced with [urdu] for an Urdu subject — renders in Nastaleeq,
/// right-to-left; anything else renders exactly like `Text`.
class UrduAwareText extends StatelessWidget {
  const UrduAwareText(
    this.text, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.urdu,
  });

  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  /// Force Urdu (true) or Latin (false) rendering; null = detect from [text].
  final bool? urdu;

  @override
  Widget build(BuildContext context) {
    final isUrdu = urdu ?? containsUrdu(text);
    if (!isUrdu) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
      );
    }
    // Right-aligned even inside a left-aligned (LTR) Column; heightFactor 1
    // keeps it from growing vertically under bounded height.
    return Align(
      alignment: Alignment.centerRight,
      heightFactor: 1,
      child: Text(
        text,
        style: urduTextStyle(style ?? DefaultTextStyle.of(context).style),
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign ?? TextAlign.start,
        textDirection: TextDirection.rtl,
      ),
    );
  }
}
