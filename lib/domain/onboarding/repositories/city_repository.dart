import '../../common/result.dart';

abstract class CityRepository {
  Future<Result<List<String>>> getCities();
}
