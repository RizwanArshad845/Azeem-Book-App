import '../../../../domain/common/result.dart';
import '../../models/live_test_registration_dto.dart';

/// Same method signatures as [LiveTestRegistrationRemoteDataSource] so the
/// repository can swap between the two based purely on
/// `AppConfig.isMockMode` (§6.2), matching `CartDummyDataSource`'s pattern.
abstract class LiveTestRegistrationDummyDataSource {
  Future<Result<LiveTestRegistrationDto>> register(
    String studentId,
    String testId,
  );

  Future<Result<List<LiveTestRegistrationDto>>> getRegistrationsForStudent(
    String studentId,
  );
}

/// In-memory registrations, keyed by studentId. `register` is idempotent —
/// registering twice for the same `testId` returns the existing
/// registration rather than creating a duplicate (mirrors
/// `CartDummyDataSourceImpl.addItem`'s "already present -> no-op" contract).
class LiveTestRegistrationDummyDataSourceImpl
    implements LiveTestRegistrationDummyDataSource {
  static const _latency = Duration(milliseconds: 400);

  final Map<String, List<LiveTestRegistrationDto>> _byStudentId = {};

  int _counter = 0;

  @override
  Future<Result<LiveTestRegistrationDto>> register(
    String studentId,
    String testId,
  ) async {
    await Future.delayed(_latency);
    final existing = _byStudentId.putIfAbsent(
      studentId,
      () => <LiveTestRegistrationDto>[],
    );

    for (final registration in existing) {
      if (registration.testId == testId) {
        return Success(registration);
      }
    }

    _counter++;
    final registration = LiveTestRegistrationDto(
      id: 'live-test-reg-$_counter',
      studentId: studentId,
      testId: testId,
      registeredAt: DateTime.now(),
    );
    existing.add(registration);
    return Success(registration);
  }

  @override
  Future<Result<List<LiveTestRegistrationDto>>> getRegistrationsForStudent(
    String studentId,
  ) async {
    await Future.delayed(_latency);
    return Success(
      List.unmodifiable(_byStudentId[studentId] ?? const <LiveTestRegistrationDto>[]),
    );
  }
}
