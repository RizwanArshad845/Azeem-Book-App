import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../models/teacher_dto.dart';

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

  @override
  Future<TeacherDto?> getTeacherByPhone(String phoneNumber) async {
    final response = await _dio.get<Map<String, dynamic>?>(
      ApiEndpoints.teachers,
      queryParameters: {'phoneNumber': phoneNumber},
    );
    final data = response.data;
    if (data == null) return null;
    return TeacherDto.fromJson(data);
  }

  @override
  Future<TeacherDto> signUp(TeacherDto teacher) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.teacherSignUp,
      data: teacher.toJson(),
    );
    return TeacherDto.fromJson(response.data ?? const {});
  }

  /// Single PUT against `teacherById` with the full DTO — same
  /// "single write, no join-table dance" shape as
  /// `StudentRemoteDataSourceImpl.updateStudent`.
  @override
  Future<TeacherDto> updateTeacher(TeacherDto teacher) async {
    final response = await _dio.put<Map<String, dynamic>>(
      ApiEndpoints.teacherById(teacher.id),
      data: teacher.toJson(),
    );
    return TeacherDto.fromJson(response.data ?? teacher.toJson());
  }

  /// Soft-delete: the server is expected to set `isDeleted = true` rather
  /// than removing the row (§9.2 `isDeleted` modeling).
  @override
  Future<void> deleteAccount(String teacherId) async {
    await _dio.delete<void>(ApiEndpoints.teacherById(teacherId));
  }
}
