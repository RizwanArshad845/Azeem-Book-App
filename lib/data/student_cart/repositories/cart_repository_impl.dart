import '../../../domain/catalog/entities/subject.dart';
import '../../../domain/catalog/entities/test.dart';
import '../../../domain/common/failure.dart';
import '../../../domain/common/result.dart';
import '../../../domain/student_cart/entities/cart.dart';
import '../../../domain/student_cart/entities/payment.dart';
import '../../../domain/student_cart/repositories/cart_repository.dart';
import '../datasources/remote/cart_remote_datasource.dart';
import '../models/add_cart_item_request_dto.dart';
import '../models/cart_dto.dart';

/// Maps [CartRemoteDataSource] DTOs to domain entities so nothing above
/// this layer ever sees a DTO.
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
  final Map<String, Set<String>> _cachedPendingIdsByStudent = {};
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
    final computedTotal = (items != null && items.isNotEmpty)
        ? items.fold<double>(
            0.0,
            (sum, item) => sum + (item.discountedPrice ?? item.price),
          )
        : dto.totalAmount;
    return cart.copyWith(items: items, totalAmount: computedTotal);
  }

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
    List<Test> tests,
  ) async {
    _knownSubjectNames[subject.id] = subject.name;
    _knownTestCounts[subject.id] = tests.length;

    final request = AddCartItemRequestDto(subjectId: subject.id);

    final result = await remote.addSubjectBundle(studentId, request);
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
        // A gateway checkout comes back `pending`: the backend has reserved
        // the cart items, but nothing is purchased until its webhook
        // settles the payment. Drop the cart cache so the next read sees
        // the server's state (items return to the cart if payment fails).
        if (dto.status != PaymentStatus.success) {
          _cachedCartByStudent.remove(studentId);
          _cachedPendingIdsByStudent.remove(studentId);
          return Success(dto.toDomain());
        }

        final currentItems =
            _cachedCartByStudent[studentId]?.items ?? const [];
        final newPurchasedIds =
            currentItems.map((i) => i.subjectId).toSet();

        // Immediately update cart cache to empty cart for 0ms re-reads.
        _cachedCartByStudent[studentId] = Cart(
          id: studentId,
          studentId: studentId,
          items: const [],
          totalAmount: 0,
        );

        // Immediately augment the cached purchased IDs.
        final currentPurchased = _cachedPurchasedIdsByStudent[studentId];
        if (currentPurchased != null) {
          currentPurchased.addAll(newPurchasedIds);
        } else if (newPurchasedIds.isNotEmpty) {
          _cachedPurchasedIdsByStudent[studentId] = newPurchasedIds;
        }

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
    return _fetchPaymentStatus(studentId, _cachedPurchasedIdsByStudent);
  }

  @override
  Future<Result<Set<String>>> getPendingSubjectIds(
    String studentId, {
    bool forceRefresh = false,
  }) async {
    final cached = _cachedPendingIdsByStudent[studentId];
    if (cached != null && !forceRefresh) {
      return Success(cached);
    }
    return _fetchPaymentStatus(studentId, _cachedPendingIdsByStudent);
  }

  /// One `/payments/status` call refreshes both caches, so a caller polling
  /// one set can read the other straight after without a second request.
  /// Returns the set held in [cache]; falls back to its stale value on error.
  Future<Result<Set<String>>> _fetchPaymentStatus(
    String studentId,
    Map<String, Set<String>> cache,
  ) async {
    final result = await remote.getPaymentStatus(studentId);
    return result.when(
      success: (status) {
        _cachedPurchasedIdsByStudent[studentId] = status.purchased;
        _cachedPendingIdsByStudent[studentId] = status.pending;
        return Success(cache[studentId]!);
      },
      failure: (f) {
        final stale = cache[studentId];
        return stale != null ? Success(stale) : ResultFailure(f);
      },
    );
  }

  @override
  void clearCache() {
    _cachedCartByStudent.clear();
    _cachedPurchasedIdsByStudent.clear();
    _cachedPendingIdsByStudent.clear();
  }
}
