import '../../catalog/entities/subject.dart';
import '../../catalog/entities/test.dart';
import '../../common/result.dart';
import '../../student_onboarding/entities/subject_enrollment.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

/// Adds a whole [Subject] bundle (all of [tests]) to the student's cart,
/// applying the teacher-discount rule via [subjectEnrollments]
/// (project_spec.md §9.2, teacher-discount note).
class AddSubjectBundleUseCase {
  const AddSubjectBundleUseCase(this._repository);

  final CartRepository _repository;

  Future<Result<Cart>> call(
    String studentId,
    Subject subject,
    List<Test> tests, {
    required List<SubjectEnrollment> subjectEnrollments,
  }) => _repository.addSubjectBundle(
    studentId,
    subject,
    tests,
    subjectEnrollments: subjectEnrollments,
  );
}
