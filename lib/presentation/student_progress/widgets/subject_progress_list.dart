import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/skeleton.dart';
import '../viewmodel/student_progress_viewmodel.dart';
import 'subject_progress_card.dart';

/// Per-Subject filter body — one [SubjectProgressCard] per subject the
/// student has attempted a test in. Empty state reuses the shared
/// `EmptyStateView` (centered, per §10.1) rather than a bespoke one, even
/// though this is a different emptiness condition than the top-level
/// "no attempts at all" case in `StudentProgressView` (this one can fire
/// when attempts exist but couldn't be resolved to a subject).
class SubjectProgressList extends ConsumerWidget {
  const SubjectProgressList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summariesAsync = ref.watch(perSubjectProgressProvider);

    return AsyncValueWidget<List<SubjectProgressSummary>>(
      value: summariesAsync,
      onRetry: () => ref.invalidate(perSubjectProgressProvider),
      skeleton: const SkeletonList(itemCount: 4),
      data: (summaries) {
        if (summaries.isEmpty) {
          return EmptyStateView(
            icon: Icons.donut_large_outlined,
            message: context.l10n.progressSubjectEmpty,
          );
        }

        return Column(
          children: [
            for (final summary in summaries) ...[
              SubjectProgressCard(summary: summary),
              SizedBox(height: context.dimens.md),
            ],
          ],
        );
      },
    );
  }
}
