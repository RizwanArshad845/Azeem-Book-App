import '../../common/result.dart';
import '../entities/campus.dart';

/// Zero Flutter/Riverpod/package dependencies per §2 Clean Architecture rules.
abstract class CampusRepository {
  Future<Result<List<Campus>>> getCampuses({bool forceRefresh = false});
  void clearCache();
}
