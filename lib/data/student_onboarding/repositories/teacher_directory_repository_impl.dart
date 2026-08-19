import '../../../domain/common/failure.dart';
import '../../../domain/common/result.dart';
import '../../../domain/student_onboarding/entities/teacher_option.dart';
import '../../../domain/student_onboarding/repositories/teacher_directory_repository.dart';
import '../datasources/local/teacher_directory_dummy_datasource.dart';

/// THROWAWAY repository — see the doc comment on [TeacherOption]. Only
/// wires a dummy datasource (no real endpoint exists for this stand-in
/// yet), but keeps the same interface/error-handling shape as every other
/// repository so it drops in cleanly once a real datasource replaces it.
class TeacherDirectoryRepositoryImpl implements TeacherDirectoryRepository {
  TeacherDirectoryRepositoryImpl({required this.dummy});

  final TeacherDirectoryDummyDataSource dummy;

  @override
  Future<Result<List<TeacherOption>>> getTeachersForCampus(
    String campusId,
  ) async {
    try {
      final dtos = await dummy.getTeachersForCampus(campusId);
      return Success(dtos.map((d) => d.toDomain()).toList());
    } catch (e) {
      return ResultFailure(UnknownFailure(e.toString()));
    }
  }
}
