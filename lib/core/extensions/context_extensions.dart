import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

extension ContextExtensions on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;

  AppDimensType get dimens => const AppDimensType();

  AppLocalizations get l10n => AppLocalizations.of(this)!;

  TextTheme get textStyles => Theme.of(this).textTheme;
}

class AppDimensType {
  const AppDimensType();

  double get xs => AppDimens.xs;
  double get sm => AppDimens.sm;
  double get md => AppDimens.md;
  double get lg => AppDimens.lg;
  double get xl => AppDimens.xl;
  double get xxl => AppDimens.xxl;

  double get radiusSm => AppDimens.radiusSm;
  double get radiusMd => AppDimens.radiusMd;
  double get radiusLg => AppDimens.radiusLg;
  double get radiusXl => AppDimens.radiusXl;
  double get pillRadius => AppDimens.pillRadius;

  double get iconSm => AppDimens.iconSm;
  double get iconMd => AppDimens.iconMd;
  double get iconLg => AppDimens.iconLg;
  double get avatarSm => AppDimens.avatarSm;
  double get avatarMd => AppDimens.avatarMd;
  double get avatarLg => AppDimens.avatarLg;

  double get contentMaxWidth => AppDimens.contentMaxWidth;
  double get dialogMaxWidth => AppDimens.dialogMaxWidth;
  double get dragHandleWidth => AppDimens.dragHandleWidth;
  double get dragHandleHeight => AppDimens.dragHandleHeight;
  double get buttonHeight => AppDimens.buttonHeight;
  double get logoWatermarkSize => AppDimens.logoWatermarkSize;

  double get fontSm => AppDimens.fontSm;
  double get fontMd => AppDimens.fontMd;
  double get fontLg => AppDimens.fontLg;
  double get fontXl => AppDimens.fontXl;
}

extension LocalizedSubjectName on AppLocalizations {
  String localizedSubjectName(String rawName) {
    switch (rawName.trim()) {
      case 'Computer Science':
        return subjectComputerScience;
      case 'Physics':
        return subjectPhysics;
      case 'Chemistry':
        return subjectChemistry;
      case 'Biology':
        return subjectBiology;
      case 'Mathematics':
      case 'Math':
        return subjectMathematics;
      case 'English':
        return subjectEnglish;
      case 'Urdu':
        return subjectUrdu;
      case 'Science':
        return subjectScience;
      case 'Principles of Accounting':
        return subjectAccounting;
      case 'Business Mathematics':
        return subjectBusinessMath;
      case 'Economics':
        return subjectEconomics;
      case 'Education':
        return subjectEducation;
      case 'Civics':
        return subjectCivics;
      default:
        return rawName;
    }
  }
}
