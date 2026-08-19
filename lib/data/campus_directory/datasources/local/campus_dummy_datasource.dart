import '../../models/campus_dto.dart';

/// Same method signature as [CampusRemoteDataSource] so the repository can
/// swap between the two based purely on `AppConfig.isMockMode` (§6.2).
abstract class CampusDummyDataSource {
  Future<List<CampusDto>> getCampuses();
}

/// In-memory fixture data across a handful of cities. Campus names already
/// encode the institution per §9.1, so no separate "college" field exists.
class CampusDummyDataSourceImpl implements CampusDummyDataSource {
  static const List<CampusDto> _campuses = [
    CampusDto(
      id: 'campus-001',
      name: 'Punjab College Bahawalpur Campus',
      city: 'Bahawalpur',
    ),
    CampusDto(
      id: 'campus-002',
      name: 'Superior College Bahawalpur Campus',
      city: 'Bahawalpur',
    ),
    CampusDto(
      id: 'campus-003',
      name: 'Al-Hamd College Bahawalpur Campus',
      city: 'Bahawalpur',
    ),
    CampusDto(
      id: 'campus-004',
      name: 'Punjab College Lahore Campus',
      city: 'Lahore',
    ),
    CampusDto(
      id: 'campus-005',
      name: 'Superior College Lahore Campus',
      city: 'Lahore',
    ),
    CampusDto(
      id: 'campus-006',
      name: 'Aspire College Lahore Campus',
      city: 'Lahore',
    ),
    CampusDto(
      id: 'campus-007',
      name: 'Punjab College Multan Campus',
      city: 'Multan',
    ),
    CampusDto(
      id: 'campus-008',
      name: 'Superior College Multan Campus',
      city: 'Multan',
    ),
  ];

  @override
  Future<List<CampusDto>> getCampuses() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return List.unmodifiable(_campuses);
  }
}
