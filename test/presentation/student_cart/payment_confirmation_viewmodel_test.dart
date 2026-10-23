import 'package:azeem_book_app/core/di/injection.dart';
import 'package:azeem_book_app/data/student_cart/datasources/remote/cart_remote_datasource.dart';
import 'package:azeem_book_app/data/student_cart/models/add_cart_item_request_dto.dart';
import 'package:azeem_book_app/data/student_cart/models/cart_dto.dart';
import 'package:azeem_book_app/data/student_cart/models/payment_dto.dart';
import 'package:azeem_book_app/data/student_cart/repositories/cart_repository_impl.dart';
import 'package:azeem_book_app/domain/auth/entities/auth_session.dart';
import 'package:azeem_book_app/domain/auth/entities/user_role.dart';
import 'package:azeem_book_app/domain/common/result.dart';
import 'package:azeem_book_app/domain/student_cart/repositories/cart_repository.dart';
import 'package:azeem_book_app/domain/student_cart/usecases/get_cart_usecase.dart';
import 'package:azeem_book_app/domain/student_cart/usecases/get_pending_subject_ids_usecase.dart';
import 'package:azeem_book_app/domain/student_cart/usecases/get_purchased_subject_ids_usecase.dart';
import 'package:azeem_book_app/domain/student_onboarding/entities/student.dart';
import 'package:azeem_book_app/domain/student_onboarding/usecases/get_student_by_id_usecase.dart';
import 'package:azeem_book_app/presentation/auth/viewmodel/auth_viewmodel.dart';
import 'package:azeem_book_app/presentation/student_cart/viewmodel/student_cart_viewmodel.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetStudentByIdUseCase extends Mock implements GetStudentByIdUseCase {}

/// Serves `/payments/status` responses in order (the last one repeats), so a
/// test can script how a payment moves while the app polls.
class FakeCartRemote implements CartRemoteDataSource {
  FakeCartRemote(this.statuses);

  final List<PaymentStatusSnapshot> statuses;
  int statusCalls = 0;

  @override
  Future<Result<PaymentStatusSnapshot>> getPaymentStatus(String studentId) async {
    final i = statusCalls < statuses.length ? statusCalls : statuses.length - 1;
    statusCalls++;
    return Success(statuses[i]);
  }

  @override
  Future<Result<CartDto>> getCart(String studentId) async =>
      Success(CartDto(id: studentId, studentId: studentId, items: const []));

  @override
  Future<Result<CartDto>> addSubjectBundle(
    String studentId,
    AddCartItemRequestDto request,
  ) => throw UnimplementedError();

  @override
  Future<Result<CartDto>> removeItem(String studentId, String subjectId) =>
      throw UnimplementedError();

  @override
  Future<Result<PaymentDto>> checkout(String studentId) =>
      throw UnimplementedError();
}

PaymentStatusSnapshot status({
  Set<String> purchased = const {},
  Set<String> pending = const {},
}) => (purchased: purchased, pending: pending);

void main() {
  final session = AuthSession(
    userId: 'student-1',
    role: UserRole.student,
    phoneNumber: '03001234567',
    token: 'token',
    status: 'DASHBOARD',
  );

  late FakeCartRemote remote;

  ProviderContainer containerFor(List<PaymentStatusSnapshot> statuses) {
    remote = FakeCartRemote(statuses);
    final repository = CartRepositoryImpl(remote: remote);
    sl
      ..registerSingleton<CartRepository>(repository)
      ..registerSingleton(GetCartUseCase(repository))
      ..registerSingleton(GetPurchasedSubjectIdsUseCase(repository))
      ..registerSingleton(GetPendingSubjectIdsUseCase(repository));
    final getStudent = MockGetStudentByIdUseCase();
    when(() => getStudent(any()))
        .thenAnswer((_) async => const Success<Student?>(null));
    sl.registerSingleton<GetStudentByIdUseCase>(getStudent);

    final container = ProviderContainer(
      overrides: [currentUserProvider.overrideWithValue(session)],
    );
    addTearDown(container.dispose);
    return container;
  }

  tearDown(sl.reset);

  test('a payment that settles while polling is confirmed and unlocked', () {
    fakeAsync((async) {
      final container = containerFor([
        status(pending: {'math'}),
        status(pending: {'math'}),
        status(purchased: {'math'}),
      ]);
      final vm = container.read(paymentConfirmationProvider.notifier);

      vm.expect({'math'});
      vm.confirm();
      async.elapse(const Duration(seconds: 10));

      expect(container.read(paymentConfirmationProvider),
          PaymentConfirmation.confirmed);
      expect(container.read(purchasedSubjectIdsProvider).value, {'math'});
      expect(container.read(pendingSubjectIdsProvider).value, isEmpty);
    });
  });

  test('a payment that drops out of pending without being bought is failed',
      () {
    fakeAsync((async) {
      final container = containerFor([
        status(pending: {'math'}),
        status(),
      ]);
      final vm = container.read(paymentConfirmationProvider.notifier);

      vm.expect({'math'});
      vm.confirm();
      async.elapse(const Duration(seconds: 10));

      expect(container.read(paymentConfirmationProvider),
          PaymentConfirmation.failed);
      expect(container.read(purchasedSubjectIdsProvider).value, isEmpty);
    });
  });

  test(
    'after an app restart (nothing expected locally) a payment still pending '
    'server-side is resumed and confirmed',
    () {
      fakeAsync((async) {
        final container = containerFor([
          status(pending: {'math'}),
          status(pending: {'math'}),
          status(purchased: {'math'}),
        ]);

        container.read(paymentConfirmationProvider.notifier).resumeIfPending();
        async.elapse(const Duration(seconds: 10));

        expect(container.read(paymentConfirmationProvider),
            PaymentConfirmation.confirmed);
        expect(container.read(purchasedSubjectIdsProvider).value, {'math'});
      });
    },
  );

  test('resume with nothing pending makes one status call and stays idle', () {
    fakeAsync((async) {
      final container = containerFor([status(purchased: {'physics'})]);

      container.read(paymentConfirmationProvider.notifier).resumeIfPending();
      async.elapse(const Duration(seconds: 10));

      expect(container.read(paymentConfirmationProvider),
          PaymentConfirmation.idle);
      expect(remote.statusCalls, 1);
    });
  });

  test('a payment still pending after ~2 minutes is reported unconfirmed', () {
    fakeAsync((async) {
      final container = containerFor([status(pending: {'math'})]);
      final vm = container.read(paymentConfirmationProvider.notifier);

      vm.expect({'math'});
      vm.confirm();
      async.elapse(const Duration(minutes: 3));

      expect(container.read(paymentConfirmationProvider),
          PaymentConfirmation.unconfirmed);
      // Still shown as processing, so it can't be bought again meanwhile.
      expect(container.read(pendingSubjectIdsProvider).value, {'math'});
    });
  });
}
