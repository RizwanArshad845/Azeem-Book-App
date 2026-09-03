import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../domain/common/failure.dart';
import '../../../../domain/common/result.dart';
import '../../models/test_attempt_dto.dart';
import '../../models/test_attempt_session_dto.dart';

abstract class TestAttemptRemoteDataSource {
  Future<Result<TestAttemptSessionDto>> startAttempt(String testId);

  Future<Result<void>> submitAttempt(
    String attemptId,
    Map<String, Object> rawAnswers,
  );

  Future<Result<TestAttemptDto>> getAttempt(String attemptId);

  Future<Result<List<TestAttemptDto>>> getAttemptsForStudent(
    String studentId,
  );
}

class TestAttemptRemoteDataSourceImpl implements TestAttemptRemoteDataSource {
  TestAttemptRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<Result<TestAttemptSessionDto>> startAttempt(String testId) {
    return _guard(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.testStartAttempt(testId),
      );
      return TestAttemptSessionDto.fromJson(response.data!);
    });
  }

  /// Local-first: this is the only network call the app makes for a
  /// student's answers — the complete set collected client-side, sent once
  /// on submit (`FRONTEND_INTEGRATION.md` §6.6 "Answer persistence &
  /// grading UX"). There is no per-answer `PATCH /attempts/{id}/answers`
  /// call during test-taking.
  @override
  Future<Result<void>> submitAttempt(
    String attemptId,
    Map<String, Object> rawAnswers,
  ) {
    return _guard(() async {
      await _dio.post<void>(
        ApiEndpoints.attemptSubmit(attemptId),
        data: {
          'answers': [
            for (final entry in rawAnswers.entries)
              {
                'questionId': entry.key,
                if (entry.value is int) 'selectedOptionIndex': entry.value,
                if (entry.value is String) 'answerText': entry.value,
              },
          ],
        },
      );
    });
  }

  @override
  Future<Result<TestAttemptDto>> getAttempt(String attemptId) {
    return _guard(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.attemptById(attemptId),
      );
      return TestAttemptDto.fromJson(response.data!);
    });
  }

  @override
  Future<Result<List<TestAttemptDto>>> getAttemptsForStudent(
    String studentId,
  ) {
    return _guard(() async {
      final response = await _dio.get<List<dynamic>>(
        ApiEndpoints.studentTestAttempts(studentId),
      );
      return (response.data ?? const [])
          .map((json) => TestAttemptDto.fromJson(json as Map<String, dynamic>))
          .toList();
    });
  }

  Future<Result<T>> _guard<T>(Future<T> Function() body) async {
    try {
      return Success(await body());
    } on DioException catch (e) {
      final failure = e.error;
      return ResultFailure(
        failure is Failure ? failure : UnknownFailure(e.message),
      );
    } catch (e) {
      return ResultFailure(UnknownFailure(e.toString()));
    }
  }
}
