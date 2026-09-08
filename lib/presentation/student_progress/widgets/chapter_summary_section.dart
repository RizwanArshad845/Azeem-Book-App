import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/skeleton.dart';
import '../viewmodel/student_progress_viewmodel.dart';
import 'chapter_progress_pie_chart.dart';

class ChapterSummarySection extends ConsumerWidget {
  const ChapterSummarySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(chapterProgressSummaryProvider);
    return AsyncValueWidget<ChapterProgressSummary>(
      value: summaryAsync,
      onRetry: () => ref.invalidate(chapterProgressSummaryProvider),
      skeleton: Center(
        child: Skeleton.circle(size: context.dimens.iconLg * 4),
      ),
      data: (summary) {
        if (summary.total == 0) return const SizedBox.shrink();
        return ChapterProgressPieChart(summary: summary);
      },
    );
  }
}
