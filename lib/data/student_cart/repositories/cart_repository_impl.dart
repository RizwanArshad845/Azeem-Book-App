import '../../../core/config/app_config.dart';
import '../../../domain/catalog/entities/test.dart';
import '../../../domain/common/result.dart';
import '../../../domain/student_cart/entities/cart.dart';
import '../../../domain/student_cart/entities/payment.dart';
import '../../../domain/student_cart/repositories/cart_repository.dart';
import '../../../domain/student_cart/usecases/price_for_test.dart';
import '../../../domain/student_onboarding/entities/subject_enrollment.dart';
import '../datasources/local/cart_dummy_datasource.dart';
import '../datasources/remote/cart_remote_datasource.dart';
import '../models/cart_item_dto.dart';

/// Switches between [CartRemoteDataSource] and [CartDummyDataSource] based
/// on `AppConfig.isMockMode` (project_spec.md §6.2) and maps DTOs to domain
/// entities so nothing above this layer ever sees a DTO.
///
/// Also owns the pricing/discount computation for [addItem] (§9.2 pricing
/// note + teacher-discount rule) since `Test` has no price field and the
/// discount depends on the student's `SubjectEnrollment`s passed in by the
/// caller — see `CartRepository.addItem` doc comment for why those are
/// parameters instead of being looked up here via another repository.
class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl({
    required this.remote,
    required this.dummy,
    this.isMockMode = AppConfig.isMockMode,
  });

  final CartRemoteDataSource remote;
  final CartDummyDataSource dummy;
  final bool isMockMode;

  /// 20% off (arbitrary but consistent demo rate — §9.2 doesn't specify
  /// one) applied when the student picked a teacher for the test's subject.
  static const _teacherDiscountMultiplier = 0.8;

  @override
  Future<Result<Cart>> getCart(String studentId) async {
    final result = isMockMode
        ? await dummy.getCart(studentId)
        : await remote.getCart(studentId);
    return result.when(
      success: (dto) => Success(dto.toDomain()),
      failure: (f) => ResultFailure(f),
    );
  }

  @override
  Future<Result<Cart>> addItem(
    String studentId,
    Test test, {
    required List<SubjectEnrollment> subjectEnrollments,
  }) async {
    final basePrice = priceForTest(test);

    SubjectEnrollment? enrollment;
    for (final candidate in subjectEnrollments) {
      if (candidate.subjectId == test.subjectId) {
        enrollment = candidate;
        break;
      }
    }
    final discountedPrice = (enrollment?.discountApplied ?? false)
        ? basePrice * _teacherDiscountMultiplier
        : null;

    final item = CartItemDto(
      testId: test.id,
      price: basePrice,
      discountedPrice: discountedPrice,
    );

    final result = isMockMode
        ? await dummy.addItem(studentId, item)
        : await remote.addItem(studentId, item);
    return result.when(
      success: (dto) => Success(dto.toDomain()),
      failure: (f) => ResultFailure(f),
    );
  }

  @override
  Future<Result<Cart>> removeItem(String studentId, String testId) async {
    final result = isMockMode
        ? await dummy.removeItem(studentId, testId)
        : await remote.removeItem(studentId, testId);
    return result.when(
      success: (dto) => Success(dto.toDomain()),
      failure: (f) => ResultFailure(f),
    );
  }

  @override
  Future<Result<Payment>> checkout(String studentId) async {
    final result = isMockMode
        ? await dummy.checkout(studentId)
        : await remote.checkout(studentId);
    return result.when(
      success: (dto) => Success(dto.toDomain()),
      failure: (f) => ResultFailure(f),
    );
  }

  @override
  Future<Result<Set<String>>> getPurchasedTestIds(String studentId) {
    return isMockMode
        ? dummy.getPurchasedTestIds(studentId)
        : remote.getPurchasedTestIds(studentId);
  }
}
