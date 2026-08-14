import '../../../domain/common/result.dart';
import '../../../domain/onboarding/repositories/college_repository.dart';

class CollegeRepositoryImpl implements CollegeRepository {
  static const List<String> _colleges = [
    'Government College University, Lahore',
    'Punjab College, Lahore',
    'Kinnaird College for Women, Lahore',
    'Forman Christian College, Lahore',
    'Lahore Grammar School, Lahore',
    'Aitchison College, Lahore',
    'Beaconhouse School System, Lahore',
    'The City School, Lahore',
    'LACAS, Lahore',
    'Superior College, Lahore',
    'Punjab Group of Colleges, Multan',
    'Government College University, Faisalabad',
    'Divisional Public School, Gujranwala',
    'Sargodha College, Sargodha',
    'Islamia College, Rawalpindi',
  ];

  @override
  Future<Result<List<String>>> getColleges() async {
    return const Success(_colleges);
  }
}
