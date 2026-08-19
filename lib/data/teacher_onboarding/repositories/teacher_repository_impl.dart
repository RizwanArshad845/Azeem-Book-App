import '../../../domain/common/failure.dart';
import '../../../domain/common/result.dart';
import '../../../domain/teacher_onboarding/entities/teacher.dart';
import '../../../domain/teacher_onboarding/repositories/teacher_repository.dart';
import '../datasources/local/teacher_dummy_datasource.dart';
import '../datasources/remote/teacher_remote_datasource.dart';
import '../models/teacher_dto.dart';

/// Switches between the dummy and remote datasource per
/// `AppConfig.isMockMode` (§6.1/§6.2) — never called with a live endpoint
/// directly from a viewmodel.
class TeacherRepositoryImpl implements TeacherRepository {
  TeacherRepositoryImpl({
    required this.remote,
    required this.dummy,
    required this.isMockMode,
  });

  final TeacherRemoteDataSource remote;
  final TeacherDummyDataSource dummy;
  final bool isMockMode;

  @override
  Future<Result<Teacher?>> getTeacherByPhone(String phoneNumber) async {
    try {
      final dto = isMockMode
          ? await dummy.getTeacherByPhone(phoneNumber)
          : await remote.getTeacherByPhone(phoneNumber);
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
      final created = isMockMode
          ? await dummy.signUp(dto)
          : await remote.signUp(dto);
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
      final saved = isMockMode
          ? await dummy.updateTeacher(dto)
          : await remote.updateTeacher(dto);
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
      if (isMockMode) {
        await dummy.deleteAccount(teacherId);
      } else {
        await remote.deleteAccount(teacherId);
      }
      return const Success(null);
    } on Failure catch (f) {
      return ResultFailure(f);
    } catch (e) {
      return ResultFailure(UnknownFailure(e.toString()));
    }
  }
}
