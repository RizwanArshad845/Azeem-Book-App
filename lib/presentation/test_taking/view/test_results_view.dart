import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../domain/test_taking/entities/test_attempt.dart';

/// Rendered by `TestTakingView` once `TestTakingState.status ==
/// TestTakingStatus.submitted` (no separate route — the submission result
/// is only ever reachable from having just finished this test, so it's
/// rendered in place rather than adding a new `AppRoutes` entry).
class TestResultsView extends StatelessWidget {
  const TestResultsView({super.key, required this.attempt});

  final TestAttempt attempt;

  @override
  Widget build(BuildContext context) {
    final scoreColor = attempt.scorePercent >= 75
        ? context.colors.success
        : attempt.scorePercent >= 50
        ? context.colors.warning
        : context.colors.error;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(context.dimens.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: [
                  AppCard(
                    child: Column(
                      children: [
                        Text(
                          context.l10n.testResultsScore,
                          style: context.textStyles.bodyMedium?.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                        SizedBox(height: context.dimens.sm),
                        Text(
                          '${attempt.scorePercent.toStringAsFixed(0)}%',
                          style: context.textStyles.headlineMedium?.copyWith(
                            color: scoreColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: context.dimens.lg),
                  if ((attempt.strongChapterIds ?? const []).isNotEmpty) ...[
                    Text(context.l10n.testResultsStrongChapters, style: context.textStyles.titleMedium),
                    SizedBox(height: context.dimens.sm),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final id in attempt.strongChapterIds!)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: context.dimens.xs / 2,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: context.colors.success,
                                    size: context.dimens.iconSm,
                                  ),
                                  SizedBox(width: context.dimens.sm),
                                  Expanded(child: Text(id)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.dimens.lg),
                  ],
                  if ((attempt.weakChapterIds ?? const []).isNotEmpty) ...[
                    Text(context.l10n.testResultsWeakChapters, style: context.textStyles.titleMedium),
                    SizedBox(height: context.dimens.sm),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final id in attempt.weakChapterIds!)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: context.dimens.xs / 2,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: context.colors.error,
                                    size: context.dimens.iconSm,
                                  ),
                                  SizedBox(width: context.dimens.sm),
                                  Expanded(child: Text(id)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: context.dimens.md),
            AppPrimaryButton(
              label: context.l10n.resultsReturnHome,
              onPressed: () => context.go(AppRoutes.studentHome),
            ),
          ],
        ),
      ),
    );
  }
}
