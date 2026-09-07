import '../../../domain/common/failure.dart';
import '../../../domain/common/result.dart';
import '../../../domain/student_onboarding/entities/teacher_option.dart';
import '../../../domain/student_onboarding/repositories/teacher_directory_repository.dart';
import '../datasources/remote/teacher_directory_remote_datasource.dart';

/// Repository providing approved teachers at a given campus for student onboarding
/// and post-onboarding teacher selection. Backed by [TeacherDirectoryRemoteDataSource].
class TeacherDirectoryRepositoryImpl implements TeacherDirectoryRepository {
  TeacherDirectoryRepositoryImpl({required this.remote});

  final TeacherDirectoryRemoteDataSource remote;

  @override
  Future<Result<List<TeacherOption>>> getTeachersForCampus(
    String campusId, {
    String? subjectId,
  }) async {
    try {
      final dtos = await remote.getTeachersForCampus(
        campusId,
        subjectId: subjectId,
      );
      return Success(dtos.map((d) => d.toDomain()).toList());
    } catch (e) {
      return ResultFailure(UnknownFailure(e.toString()));
    }
  }
}
