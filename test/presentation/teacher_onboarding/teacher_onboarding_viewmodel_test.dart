import 'package:azeem_book_app/core/di/injection.dart';
import 'package:azeem_book_app/domain/auth/entities/auth_session.dart';
import 'package:azeem_book_app/domain/auth/entities/user_role.dart';
import 'package:azeem_book_app/domain/common/failure.dart';
import 'package:azeem_book_app/domain/common/result.dart';
import 'package:azeem_book_app/domain/teacher_onboarding/entities/teacher.dart';
import 'package:azeem_book_app/domain/teacher_onboarding/usecases/get_teacher_by_phone_usecase.dart';
import 'package:azeem_book_app/presentation/auth/viewmodel/auth_viewmodel.dart';
import 'package:azeem_book_app/presentation/teacher_onboarding/viewmodel/teacher_onboarding_viewmodel.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetTeacherByPhoneUseCase extends Mock
    implements GetTeacherByPhoneUseCase {}

void main() {
  final session = AuthSession(
    userId: 'teacher-1',
    role: UserRole.teacher,
    phoneNumber: '03001234567',
    token: 'token',
    status: 'DASHBOARD',
  );

  final teacher = Teacher(
    id: 'teacher-1',
    name: 'Bilal',
    phoneNumber: '03001234567',
    role: UserRole.teacher,
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
    campusId: 'campus-1',
    subjectIds: const ['subject-1'],
    onboardingSource: TeacherOnboardingSource.salesmanSeeded,
    approvalStatus: TeacherApprovalStatus.approved,
  );

  late MockGetTeacherByPhoneUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetTeacherByPhoneUseCase();
    sl.registerFactory<GetTeacherByPhoneUseCase>(() => mockUseCase);
  });

  tearDown(sl.reset);

  test(
    'build() retries once on a transient failure and resolves to the '
    'teacher once the retry succeeds — mirrors the identical fix on '
    'StudentOnboardingViewModel',
    () {
      fakeAsync((async) {
        var callCount = 0;
        when(() => mockUseCase(any())).thenAnswer((_) async {
          callCount++;
          if (callCount == 1) {
            return const ResultFailure<Teacher?>(NetworkFailure());
          }
          return Success<Teacher?>(teacher);
        });

        final container = ProviderContainer(
          overrides: [currentUserProvider.overrideWithValue(session)],
        );
        addTearDown(container.dispose);

        Teacher? resolved;
        container
            .read(teacherOnboardingViewModelProvider.future)
            .then((value) => resolved = value);

        async.elapse(const Duration(seconds: 1));

        expect(resolved, teacher);
        expect(callCount, 2);
      });
    },
  );

  test('build() surfaces the failure if the retry also fails', () {
    fakeAsync((async) {
      var callCount = 0;
      when(() => mockUseCase(any())).thenAnswer((_) async {
        callCount++;
        return const ResultFailure<Teacher?>(NetworkFailure());
      });

      final container = ProviderContainer(
        overrides: [currentUserProvider.overrideWithValue(session)],
      );
      addTearDown(container.dispose);

      AsyncValue<Teacher?>? lastState;
      container.listen(teacherOnboardingViewModelProvider, (previous, next) {
        lastState = next;
      }, fireImmediately: true);

      async.elapse(const Duration(seconds: 1));

      expect(lastState?.hasError, isTrue);
      expect(lastState?.error, isA<NetworkFailure>());
      // See the matching comment on the student-side test: exactly 2 calls
      // (one retry) is independently verified there via a plain call
      // counter against `container.read(provider.future)`; `container
      // .listen(..., fireImmediately: true)` adds one extra internal read
      // here, so this only checks "did retry" (>1).
      expect(callCount, greaterThan(1));
    });
  });
}
