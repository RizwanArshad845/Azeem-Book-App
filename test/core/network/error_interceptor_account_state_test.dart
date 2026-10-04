import 'package:azeem_book_app/core/network/interceptors/auth_interceptor.dart';
import 'package:azeem_book_app/core/network/interceptors/error_interceptor.dart';
import 'package:azeem_book_app/core/network/session/session_expiry_notifier.dart';
import 'package:azeem_book_app/domain/common/failure.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

DioException _error(
  int status,
  Map<String, dynamic> error, {
  String? token,
}) {
  final options = RequestOptions(
    path: '/x',
    headers: {if (token != null) 'Authorization': 'Bearer $token'},
  );
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response(
      requestOptions: options,
      statusCode: status,
      data: {'error': error},
    ),
  );
}

Future<Failure> _run(DioException err) async {
  final handler = ErrorInterceptorHandler();
  ErrorInterceptor().onError(err, handler);
  try {
    // ignore: invalid_use_of_protected_member
    await handler.future;
  } catch (e) {
    // `handler.next` completes with the (possibly wrapped) DioException.
    final de = e as dynamic;
    return de.data.error as Failure;
  }
  throw StateError('handler did not forward the error');
}

void main() {
  late int unauthorizedCalls;
  late List<bool> deletedCalls;

  setUp(() {
    unauthorizedCalls = 0;
    deletedCalls = [];
    AuthInterceptor.currentToken = null;
    SessionExpiryNotifier.onUnauthorized = () => unauthorizedCalls++;
    SessionExpiryNotifier.onAccountDeleted =
        ({required bool clearSession}) => deletedCalls.add(clearSession);
  });

  tearDown(() {
    AuthInterceptor.currentToken = null;
    SessionExpiryNotifier.onUnauthorized = null;
    SessionExpiryNotifier.onAccountDeleted = null;
  });

  test('403 account_deleted (login) -> dialog, no session clear', () async {
    final failure = await _run(
      _error(403, {
        'code': 'account_deleted',
        'message': 'x',
        'contactEmail': null,
      }),
    );
    expect(failure, isA<AccountDeletedFailure>());
    expect(deletedCalls, [false]);
    expect(unauthorizedCalls, 0);
  });

  test('401 account_deleted on current session -> clears session', () async {
    AuthInterceptor.currentToken = 'tok';
    final failure = await _run(
      _error(401, {'code': 'account_deleted', 'message': 'x'}, token: 'tok'),
    );
    expect(failure, isA<AccountDeletedFailure>());
    expect(deletedCalls, [true]);
    // Must not ALSO run the generic "session expired" handler.
    expect(unauthorizedCalls, 0);
  });

  test('plain 401 still takes the generic session-expiry path', () async {
    AuthInterceptor.currentToken = 'tok';
    await _run(
      _error(401, {'code': 'unauthorized', 'message': 'x'}, token: 'tok'),
    );
    expect(unauthorizedCalls, 1);
    expect(deletedCalls, isEmpty);
  });

  test('409 phone_registered_other_role carries existingRole', () async {
    final failure = await _run(
      _error(409, {
        'code': 'phone_registered_other_role',
        'message': 'x',
        'existingRole': 'teacher',
      }),
    );
    expect(failure, isA<PhoneRegisteredOtherRoleFailure>());
    expect((failure as PhoneRegisteredOtherRoleFailure).existingRole, 'teacher');
  });

  test('409 phone_already_registered', () async {
    final failure = await _run(
      _error(409, {'code': 'phone_already_registered', 'message': 'x'}),
    );
    expect(failure, isA<PhoneAlreadyRegisteredFailure>());
  });

  test('403 teacher_pending_approval fires the pending callback', () async {
    var pendingCalls = 0;
    SessionExpiryNotifier.onTeacherPendingApproval = () => pendingCalls++;
    addTearDown(() => SessionExpiryNotifier.onTeacherPendingApproval = null);

    final failure = await _run(
      _error(403, {'code': 'teacher_pending_approval', 'message': 'wait'}),
    );
    expect(pendingCalls, 1);
    expect(unauthorizedCalls, 0);
    expect(failure, isA<UnauthorizedFailure>());
  });

  test('enrollment error codes map to their own failures', () async {
    expect(
      await _run(_error(400, {'code': 'teacher_not_selectable', 'message': 'x'})),
      isA<TeacherNotSelectableFailure>(),
    );
    expect(
      await _run(
        _error(400, {'code': 'teacher_locked_after_purchase', 'message': 'x'}),
      ),
      isA<TeacherLockedAfterPurchaseFailure>(),
    );
    expect(
      await _run(_error(409, {'code': 'already_enrolled', 'message': 'x'})),
      isA<AlreadyEnrolledFailure>(),
    );
    // Plain validation errors keep surfacing the server's message.
    final validation = await _run(
      _error(400, {'code': 'validation_error', 'message': 'Wrong board class'}),
    );
    expect(validation, isA<ValidationFailure>());
    expect(validation.message, 'Wrong board class');
  });

  test('403 without account_deleted code stays UnauthorizedFailure', () async {
    final failure = await _run(
      _error(403, {'code': 'forbidden', 'message': 'locked'}),
    );
    expect(failure, isA<UnauthorizedFailure>());
    expect(deletedCalls, isEmpty);
  });
}
