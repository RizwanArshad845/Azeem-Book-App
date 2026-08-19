import 'package:freezed_annotation/freezed_annotation.dart';

part 'live_test_registration.freezed.dart';

/// Join entity between a Student and an Admin-scheduled live `Test`
/// (project_spec.md §9.2). Created only when a student registers interest
/// in an already-scheduled live test (`Test.isLive == true`) — a student
/// never creates, edits, or triggers a live test itself; that is exclusively
/// an Admin action against the `Test` entity (`isLive`/`liveDate`).
///
/// `finalScore`/`timingSeconds`/`prizeRank` are part of the §9.2 schema but
/// are reserved for the Phase-2 leaderboard build-out (§11 Phase-1 scope:
/// "Live tests | Beta (register + run)" explicitly excludes leaderboard UI
/// in Phase 1) — this feature never displays them; they exist here only so
/// the schema/entity shape matches what a later grading/leaderboard pipeline
/// will populate.
@freezed
abstract class LiveTestRegistration with _$LiveTestRegistration {
  const factory LiveTestRegistration({
    required String id,
    required String studentId,
    required String testId,
    required DateTime registeredAt,
    double? finalScore,
    int? timingSeconds,
    int? prizeRank,
  }) = _LiveTestRegistration;
}
