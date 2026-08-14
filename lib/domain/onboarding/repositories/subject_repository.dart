import '../../common/result.dart';

abstract class SubjectRepository {
  Future<Result<List<String>>> getSubjects();
}
