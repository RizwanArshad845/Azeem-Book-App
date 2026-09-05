import '../../../domain/catalog/entities/subject.dart';
import '../../../domain/catalog/entities/test.dart';
import '../../../domain/common/failure.dart';
import '../../../domain/common/result.dart';
import '../../../domain/student_cart/entities/cart.dart';
import '../../../domain/student_cart/entities/payment.dart';
import '../../../domain/student_cart/repositories/cart_repository.dart';
import '../../../domain/student_cart/usecases/price_for_subject_bundle.dart';
import '../../../domain/student_onboarding/entities/subject_enrollment.dart';
import '../datasources/remote/cart_remote_datasource.dart';
import '../models/cart_dto.dart';
import '../models/cart_item_dto.dart';

/// Maps [CartRemoteDataSource] DTOs to domain entities so nothing above
/// this layer ever sees a DTO.
///
/// Also owns the pricing/discount computation for [addSubjectBundle] (§9.2
/// pricing note + teacher-discount rule) since `Test` has no price field and
/// the discount depends on the student's `SubjectEnrollment`s passed in by
/// the caller — see `CartRepository.addSubjectBundle` doc comment for why
/// those are parameters instead of being looked up here via another
/// repository.
///
/// In-memory caches (mirroring `CampusRepositoryImpl`/`CatalogRepositoryImpl`)
/// so `StudentOnboardingViewModel`'s post-submit dashboard preload actually
/// pays off instead of just firing a discarded request. Unlike the read-only
/// catalog caches, this one must stay consistent across mutations —
/// [addSubjectBundle]/[removeItem] write the server's returned `Cart`
/// straight back into the cache (never stale), and [checkout] clears both
/// caches for the student since it clears the cart and changes purchased
/// subjects server-side without returning either back to the caller.
class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl({required this.remote});

  final CartRemoteDataSource remote;

  final Map<String, Cart> _cachedCartByStudent = {};
  final Map<String, Set<String>> _cachedPurchasedIdsByStudent = {};
  final Map<String, String> _knownSubjectNames = {};
  final Map<String, int> _knownTestCounts = {};

  Cart _toCart(CartDto dto) {
    final cart = dto.toDomain();
    final items = cart.items?.map((item) {
      final name = (item.subjectName != null && item.subjectName!.isNotEmpty)
          ? item.subjectName
          : _knownSubjectNames[item.subjectId];
      final count = item.testCount ?? _knownTestCounts[item.subjectId];
      return item.copyWith(
        subjectName: name,
        testCount: count,
      );
    }).toList();
    return cart.copyWith(items: items);
  }

  /// 20% off (arbitrary but consistent demo rate — §9.2 doesn't specify
  /// one) applied when the student picked a teacher for the subject.
  static const _teacherDiscountMultiplier = 0.8;

  @override
  Future<Result<Cart>> getCart(
    String studentId, {
    bool forceRefresh = false,
  }) async {
    final cached = _cachedCartByStudent[studentId];
    if (cached != null && !forceRefresh) {
      return Success(cached);
    }

    final result = await remote.getCart(studentId);
    return result.when(
      success: (dto) {
        final cart = _toCart(dto);
        _cachedCartByStudent[studentId] = cart;
        return Success(cart);
      },
      failure: (f) {
        if (f is NotFoundFailure) {
          final empty = Cart(
            id: studentId,
            studentId: studentId,
            items: const [],
            totalAmount: 0,
          );
          _cachedCartByStudent[studentId] = empty;
          return Success(empty);
        }
        final stale = _cachedCartByStudent[studentId];
        return stale != null ? Success(stale) : ResultFailure(f);
      },
    );
  }

  @override
  Future<Result<Cart>> addSubjectBundle(
    String studentId,
    Subject subject,
    List<Test> tests, {
    required List<SubjectEnrollment> subjectEnrollments,
  }) async {
    _knownSubjectNames[subject.id] = subject.name;
    _knownTestCounts[subject.id] = tests.length;

    final basePrice = priceForSubjectBundle(tests);

    SubjectEnrollment? enrollment;
    for (final candidate in subjectEnrollments) {
      if (candidate.subjectId == subject.id) {
        enrollment = candidate;
        break;
      }
    }
    final discountedPrice = (enrollment?.discountApplied ?? false)
        ? basePrice * _teacherDiscountMultiplier
        : null;

    final item = CartItemDto(
      subjectId: subject.id,
      subjectName: subject.name,
      testCount: tests.length,
      price: basePrice,
      discountedPrice: discountedPrice,
    );

    final result = await remote.addSubjectBundle(studentId, item);
    return result.when(
      success: (dto) {
        final cart = _toCart(dto);
        _cachedCartByStudent[studentId] = cart;
        return Success(cart);
      },
      failure: (f) => ResultFailure(f),
    );
  }

  @override
  Future<Result<Cart>> removeItem(String studentId, String subjectId) async {
    final result = await remote.removeItem(studentId, subjectId);
    return result.when(
      success: (dto) {
        final cart = _toCart(dto);
        _cachedCartByStudent[studentId] = cart;
        return Success(cart);
      },
      failure: (f) => ResultFailure(f),
    );
  }

  @override
  Future<Result<Payment>> checkout(String studentId) async {
    final result = await remote.checkout(studentId);
    return result.when(
      success: (dto) {
        // Backend clears the cart's items and grants the purchased subjects
        // on success, but doesn't hand either back here — clear rather than
        // update so the next read (`StudentCartViewModel.checkout`'s
        // `ref.invalidateSelf()`) actually goes to the network instead of
        // replaying the pre-checkout cache.
        _cachedCartByStudent.remove(studentId);
        _cachedPurchasedIdsByStudent.remove(studentId);
        return Success(dto.toDomain());
      },
      failure: (f) => ResultFailure(f),
    );
  }

  @override
  Future<Result<Set<String>>> getPurchasedSubjectIds(
    String studentId, {
    bool forceRefresh = false,
  }) async {
    final cached = _cachedPurchasedIdsByStudent[studentId];
    if (cached != null && !forceRefresh) {
      return Success(cached);
    }

    final result = await remote.getPurchasedSubjectIds(studentId);
    return result.when(
      success: (ids) {
        _cachedPurchasedIdsByStudent[studentId] = ids;
        return Success(ids);
      },
      failure: (f) {
        final stale = _cachedPurchasedIdsByStudent[studentId];
        return stale != null ? Success(stale) : ResultFailure(f);
      },
    );
  }

  @override
  void clearCache() {
    _cachedCartByStudent.clear();
    _cachedPurchasedIdsByStudent.clear();
  }
}
