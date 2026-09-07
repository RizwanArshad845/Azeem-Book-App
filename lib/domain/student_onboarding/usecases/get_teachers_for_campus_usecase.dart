import '../../common/result.dart';
import '../entities/teacher_option.dart';
import '../repositories/teacher_directory_repository.dart';

/// Fetches the (throwaway, see [TeacherOption]) teacher options available at
/// a given campus, for the per-subject teacher picker.
class GetTeachersForCampusUseCase {
  const GetTeachersForCampusUseCase(this._repository);

  final TeacherDirectoryRepository _repository;

  Future<Result<List<TeacherOption>>> call(
    String campusId, {
    String? subjectId,
  }) =>
      _repository.getTeachersForCampus(campusId, subjectId: subjectId);
}
