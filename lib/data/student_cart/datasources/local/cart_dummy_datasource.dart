import '../../../../domain/common/result.dart';
import '../../../../domain/student_cart/entities/payment.dart';
import '../../models/cart_dto.dart';
import '../../models/cart_item_dto.dart';
import '../../models/payment_dto.dart';

/// Same method signatures as [CartRemoteDataSource] so the repository can
/// swap between the two based purely on `AppConfig.isMockMode` (§6.2).
abstract class CartDummyDataSource {
  Future<Result<CartDto>> getCart(String studentId);

  Future<Result<CartDto>> addItem(String studentId, CartItemDto item);

  Future<Result<CartDto>> removeItem(String studentId, String testId);

  Future<Result<PaymentDto>> checkout(String studentId);

  Future<Result<Set<String>>> getPurchasedTestIds(String studentId);
}

/// In-memory per-student cart + purchased-test-id tracking. `checkout`
/// always resolves `success` after a short simulated gateway delay (no real
/// backend to fail against yet), clears the cart's items, and accumulates
/// the checked-out `testId`s into that student's purchased set — this is
/// what backs `GetPurchasedTestIdsUseCase` for the whole app session.
class CartDummyDataSourceImpl implements CartDummyDataSource {
  static const _latency = Duration(milliseconds: 400);
  static const _checkoutLatency = Duration(milliseconds: 900);

  final Map<String, CartDto> _cartsByStudentId = {};
  final Map<String, Set<String>> _purchasedTestIdsByStudentId = {};

  int _cartCounter = 0;
  int _paymentCounter = 0;

  CartDto _cartFor(String studentId) {
    return _cartsByStudentId.putIfAbsent(studentId, () {
      _cartCounter++;
      return CartDto(
        id: 'cart-$_cartCounter',
        studentId: studentId,
        items: const [],
        totalAmount: 0,
      );
    });
  }

  double _total(List<CartItemDto> items) =>
      items.fold(0.0, (sum, item) => sum + (item.discountedPrice ?? item.price));

  @override
  Future<Result<CartDto>> getCart(String studentId) async {
    await Future.delayed(_latency);
    return Success(_cartFor(studentId));
  }

  @override
  Future<Result<CartDto>> addItem(String studentId, CartItemDto item) async {
    await Future.delayed(_latency);
    final cart = _cartFor(studentId);
    final items = List<CartItemDto>.from(cart.items ?? const []);

    if (items.any((existing) => existing.testId == item.testId)) {
      // Already in the cart — no-op per the repository contract.
      return Success(cart);
    }

    items.add(item);
    final updated = cart.copyWith(items: items, totalAmount: _total(items));
    _cartsByStudentId[studentId] = updated;
    return Success(updated);
  }

  @override
  Future<Result<CartDto>> removeItem(String studentId, String testId) async {
    await Future.delayed(_latency);
    final cart = _cartFor(studentId);
    final items = (cart.items ?? const [])
        .where((item) => item.testId != testId)
        .toList();
    final updated = cart.copyWith(items: items, totalAmount: _total(items));
    _cartsByStudentId[studentId] = updated;
    return Success(updated);
  }

  @override
  Future<Result<PaymentDto>> checkout(String studentId) async {
    await Future.delayed(_checkoutLatency);
    final cart = _cartFor(studentId);
    final items = cart.items ?? const <CartItemDto>[];

    _paymentCounter++;
    final payment = PaymentDto(
      id: 'payment-$_paymentCounter',
      studentId: studentId,
      amount: _total(items),
      status: PaymentStatus.success,
      gatewayReference: 'DUMMY-GATEWAY-REF-$_paymentCounter',
      createdAt: DateTime.now(),
    );

    final purchased = _purchasedTestIdsByStudentId.putIfAbsent(
      studentId,
      () => <String>{},
    );
    purchased.addAll(items.map((item) => item.testId));

    _cartsByStudentId[studentId] = cart.copyWith(items: const [], totalAmount: 0);

    return Success(payment);
  }

  @override
  Future<Result<Set<String>>> getPurchasedTestIds(String studentId) async {
    await Future.delayed(_latency);
    return Success(
      Set.unmodifiable(_purchasedTestIdsByStudentId[studentId] ?? const <String>{}),
    );
  }
}
