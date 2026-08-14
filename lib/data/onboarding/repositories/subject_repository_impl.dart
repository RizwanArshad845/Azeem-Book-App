import '../../../core/config/app_config.dart';
import '../../../domain/common/result.dart';
import '../../../domain/onboarding/repositories/subject_repository.dart';

class SubjectRepositoryImpl implements SubjectRepository {
  @override
  Future<Result<List<String>>> getSubjects() async {
    return const Success(AppConfig.subjectPool);
  }
}
