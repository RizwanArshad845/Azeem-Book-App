import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../models/teacher_option_dto.dart';

/// Remote datasource for querying approved teachers by campus.
/// Directly replaces the throwaway local dummy datasource with live backend data.
abstract class TeacherDirectoryRemoteDataSource {
  Future<List<TeacherOptionDto>> getTeachersForCampus(
    String campusId, {
    String? subjectId,
  });
}

class TeacherDirectoryRemoteDataSourceImpl
    implements TeacherDirectoryRemoteDataSource {
  TeacherDirectoryRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<TeacherOptionDto>> getTeachersForCampus(
    String campusId, {
    String? subjectId,
  }) async {
    final queryParams = <String, dynamic>{
      'campusId': campusId,
    };
    if (subjectId != null && subjectId.isNotEmpty) {
      queryParams['subjectId'] = subjectId;
    }

    final response = await _dio.get<dynamic>(
      ApiEndpoints.teachers,
      queryParameters: queryParams,
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

    return items.map((raw) {
      final json = raw as Map<String, dynamic>;
      final rawSubjects = json['subjectIds'] as List<dynamic>? ?? const [];
      final subjectIds = rawSubjects.map((s) => s.toString()).toList();

      return TeacherOptionDto(
        id: (json['id'] ?? '').toString(),
        name: (json['name'] ?? '').toString(),
        campusId: (json['campusId'] ?? '').toString(),
        subjectIds: subjectIds,
      );
    }).toList();
  }
}
