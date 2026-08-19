import 'package:freezed_annotation/freezed_annotation.dart';

part 'earnings_record.freezed.dart';

/// `triggerEvent` of an [EarningsRecord] (project_spec.md §9.2). Only one
/// value exists in phase-1 scope: a student completing a paid-pack purchase.
enum EarningsTriggerEvent { paidPackPurchase }

/// A commission attributed to a Teacher (and optionally a Salesman — see
/// note below) when a student completes a paid-pack purchase
/// (project_spec.md §9.1: "Triggered when a student completes a paid-pack
/// purchase; attributes a commission to the `teacherId` (and optionally
/// `salesmanId`) associated with that subject/enrollment"; §9.2
/// `EarningsRecord`).
///
/// `salesmanId` exists only as a nullable FK per the schema — this app has
/// no `Salesman` entity/feature (out of scope, per §9.1 narrative), so it is
/// never populated or read here; it is carried through purely so the field
/// isn't silently dropped from the schema.
@freezed
abstract class EarningsRecord with _$EarningsRecord {
  const factory EarningsRecord({
    required String id,
    String? teacherId,
    String? salesmanId,
    required String studentId,
    required double amount,
    required EarningsTriggerEvent triggerEvent,
    required DateTime createdAt,
  }) = _EarningsRecord;
}
