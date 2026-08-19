import '../../common/result.dart';
import '../entities/teacher_option.dart';

/// THROWAWAY abstraction — see doc comment on [TeacherOption]. Scoped to
/// exactly the one read the subject/teacher picker needs.
abstract class TeacherDirectoryRepository {
  Future<Result<List<TeacherOption>>> getTeachersForCampus(String campusId);
}
