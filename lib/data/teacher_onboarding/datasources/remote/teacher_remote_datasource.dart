import 'package:dio/dio.dart';

import '../../models/teacher_dto.dart';

/// Same method signatures as [TeacherDummyDataSource] so the repository can
/// swap between the two based purely on `AppConfig.isMockMode` (§6.2). Not
/// exercised while `AppConfig.isMockMode` is true, but kept compiling
/// against real Dio/`ApiEndpoints`-style signatures so the flag flip is
/// zero-code.
abstract class TeacherRemoteDataSource {
  Future<TeacherDto?> getTeacherByPhone(String phoneNumber);

  Future<TeacherDto> signUp(TeacherDto teacher);

  /// Persists a name/phone edit from `teacher-profile`. Campus/subjects/
  /// classes/approval-status/earnings fields are round-tripped unchanged.
  Future<TeacherDto> updateTeacher(TeacherDto teacher);

  /// Soft-deletes the teacher's account server-side.
  Future<void> deleteAccount(String teacherId);
}

class TeacherRemoteDataSourceImpl implements TeacherRemoteDataSource {
  TeacherRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  // NOTE: `core/network/api_endpoints.dart` (a shared hotspot file owned by
  // the coordinating thread) only declares teacherId-keyed paths today
  // (`teacherById`, `teacherOverview`, `teacherStudents`,
  // `teacherEarnings`) — there is no "lookup by phone number" or "signup"
  // path yet. Both are constructed inline below rather than editing that
  // file directly; they should be promoted to `ApiEndpoints` constants
  // (e.g. `ApiEndpoints.teacherByPhone`, `ApiEndpoints.teacherSignUp`) in a
  // follow-up once that file is free to edit again.
  static const String _teachersPath = '/teachers';
  static const String _teacherSignUpPath = '/teachers/signup';

  @override
  Future<TeacherDto?> getTeacherByPhone(String phoneNumber) async {
    final response = await _dio.get<List<dynamic>>(
      _teachersPath,
      queryParameters: {'phoneNumber': phoneNumber},
    );
    final data = response.data ?? const <dynamic>[];
    if (data.isEmpty) return null;
    return TeacherDto.fromJson(data.first as Map<String, dynamic>);
  }

  @override
  Future<TeacherDto> signUp(TeacherDto teacher) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _teacherSignUpPath,
      data: teacher.toJson(),
    );
    return TeacherDto.fromJson(response.data ?? const {});
  }

  /// Single PUT against `$_teachersPath/{id}` with the full DTO — same
  /// "single write, no join-table dance" shape as
  /// `StudentRemoteDataSourceImpl.updateStudent`.
  @override
  Future<TeacherDto> updateTeacher(TeacherDto teacher) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '$_teachersPath/${teacher.id}',
      data: teacher.toJson(),
    );
    return TeacherDto.fromJson(response.data ?? teacher.toJson());
  }

  /// Soft-delete: the server is expected to set `isDeleted = true` rather
  /// than removing the row (§9.2 `isDeleted` modeling).
  @override
  Future<void> deleteAccount(String teacherId) async {
    await _dio.delete<void>('$_teachersPath/$teacherId');
  }
}
