import '../../../domain/common/failure.dart';
import '../../../domain/common/result.dart';
import '../../../domain/teacher_onboarding/entities/teacher.dart';
import '../../../domain/teacher_onboarding/repositories/teacher_repository.dart';
import '../datasources/remote/teacher_remote_datasource.dart';
import '../models/teacher_dto.dart';

class TeacherRepositoryImpl implements TeacherRepository {
  TeacherRepositoryImpl({required this.remote});

  final TeacherRemoteDataSource remote;

  @override
  Future<Result<Teacher?>> getTeacherByPhone(String phoneNumber) async {
    try {
      final dto = await remote.getTeacherByPhone(phoneNumber);
      return Success(dto?.toDomain());
    } on Failure catch (f) {
      return ResultFailure(f);
    } catch (e) {
      return ResultFailure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<Teacher>> signUp(Teacher teacher) async {
    try {
      final dto = TeacherDto.fromDomain(teacher);
      final created = await remote.signUp(dto);
      return Success(created.toDomain());
    } on Failure catch (f) {
      return ResultFailure(f);
    } catch (e) {
      return ResultFailure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<Teacher>> updateTeacher(Teacher teacher) async {
    try {
      final dto = TeacherDto.fromDomain(teacher);
      final saved = await remote.updateTeacher(dto);
      return Success(saved.toDomain());
    } on Failure catch (f) {
      return ResultFailure(f);
    } catch (e) {
      return ResultFailure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteAccount(String teacherId) async {
    try {
      await remote.deleteAccount(teacherId);
      return const Success(null);
    } on Failure catch (f) {
      return ResultFailure(f);
    } catch (e) {
      return ResultFailure(UnknownFailure(e.toString()));
    }
  }
}
