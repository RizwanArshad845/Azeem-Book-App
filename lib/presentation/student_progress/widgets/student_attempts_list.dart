import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../domain/test_taking/entities/test_attempt.dart';
import '../viewmodel/student_progress_viewmodel.dart';
import 'attempt_card.dart';

class StudentAttemptsList extends ConsumerWidget {
  const StudentAttemptsList({super.key, required this.attempts});

  final List<TestAttempt> attempts;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testsByIdAsync = ref.watch(progressTestsByIdProvider);
    final testsById = testsByIdAsync.value ?? const {};

    return Column(
      children: [
        for (final attempt in attempts) ...[
          AttemptCard(
            attempt: attempt,
            testTitle: testsById[attempt.testId]?.title ?? context.l10n.testTakingTitle,
          ),
          SizedBox(height: context.dimens.md),
        ],
      ],
    );
  }
}
