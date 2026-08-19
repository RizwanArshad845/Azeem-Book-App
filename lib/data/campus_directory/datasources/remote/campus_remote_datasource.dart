import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../models/campus_dto.dart';

/// Same method signature as [CampusDummyDataSource] so the repository can
/// swap between the two based purely on `AppConfig.isMockMode` (§6.2).
abstract class CampusRemoteDataSource {
  Future<List<CampusDto>> getCampuses();
}

class CampusRemoteDataSourceImpl implements CampusRemoteDataSource {
  CampusRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<CampusDto>> getCampuses() async {
    final response = await _dio.get<List<dynamic>>(
      ApiEndpoints.catalogCampuses,
    );
    final data = response.data ?? const <dynamic>[];
    return data
        .map((json) => CampusDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
