import '../../../domain/common/failure.dart';
import '../../../domain/common/result.dart';
import '../../../domain/student_onboarding/entities/student.dart';
import '../../../domain/student_onboarding/repositories/student_repository.dart';
import '../datasources/remote/student_remote_datasource.dart';
import '../models/student_dto.dart';

class StudentRepositoryImpl implements StudentRepository {
  StudentRepositoryImpl({required this.remote});

  final StudentRemoteDataSource remote;

  @override
  Future<Result<Student>> completeOnboarding(Student student) async {
    try {
      final dto = StudentDto.fromDomain(student);
      final saved = await remote.completeOnboarding(dto);
      return Success(saved.toDomain());
    } on Failure catch (f) {
      return ResultFailure(f);
    } catch (e) {
      return ResultFailure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Student>>> getStudentsForTeacher(String teacherId) async {
    try {
      final dtos = await remote.getStudentsForTeacher(teacherId);
      return Success(dtos.map((d) => d.toDomain()).toList());
    } on Failure catch (f) {
      return ResultFailure(f);
    } catch (e) {
      return ResultFailure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<Student>> updateStudent(Student student) async {
    try {
      final dto = StudentDto.fromDomain(student);
      final saved = await remote.updateStudent(dto);
      return Success(saved.toDomain());
    } on Failure catch (f) {
      return ResultFailure(f);
    } catch (e) {
      return ResultFailure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteAccount(String studentId) async {
    try {
      await remote.deleteAccount(studentId);
      return const Success(null);
    } on Failure catch (f) {
      return ResultFailure(f);
    } catch (e) {
      return ResultFailure(UnknownFailure(e.toString()));
    }
  }
}
