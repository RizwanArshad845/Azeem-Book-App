import '../../common/result.dart';
import '../entities/live_test_registration.dart';

/// Student registration-of-interest against an Admin-scheduled live `Test`
/// (project_spec.md §9.2 `LiveTestRegistration`; §11 Phase-1 "Live tests |
/// Beta (register + run)"). Concrete implementation calls the remote
/// datasource directly — never called directly from a viewmodel.
///
/// Deliberately has no "create/schedule a live test" method: that is the
/// `Test.isLive`/`Test.liveDate` surface owned by `CatalogRepository`
/// (Admin-only, out of this app's scope). This repository only ever reads
/// an existing live `Test.id` and records a student's interest in it.
abstract class LiveTestRegistrationRepository {
  /// Registers [studentId] for the live test [testId]. Idempotent: calling
  /// this again for a test the student is already registered for returns
  /// the existing registration rather than creating a duplicate.
  Future<Result<LiveTestRegistration>> registerForLiveTest({
    required String studentId,
    required String testId,
  });

  /// Every registration [studentId] has made, used to compute "already
  /// registered" state and to gate the "Enter" action once `Test.liveDate`
  /// has arrived.
  Future<Result<List<LiveTestRegistration>>> getRegistrationsForStudent(
    String studentId,
  );
}
