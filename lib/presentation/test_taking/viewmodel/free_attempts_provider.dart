import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../student_progress/viewmodel/student_progress_viewmodel.dart';

// Round-2 "attempts_limit" feature: a student gets
// [AppConfig.freeAttemptsPerStudent] free attempts total (any test, any
// chapter). "Remaining" is derived client-side from the existing
// `studentTestAttemptsProvider` (count of submitted attempts) — no new
// endpoint (see backend.md §4.4 note). Once exhausted, chapters/tests lock
// behind the upgrade/payment gate.

/// Remaining free attempts for the current student, clamped at 0.
final remainingFreeAttemptsProvider = FutureProvider<int>((ref) async {
  final attempts = await ref.watch(studentTestAttemptsProvider.future);
  final remaining = AppConfig.freeAttemptsPerStudent - attempts.length;
  return remaining < 0 ? 0 : remaining;
});

/// True once the student has used up all free attempts.
final attemptsExhaustedProvider = Provider<bool>((ref) {
  final remaining = ref.watch(remainingFreeAttemptsProvider).value;
  return remaining != null && remaining <= 0;
});
