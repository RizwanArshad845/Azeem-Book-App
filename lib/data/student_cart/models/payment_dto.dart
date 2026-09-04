import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/network/converters/decimal_json_converter.dart';
import '../../../domain/student_cart/entities/payment.dart';

part 'payment_dto.freezed.dart';
part 'payment_dto.g.dart';

@freezed
abstract class PaymentDto with _$PaymentDto {
  const PaymentDto._();

  const factory PaymentDto({
    required String id,
    required String studentId,
    @DecimalStringConverter() required double amount,
    required PaymentStatus status,
    String? gatewayReference,
    required DateTime createdAt,
  }) = _PaymentDto;

  factory PaymentDto.fromJson(Map<String, dynamic> json) =>
      _$PaymentDtoFromJson(json);

  Payment toDomain() => Payment(
    id: id,
    studentId: studentId,
    amount: amount,
    status: status,
    gatewayReference: gatewayReference,
    createdAt: createdAt,
  );

  factory PaymentDto.fromDomain(Payment entity) => PaymentDto(
    id: entity.id,
    studentId: entity.studentId,
    amount: entity.amount,
    status: entity.status,
    gatewayReference: entity.gatewayReference,
    createdAt: entity.createdAt,
  );
}
