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
  double get avatarLg => AppDimens.avatarLg;

  double get contentMaxWidth => AppDimens.contentMaxWidth;
  double get dialogMaxWidth => AppDimens.dialogMaxWidth;
  double get dragHandleWidth => AppDimens.dragHandleWidth;
  double get dragHandleHeight => AppDimens.dragHandleHeight;
  double get buttonHeight => AppDimens.buttonHeight;
  double get logoWatermarkSize => AppDimens.logoWatermarkSize;
}
