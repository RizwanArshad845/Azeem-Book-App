import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/earnings/entities/earnings_record.dart';

part 'earnings_record_dto.freezed.dart';
part 'earnings_record_dto.g.dart';

@freezed
abstract class EarningsRecordDto with _$EarningsRecordDto {
  const EarningsRecordDto._();

  const factory EarningsRecordDto({
    required String id,
    String? teacherId,
    String? salesmanId,
    required String studentId,
    required double amount,
    required EarningsTriggerEvent triggerEvent,
    required DateTime createdAt,
  }) = _EarningsRecordDto;

  factory EarningsRecordDto.fromJson(Map<String, dynamic> json) =>
      _$EarningsRecordDtoFromJson(json);

  EarningsRecord toDomain() => EarningsRecord(
    id: id,
    teacherId: teacherId,
    salesmanId: salesmanId,
    studentId: studentId,
    amount: amount,
    triggerEvent: triggerEvent,
    createdAt: createdAt,
  );

  factory EarningsRecordDto.fromDomain(EarningsRecord entity) =>
      EarningsRecordDto(
        id: entity.id,
        teacherId: entity.teacherId,
        salesmanId: entity.salesmanId,
        studentId: entity.studentId,
        amount: entity.amount,
        triggerEvent: entity.triggerEvent,
        createdAt: entity.createdAt,
      );
}
