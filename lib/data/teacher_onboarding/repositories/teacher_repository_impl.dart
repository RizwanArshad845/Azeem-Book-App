import '../../../core/network/result_guard.dart';
import '../../../domain/common/result.dart';
import '../../../domain/teacher_onboarding/entities/teacher.dart';
import '../../../domain/teacher_onboarding/repositories/teacher_repository.dart';
import '../datasources/remote/teacher_remote_datasource.dart';
import '../models/teacher_dto.dart';

class TeacherRepositoryImpl implements TeacherRepository {
  TeacherRepositoryImpl({required this.remote});

  final TeacherRemoteDataSource remote;

  @override
  Future<Result<Teacher?>> getTeacherByPhone(String phoneNumber) {
    return guardRequest(() async {
      final dto = await remote.getTeacherByPhone(phoneNumber);
      return dto?.toDomain();
    });
  }

  @override
  Future<Result<Teacher>> signUp(Teacher teacher) {
    return guardRequest(() async {
      final dto = TeacherDto.fromDomain(teacher);
      final created = await remote.signUp(dto);
      return created.toDomain();
    });
  }

  @override
  Future<Result<Teacher>> updateTeacher(Teacher teacher) {
    return guardRequest(() async {
      final dto = TeacherDto.fromDomain(teacher);
      final saved = await remote.updateTeacher(dto);
      return saved.toDomain();
    });
  }

  @override
  Future<Result<void>> deleteAccount(String teacherId) {
    return guardRequest(() => remote.deleteAccount(teacherId));
  }
}
