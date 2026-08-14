import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/chapter_score_tile.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../domain/diagnostic/entities/chapter_score_result.dart';
import '../viewmodel/results_viewmodel.dart';
import '../widgets/readiness_gauge.dart';

class ResultsView extends ConsumerWidget {
  const ResultsView({super.key});

  Color _bandColor(BuildContext context, ScoreBand band) {
    switch (band) {
      case ScoreBand.red:
        return context.colors.error;
      case ScoreBand.yellow:
        return context.colors.warning;
      case ScoreBand.green:
        return context.colors.success;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(resultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.resultsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            tooltip: context.l10n.resultsReturnHome,
            onPressed: () => context.go(AppRoutes.home),
          ),
        ],
      ),
      body: resultsAsync.when(
        data: (results) => ListView(
          padding: EdgeInsets.all(context.dimens.lg),
          children: [
            Center(
              child: Column(
                children: [
                  ReadinessGauge(percent: results.overallReadinessPercent),
                  SizedBox(height: context.dimens.sm),
                  Text(context.l10n.resultsOverallReadiness, style: context.textStyles.titleMedium),
                ],
              ),
            ),
            SizedBox(height: context.dimens.xl),
            SizedBox(
              height: 280,
              child: RadarChart(
                RadarChartData(
                  radarShape: RadarShape.polygon,
                  tickCount: 4,
                  ticksTextStyle: const TextStyle(color: Colors.transparent, fontSize: 0),
                  radarBorderData: BorderSide(color: context.colors.divider),
                  gridBorderData: BorderSide(color: context.colors.divider),
                  titleTextStyle: TextStyle(color: context.colors.textPrimary, fontSize: 11),
                  getTitle: (index, angle) => RadarChartTitle(
                    text: 'C${results.chapterScores[index].chapter}',
                    angle: angle,
                  ),
                  dataSets: [
                    RadarDataSet(
                      fillColor: context.colors.primary.withValues(alpha: 0.25),
                      borderColor: context.colors.primary,
                      borderWidth: 2,
                      entryRadius: 3,
                      dataEntries: results.chapterScores
                          .map((c) => RadarEntry(value: c.scorePercent))
                          .toList(),
                    ),
                    RadarDataSet(
                      fillColor: Colors.transparent,
                      borderColor: Colors.transparent,
                      entryRadius: 0,
                      dataEntries: List.generate(
                        results.chapterScores.length,
                        (_) => const RadarEntry(value: 100),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: context.dimens.xl),
            Text(context.l10n.resultsChapterScores, style: context.textStyles.titleMedium),
            Divider(color: context.colors.divider),
            for (final chapter in results.chapterScores)
              ChapterScoreTile(
                title: chapter.title,
                scorePercent: chapter.scorePercent,
                bandColor: _bandColor(context, chapter.band),
              ),
            SizedBox(height: context.dimens.xl),
            AppButton(
              label: context.l10n.resultsStudyPlanCta,
              onPressed: () => AppSnackbar.show(context, context.l10n.commonComingSoon),
            ),
            SizedBox(height: context.dimens.md),
            AppButton(
              label: context.l10n.resultsReturnHome,
              variant: AppButtonVariant.outlined,
              onPressed: () => context.go(AppRoutes.home),
            ),
          ],
        ),
        loading: () => const LoadingIndicator(),
        error: (_, _) => Center(child: Text(context.l10n.commonErrorGeneric)),
      ),
    );
  }
}
