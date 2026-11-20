import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/riverpod_providers.dart';
import '../../../domain/study_activity/entities/last_activity.dart';
import '../../../domain/test_taking/usecases/compute_study_streak.dart';
import '../../student_progress/viewmodel/student_progress_viewmodel.dart';

/// The student's last opened subject hub / test / ebook (Home's "Continue
/// where you left off" card). Persisted locally; null hides the card.
class LastActivityNotifier extends Notifier<LastActivity?> {
  @override
  LastActivity? build() =>
      ref.read(studyActivityRepositoryProvider).getLastActivity();

  void recordSubjectHub({required String subjectId, String? subjectName}) =>
      _record(
        LastActivity(
          kind: LastActivityKind.subjectHub,
          subjectId: subjectId,
          subjectName: subjectName,
          recordedAt: DateTime.now(),
        ),
      );

  void recordTest({
    required String subjectId,
    required String testId,
    required String testTitle,
    String? chapterId,
  }) => _record(
    LastActivity(
      kind: LastActivityKind.test,
      subjectId: subjectId,
      testId: testId,
      testTitle: testTitle,
      chapterId: chapterId,
      recordedAt: DateTime.now(),
    ),
  );

  void recordEbook({required String subjectId, required bool offline}) =>
      _record(
        LastActivity(
          kind: LastActivityKind.ebook,
          subjectId: subjectId,
          offline: offline,
          recordedAt: DateTime.now(),
        ),
      );

  void _record(LastActivity activity) {
    state = activity;
    ref.read(studyActivityRepositoryProvider).saveLastActivity(activity);
  }
}

final lastActivityProvider =
    NotifierProvider<LastActivityNotifier, LastActivity?>(
      LastActivityNotifier.new,
    );

/// Consecutive days (ending today or yesterday) with at least one submitted
/// test attempt — see [computeStudyStreak]. 0 while attempts are loading.
final studyStreakProvider = Provider<int>((ref) {
  final attempts = ref.watch(studentTestAttemptsProvider).value;
  if (attempts == null) return 0;
  return computeStudyStreak(
    attempts.map((a) => a.submittedAt ?? a.attemptedAt),
    now: DateTime.now(),
  );
});
