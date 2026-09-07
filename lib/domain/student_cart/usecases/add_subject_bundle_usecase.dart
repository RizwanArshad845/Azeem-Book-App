import '../../catalog/entities/subject.dart';
import '../../catalog/entities/test.dart';
import '../../common/result.dart';
import '../entities/cart.dart';
import '../repositories/cart_repository.dart';

/// Adds a whole [Subject] bundle (all of [tests]) to the student's cart.
/// Pricing and any teacher-discount are fully server-computed
/// (project_spec.md §9.2 pricing note; `MOBILE_CHANGES.md` §2–3).
class AddSubjectBundleUseCase {
  const AddSubjectBundleUseCase(this._repository);

  final CartRepository _repository;

  Future<Result<Cart>> call(
    String studentId,
    Subject subject,
    List<Test> tests,
  ) => _repository.addSubjectBundle(studentId, subject, tests);
}
