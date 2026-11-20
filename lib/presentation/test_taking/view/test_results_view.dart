import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/section_breakdown_card.dart';
import '../../../core/widgets/stat_tile.dart';
import '../../../domain/catalog/entities/question.dart';
import '../../../domain/test_taking/entities/test_attempt.dart';
import '../../../domain/test_taking/usecases/compute_section_breakdown.dart';
import '../viewmodel/free_attempts_provider.dart';
import '../viewmodel/test_taking_viewmodel.dart';
import '../widgets/review_answers_sheet.dart';

/// Rendered by `TestTakingView` once the attempt is submitted. Redesigned to
/// the test_result reference: a score hero (X/total + %), a 3-up stats row
/// (Correct / Wrong / Time), a per-section marks breakdown, and Review /
/// Reattempt / Back actions. Reattempt is gated by the global free-attempts
/// limit. Sourced entirely from [attempt] — each graded `SubmissionAnswer`
/// is now self-describing (question text/type/marks), so no separate
/// question list needs to be fetched to render a result.
class TestResultsView extends ConsumerWidget {
  const TestResultsView({
    super.key,
    required this.testId,
    required this.attempt,
    this.isOwned = false,
    this.isHistoricalView = false,
  });

  final String testId;
  final TestAttempt attempt;

  /// Whether the test's subject has been purchased — exempts it from the
  /// global free-attempts exhaustion gate on Reattempt.
  final bool isOwned;

  /// True when viewing a past attempt (e.g. from the Progress tab) rather
  /// than right after submitting — hides Reattempt/Go-Home, showing only
  /// Review Answers.
  final bool isHistoricalView;

  String _sectionTitle(BuildContext context, int number, QuestionType type) {
    final label = switch (type) {
      QuestionType.mcq => context.l10n.sectionTypeMcq,
      QuestionType.shortAnswer => context.l10n.sectionTypeShort,
      QuestionType.longAnswer => context.l10n.sectionTypeLong,
    };
    return 'Q$number $label';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sections = computeSectionBreakdown(attempt.answers);
    final earned = sections.fold<int>(0, (s, x) => s + x.earnedMarks);
    final total = sections.fold<int>(0, (s, x) => s + x.totalMarks);
    final correct = sections.fold<int>(0, (s, x) => s + x.correct);
    final wrong = sections.fold<int>(0, (s, x) => s + x.wrong);
    final percent = total == 0 ? 0 : (earned / total * 100).round();
    final minutes = ((attempt.durationSeconds ?? 0) / 60).round();

    final tier = percent >= 80
        ? _ScoreTier.great
        : percent < 50
            ? _ScoreTier.low
            : _ScoreTier.neutral;
    final scoreColor = switch (tier) {
      _ScoreTier.great => context.colors.success,
      _ScoreTier.neutral => context.colors.warning,
      _ScoreTier.low => context.colors.error,
    };

    final exhausted = !isOwned && ref.watch(attemptsExhaustedProvider);
    final celebrate = tier == _ScoreTier.great &&
        !isHistoricalView &&
        !MediaQuery.disableAnimationsOf(context);

    void reviewAnswers() =>
        ReviewAnswersSheet.show(context, answers: attempt.answers);
    void reattempt() {
      if (exhausted) {
        AppSnackbar.show(context, context.l10n.attemptsBlockedMessage);
        return;
      }
      ref.invalidate(testTakingViewModelProvider(testId));
    }

    // Exactly one prominent action: Reattempt for a low score (the most
    // useful next step), Review Answers otherwise. The rest are text buttons.
    final reattemptIsPrimary = tier == _ScoreTier.low && !isHistoricalView;

    final results = SafeArea(
      child: Padding(
        padding: EdgeInsets.all(context.dimens.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: [
                  _ScoreHero(
                    earned: earned,
                    total: total,
                    percent: percent,
                    color: scoreColor,
                    tier: tier,
                  ),
                  SizedBox(height: context.dimens.md),
                  Row(
                    children: [
                      Expanded(
                        child: StatTile(
                          icon: Icons.check_circle_outline,
                          value: '$correct',
                          label: context.l10n.scoreCorrect,
                          color: context.colors.success,
                        ),
                      ),
                      SizedBox(width: context.dimens.sm),
                      Expanded(
                        child: StatTile(
                          icon: Icons.cancel_outlined,
                          value: '$wrong',
                          label: context.l10n.scoreWrong,
                          color: context.colors.error,
                        ),
                      ),
                      SizedBox(width: context.dimens.sm),
                      Expanded(
                        child: StatTile(
                          icon: Icons.timer_outlined,
                          value: context.l10n.scoreTimeValue(minutes),
                          label: context.l10n.scoreTimeTaken,
                          color: context.colors.primary,
                        ),
                      ),
                    ],
                  ),
                  if (sections.isNotEmpty) ...[
                    SizedBox(height: context.dimens.lg),
                    Text(
                      context.l10n.sectionBreakdownTitle,
                      style: context.textStyles.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: context.dimens.sm),
                    for (var i = 0; i < sections.length; i++)
                      Padding(
                        padding: EdgeInsets.only(bottom: context.dimens.sm),
                        child: SectionBreakdownCard(
                          title: _sectionTitle(context, i + 1, sections[i].type),
                          correct: sections[i].correct,
                          wrong: sections[i].wrong,
                          earnedMarks: sections[i].earnedMarks,
                          totalMarks: sections[i].totalMarks,
                        ),
                      ),
                  ],
                ],
              ),
            ),
            SizedBox(height: context.dimens.sm),
            if (reattemptIsPrimary)
              AppPrimaryButton(
                label: context.l10n.testResultsReattemptButton,
                icon: Icons.replay_rounded,
                onPressed: reattempt,
              )
            else
              AppPrimaryButton(
                label: context.l10n.reviewAnswersButton,
                icon: Icons.fact_check_outlined,
                onPressed: reviewAnswers,
              ),
            if (!isHistoricalView) ...[
              SizedBox(height: context.dimens.xs),
              Row(
                children: [
                  Expanded(
                    child: reattemptIsPrimary
                        ? AppButton(
                            label: context.l10n.reviewAnswersButton,
                            variant: AppButtonVariant.text,
                            onPressed: reviewAnswers,
                          )
                        : AppButton(
                            label: context.l10n.testResultsReattemptButton,
                            variant: AppButtonVariant.text,
                            onPressed: reattempt,
                          ),
                  ),
                  SizedBox(width: context.dimens.sm),
                  Expanded(
                    child: AppButton(
                      label: context.l10n.resultsReturnHome,
                      variant: AppButtonVariant.text,
                      onPressed: () => context.go(AppRoutes.studentHome),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );

    if (!celebrate) return results;
    return Stack(
      children: [
        results,
        const Positioned.fill(child: IgnorePointer(child: _ConfettiBurst())),
      ],
    );
  }
}

enum _ScoreTier { great, neutral, low }

class _ScoreHero extends StatelessWidget {
  const _ScoreHero({
    required this.earned,
    required this.total,
    required this.percent,
    required this.color,
    required this.tier,
  });

  final int earned;
  final int total;
  final int percent;
  final Color color;
  final _ScoreTier tier;

  @override
  Widget build(BuildContext context) {
    final message = switch (tier) {
      _ScoreTier.great => context.l10n.stuScoreGreat,
      _ScoreTier.neutral => context.l10n.stuScoreGood,
      _ScoreTier.low => context.l10n.stuScoreLow,
    };
    return AppCard(
      padding: EdgeInsets.all(context.dimens.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _scoreRow(context),
          SizedBox(height: context.dimens.md),
          Text(
            message,
            style: context.textStyles.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _scoreRow(BuildContext context) {
    return Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.l10n.testResultsScore,
                  style: context.textStyles.bodyMedium?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
                SizedBox(height: context.dimens.xs),
                Text(
                  '$earned/$total',
                  style: context.textStyles.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '$percent%',
                  style: context.textStyles.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(context.dimens.md),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(context.dimens.radiusLg),
            ),
            child: Icon(
              switch (tier) {
                _ScoreTier.great => Icons.emoji_events,
                _ScoreTier.neutral => Icons.insights_rounded,
                _ScoreTier.low => Icons.trending_up_rounded,
              },
              color: color,
              size: context.dimens.iconLg,
            ),
          ),
        ],
    );
  }
}

/// One-shot confetti burst over a great result (>= 80%). Small hand-rolled
/// particle painter (no package) driven by a single [AnimationController].
class _ConfettiBurst extends StatefulWidget {
  const _ConfettiBurst();

  @override
  State<_ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<_ConfettiBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..forward();

  late final List<_Particle> _particles = () {
    final random = math.Random(7);
    return List.generate(48, (i) {
      final angle = -math.pi / 2 + (random.nextDouble() - 0.5) * math.pi * 0.9;
      final speed = 0.55 + random.nextDouble() * 0.6;
      return _Particle(
        dx: math.cos(angle) * speed,
        dy: math.sin(angle) * speed,
        spin: (random.nextDouble() - 0.5) * 12,
        size: 5 + random.nextDouble() * 5,
        colorIndex: i,
      );
    });
  }();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = [
      context.colors.primary,
      context.colors.secondary,
      context.colors.accent,
      context.colors.success,
      context.colors.warning,
    ];
    return RepaintBoundary(
      child: CustomPaint(
        painter: _ConfettiPainter(
          progress: _controller,
          particles: _particles,
          palette: palette,
        ),
      ),
    );
  }
}

class _Particle {
  const _Particle({
    required this.dx,
    required this.dy,
    required this.spin,
    required this.size,
    required this.colorIndex,
  });

  final double dx;
  final double dy;
  final double spin;
  final double size;
  final int colorIndex;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({
    required this.progress,
    required this.particles,
    required this.palette,
  }) : super(repaint: progress);

  final Animation<double> progress;
  final List<_Particle> particles;
  final List<Color> palette;

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress.value;
    if (t == 0 || t == 1) return;
    // Burst from around the score card, then fall under gravity.
    final origin = Offset(size.width / 2, size.height * 0.22);
    final scale = size.shortestSide;
    const gravity = 1.6;
    final opacity = (1 - t).clamp(0.0, 1.0);
    final paint = Paint();
    for (final p in particles) {
      final position = origin +
          Offset(p.dx * t * scale, (p.dy * t + gravity * t * t / 2) * scale);
      paint.color =
          palette[p.colorIndex % palette.length].withValues(alpha: opacity);
      canvas
        ..save()
        ..translate(position.dx, position.dy)
        ..rotate(p.spin * t)
        ..drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 0.6,
          ),
          paint,
        )
        ..restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) =>
      oldDelegate.palette != palette;
}
