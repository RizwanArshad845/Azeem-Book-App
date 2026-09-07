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

  /// Reads the current student's profile by id, or `null` if no `Student`
  /// row exists yet (backend 404s before onboarding completes, mirroring
  /// the `completeOnboarding` doc comment above).
  Future<StudentDto?> getStudentById(String studentId);

  /// Updates the student's subject enrollments and assigned teachers.
  Future<List<SubjectEnrollmentDto>> updateSubjectEnrollments(
    String studentId,
    List<SubjectEnrollmentDto> enrollments,
  );

  /// Reads the current student's subject enrollments from backend.
  Future<List<SubjectEnrollmentDto>> getSubjectEnrollments(String studentId);
}

class StudentRemoteDataSourceImpl implements StudentRemoteDataSource {
  StudentRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  /// Creates the profile (name/phone/campus/board-class) via
  /// `POST /students/signup` — the real backend 404s a `PUT` against a
  /// student id with no profile row behind it yet, so onboarding must
  /// create first — then writes the subject-enrollment join rows via
  /// `studentSubjectEnrollments`.
  @override
  Future<StudentDto> completeOnboarding(StudentDto student) async {
    final profileJson = Map<String, dynamic>.from(student.toJson())
      ..remove('subjectEnrollments');

    final profileResponse = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.studentSignUp,
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

  @override
  Future<List<SubjectEnrollmentDto>> updateSubjectEnrollments(
    String studentId,
    List<SubjectEnrollmentDto> enrollments,
  ) async {
    final response = await _dio.put<dynamic>(
      ApiEndpoints.studentSubjectEnrollments(studentId),
      data: enrollments
          .map((e) => {
                'subjectId': e.subjectId,
                'teacherId': e.teacherId,
              })
          .toList(),
    );
    final dynamic data = response.data;
    final List<dynamic> items;
    if (data is List) {
      items = data;
    } else if (data is Map<String, dynamic> && data['results'] is List) {
      items = data['results'] as List<dynamic>;
    } else {
      items = const [];
    }
    return items
        .map((e) => SubjectEnrollmentDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<SubjectEnrollmentDto>> getSubjectEnrollments(
    String studentId,
  ) async {
    final response = await _dio.get<dynamic>(
      ApiEndpoints.studentSubjectEnrollments(studentId),
    );
    final dynamic data = response.data;
    final List<dynamic> items;
    if (data is List) {
      items = data;
    } else if (data is Map<String, dynamic> && data['results'] is List) {
      items = data['results'] as List<dynamic>;
    } else {
      items = const [];
    }
    return items
        .map((e) => SubjectEnrollmentDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Backs the `teacher-students` Students tab — the `ApiEndpoints`
  /// contract this feature was told to build against.
  ///
  /// Paginated DRF envelope (`{count, next, previous, results}`), not a
  /// bare array (`FRONTEND_INTEGRATION.md` §5/§6.2) — only the first page
  /// (default size 20) is fetched here.
  @override
  Future<List<StudentDto>> getStudentsForTeacher(String teacherId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.teacherStudents(teacherId),
    );
    final results = response.data?['results'] as List<dynamic>? ?? [];
    return results
        .map((e) => StudentDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Single PUT against `studentById` with the full DTO — unlike
  /// [completeOnboarding], profile edits never touch `subjectEnrollments`,
  /// so there's no need for the two-request dance that method uses.
  ///
  /// A profile-only PUT response from the backend can omit fields it didn't
  /// touch (`subjectEnrollments`, `boardClassId`, `cartId`), which
  /// `json_serializable` decodes as `null` — indistinguishable from
  /// "genuinely none." Falling back to the request DTO's values for any of
  /// these that come back `null` prevents a partial response from wiping
  /// them out of the shared student state app-wide.
  @override
  Future<StudentDto> updateStudent(StudentDto student) async {
    final response = await _dio.put<Map<String, dynamic>>(
      ApiEndpoints.studentById(student.id),
      data: student.toJson(),
    );
    final updated = StudentDto.fromJson(response.data ?? student.toJson());
    return updated.copyWith(
      subjectEnrollments:
          updated.subjectEnrollments ?? student.subjectEnrollments,
      boardClassId: updated.boardClassId ?? student.boardClassId,
      cartId: updated.cartId ?? student.cartId,
    );
  }

  /// Soft-delete: the server is expected to set `isDeleted = true` rather
  /// than removing the row (§9.2 `isDeleted` modeling).
  @override
  Future<void> deleteAccount(String studentId) async {
    await _dio.delete<void>(ApiEndpoints.studentById(studentId));
  }

  @override
  Future<StudentDto?> getStudentById(String studentId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.studentById(studentId),
      );
      final data = response.data;
      if (data == null) return null;
      return StudentDto.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }
}
