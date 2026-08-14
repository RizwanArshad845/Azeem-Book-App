import '../../common/result.dart';

abstract class CollegeRepository {
  Future<Result<List<String>>> getColleges();
}
