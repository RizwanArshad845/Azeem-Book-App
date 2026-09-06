import 'package:azeem_book_app/core/network/api_endpoints.dart';
import 'package:azeem_book_app/data/student_onboarding/datasources/remote/student_remote_datasource.dart';
import 'package:azeem_book_app/data/student_onboarding/models/student_dto.dart';
import 'package:azeem_book_app/data/student_onboarding/models/subject_enrollment_dto.dart';
import 'package:azeem_book_app/domain/auth/entities/user_role.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late StudentRemoteDataSourceImpl dataSource;
  late StudentDto requestDto;

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  setUp(() {
    dio = MockDio();
    dataSource = StudentRemoteDataSourceImpl(dio);
    requestDto = StudentDto(
      id: 'student-1',
      name: 'Ayesha',
      phoneNumber: '03001234567',
      role: UserRole.student,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
      campusId: 'campus-1',
      boardClassId: 'board-class-1',
      cartId: 'cart-1',
      subjectEnrollments: const [SubjectEnrollmentDto(subjectId: 'subject-1')],
    );
  });

  Response<Map<String, dynamic>> responseWith(Map<String, dynamic> json) {
    return Response<Map<String, dynamic>>(
      requestOptions: RequestOptions(
        path: ApiEndpoints.studentById(requestDto.id),
      ),
      statusCode: 200,
      data: json,
    );
  }

  test(
    'falls back to the request DTO values when the PUT response omits '
    'boardClassId, cartId, and subjectEnrollments (partial profile-only '
    'response)',
    () async {
      final partialJson = Map<String, dynamic>.from(requestDto.toJson())
        ..remove('boardClassId')
        ..remove('cartId')
        ..remove('subjectEnrollments');

      when(
        () => dio.put<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
        ),
      ).thenAnswer((_) async => responseWith(partialJson));

      final result = await dataSource.updateStudent(requestDto);

      expect(result.boardClassId, requestDto.boardClassId);
      expect(result.cartId, requestDto.cartId);
      expect(result.subjectEnrollments, requestDto.subjectEnrollments);
    },
  );

  test(
    'uses the response values when the PUT response does include new '
    'boardClassId, cartId, and subjectEnrollments (real updates still win)',
    () async {
      final updatedJson = Map<String, dynamic>.from(requestDto.toJson())
        ..['boardClassId'] = 'board-class-2'
        ..['cartId'] = 'cart-2'
        ..['subjectEnrollments'] = const [
          SubjectEnrollmentDto(subjectId: 'subject-2'),
        ].map((e) => e.toJson()).toList();

      when(
        () => dio.put<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
        ),
      ).thenAnswer((_) async => responseWith(updatedJson));

      final result = await dataSource.updateStudent(requestDto);

      expect(result.boardClassId, 'board-class-2');
      expect(result.cartId, 'cart-2');
      expect(
        result.subjectEnrollments?.map((e) => e.subjectId),
        ['subject-2'],
      );
    },
  );
}
