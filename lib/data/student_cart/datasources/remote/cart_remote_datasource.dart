import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/result_guard.dart';
import '../../../../domain/common/result.dart';
import '../../models/add_cart_item_request_dto.dart';
import '../../models/cart_dto.dart';
import '../../models/payment_dto.dart';

/// Dio-backed cart/checkout datasource.
///
/// `ApiEndpoints` only exposes `studentCart(studentId)`, `cartCheckout`
/// (no `{id}` — the backend derives the student from the JWT), and
/// `paymentStatus` (no per-item sub-resource), so add/remove are modeled as
/// a `POST`/`DELETE` against the cart resource itself, each returning the
/// updated cart — matching how `studentCart` is documented as the single
/// read/write surface for a student's cart.
abstract class CartRemoteDataSource {
  Future<Result<CartDto>> getCart(String studentId);

  Future<Result<CartDto>> addSubjectBundle(
    String studentId,
    AddCartItemRequestDto request,
  );

  Future<Result<CartDto>> removeItem(String studentId, String subjectId);

  Future<Result<PaymentDto>> checkout(String studentId);

  Future<Result<Set<String>>> getPurchasedSubjectIds(String studentId);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  CartRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<Result<CartDto>> getCart(String studentId) {
    return guardRequest(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.studentCart(studentId),
      );
      return CartDto.fromJson(response.data!);
    });
  }

  @override
  Future<Result<CartDto>> addSubjectBundle(
    String studentId,
    AddCartItemRequestDto request,
  ) {
    return guardRequest(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.studentCart(studentId),
        data: request.toJson(),
      );
      return CartDto.fromJson(response.data!);
    });
  }

  @override
  Future<Result<CartDto>> removeItem(String studentId, String subjectId) {
    return guardRequest(() async {
      final response = await _dio.delete<Map<String, dynamic>>(
        ApiEndpoints.studentCart(studentId),
        queryParameters: {'subjectId': subjectId},
      );
      return CartDto.fromJson(response.data!);
    });
  }

  @override
  Future<Result<PaymentDto>> checkout(String studentId) {
    return guardRequest(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.cartCheckout,
      );
      return PaymentDto.fromJson(response.data!);
    });
  }

  @override
  Future<Result<Set<String>>> getPurchasedSubjectIds(String studentId) {
    return guardRequest(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.paymentStatus,
        queryParameters: {'studentId': studentId},
      );
      final data = response.data;
      final rawList = data?['purchasedSubjectIds'] as List<dynamic>? ?? [];
      final ids = rawList.map((e) => e.toString()).toSet();
      return ids;
    });
  }
}
