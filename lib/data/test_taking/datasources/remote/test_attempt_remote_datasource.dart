import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../domain/common/failure.dart';
import '../../../../domain/common/result.dart';
import '../../models/test_attempt_dto.dart';
import '../../models/test_attempt_session_dto.dart';

abstract class TestAttemptRemoteDataSource {
  Future<Result<TestAttemptSessionDto>> startAttempt(String testId);

  Future<Result<void>> autoSaveAnswer(
    String attemptId,
    String questionId, {
    int? selectedOptionIndex,
    String? answerText,
  });

  Future<Result<void>> submitAttempt(
    String testId,
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

  @override
  Future<Result<void>> autoSaveAnswer(
    String attemptId,
    String questionId, {
    int? selectedOptionIndex,
    String? answerText,
  }) {
    return _guard(() async {
      await _dio.patch<void>(
        ApiEndpoints.attemptAnswers(attemptId),
        data: {
          'questionId': questionId,
          if (selectedOptionIndex != null)
            'selectedOptionIndex': selectedOptionIndex,
          if (answerText != null) 'answerText': answerText,
        },
      );
    });
  }

  @override
  Future<Result<void>> submitAttempt(
    String testId,
    String attemptId,
    Map<String, Object> rawAnswers,
  ) {
    return _guard(() async {
      await _dio.post<void>(
        ApiEndpoints.testSubmit(testId),
        data: {
          'attemptId': attemptId,
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
