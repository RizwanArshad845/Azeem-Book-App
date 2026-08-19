import '../../catalog/entities/test.dart';
import '../../common/result.dart';
import '../../student_onboarding/entities/subject_enrollment.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

/// Adds a [Test] to the student's cart, applying the teacher-discount rule
/// via [subjectEnrollments] (project_spec.md §9.2, teacher-discount note).
class AddToCartUseCase {
  const AddToCartUseCase(this._repository);

  final CartRepository _repository;

  Future<Result<Cart>> call(
    String studentId,
    Test test, {
    required List<SubjectEnrollment> subjectEnrollments,
  }) => _repository.addItem(
    studentId,
    test,
    subjectEnrollments: subjectEnrollments,
  );
}
