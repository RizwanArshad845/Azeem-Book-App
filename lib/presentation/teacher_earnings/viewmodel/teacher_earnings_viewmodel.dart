import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../domain/earnings/entities/earnings_record.dart';
import '../../../domain/earnings/usecases/get_earnings_for_teacher_usecase.dart';
import '../../teacher_overview/viewmodel/teacher_overview_viewmodel.dart';

/// Teacher shell Earnings tab (§10.2 "Detailed Earnings Dashboard") — a
/// read-only transaction-level breakdown behind the two summary numbers
/// already shown on the Overview tab's `_EarningsCard`
/// (`Teacher.actualEarnings`/`projectedEarnings`, untouched by this
/// feature). Nothing is written back from this screen: the only write path
/// for an `EarningsRecord` is `RecordEarningsUseCase`, invoked from
/// `student_cart`'s checkout flow — so a plain `FutureProvider` is enough
/// here, no `AsyncNotifier` needed (mirrors `cartTestsByIdProvider`'s
/// read-only `FutureProvider` pattern in `student_cart_viewmodel.dart`).
///
/// Depends on `currentTeacherProvider` (teacher_overview) the same way that
/// feature already reuses it, rather than re-deriving the logged-in
/// teacher's id a second way.
final teacherEarningsProvider = FutureProvider<List<EarningsRecord>>((
  ref,
) async {
  final teacher = ref.watch(currentTeacherProvider);
  if (teacher == null) return const <EarningsRecord>[];

  final result = await sl<GetEarningsForTeacherUseCase>()(teacher.id);
  return result.when(
    success: (records) => records,
    failure: (failure) => throw failure,
  );
});
