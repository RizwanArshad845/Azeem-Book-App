import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../models/student_dto.dart';
import '../../models/subject_enrollment_dto.dart';

abstract class StudentRemoteDataSource {
  Future<StudentDto> completeOnboarding(StudentDto student);

  Future<List<StudentDto>> getStudentsForTeacher(String teacherId);

  /// Persists a name/phone edit from `student-profile`. Campus/board-class/
  /// subject-enrollment fields are round-tripped unchanged.
  Future<StudentDto> updateStudent(StudentDto student);

  /// Soft-deletes the student's account server-side.
  Future<void> deleteAccount(String studentId);
}

class StudentRemoteDataSourceImpl implements StudentRemoteDataSource {
  StudentRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  /// Writes the profile (campus + board/class) via `studentById`, then the
  /// subject-enrollment join rows via `studentSubjectEnrollments` — the two
  /// read-only `ApiEndpoints` this feature was told to build against.
  @override
  Future<StudentDto> completeOnboarding(StudentDto student) async {
    final profileJson = Map<String, dynamic>.from(student.toJson())
      ..remove('subjectEnrollments');

    final profileResponse = await _dio.put<Map<String, dynamic>>(
      ApiEndpoints.studentById(student.id),
      data: profileJson,
    );

    final enrollmentsResponse = await _dio.put<List<dynamic>>(
      ApiEndpoints.studentSubjectEnrollments(student.id),
      data: (student.subjectEnrollments ?? const <SubjectEnrollmentDto>[])
          .map((e) => e.toJson())
          .toList(),
    );

    final savedProfile = profileResponse.data ?? profileJson;
    final savedEnrollments = (enrollmentsResponse.data ?? const <dynamic>[])
        .map((e) => SubjectEnrollmentDto.fromJson(e as Map<String, dynamic>))
        .toList();

    return StudentDto.fromJson(
      savedProfile,
    ).copyWith(subjectEnrollments: savedEnrollments);
  }

  /// Backs the `teacher-students` Students tab — the `ApiEndpoints`
  /// contract this feature was told to build against.
  @override
  Future<List<StudentDto>> getStudentsForTeacher(String teacherId) async {
    final response = await _dio.get<List<dynamic>>(
      ApiEndpoints.teacherStudents(teacherId),
    );
    return (response.data ?? const <dynamic>[])
        .map((e) => StudentDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Single PUT against `studentById` with the full DTO — unlike
  /// [completeOnboarding], profile edits never touch `subjectEnrollments`,
  /// so there's no need for the two-request dance that method uses.
  @override
  Future<StudentDto> updateStudent(StudentDto student) async {
    final response = await _dio.put<Map<String, dynamic>>(
      ApiEndpoints.studentById(student.id),
      data: student.toJson(),
    );
    return StudentDto.fromJson(response.data ?? student.toJson());
  }

  /// Soft-delete: the server is expected to set `isDeleted = true` rather
  /// than removing the row (§9.2 `isDeleted` modeling).
  @override
  Future<void> deleteAccount(String studentId) async {
    await _dio.delete<void>(ApiEndpoints.studentById(studentId));
  }
}
