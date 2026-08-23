import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/catalog/entities/test.dart';

part 'test_dto.freezed.dart';
part 'test_dto.g.dart';

@freezed
abstract class TestDto with _$TestDto {
  const TestDto._();

  const factory TestDto({
    required String id,
    required String title,
    required TestKind kind,
    required String boardClassId,
    required String subjectId,
    String? chapterId,
    @Default(false) bool isLive,
    DateTime? liveDate,
    @Default(false) bool isFreeSample,
    required String createdByAdminId,
    required DateTime createdAt,
    @Default(0) int questionCount,
    @Default(0) int durationMinutes,
    @Default(0) int totalMarks,
  }) = _TestDto;

  factory TestDto.fromJson(Map<String, dynamic> json) =>
      _$TestDtoFromJson(json);

  Test toDomain() => Test(
    id: id,
    title: title,
    kind: kind,
    boardClassId: boardClassId,
    subjectId: subjectId,
    chapterId: chapterId,
    isLive: isLive,
    liveDate: liveDate,
    isFreeSample: isFreeSample,
    createdByAdminId: createdByAdminId,
    createdAt: createdAt,
    questionCount: questionCount,
    durationMinutes: durationMinutes,
    totalMarks: totalMarks,
  );

  factory TestDto.fromDomain(Test entity) => TestDto(
    id: entity.id,
    title: entity.title,
    kind: entity.kind,
    boardClassId: entity.boardClassId,
    subjectId: entity.subjectId,
    chapterId: entity.chapterId,
    isLive: entity.isLive,
    liveDate: entity.liveDate,
    isFreeSample: entity.isFreeSample,
    createdByAdminId: entity.createdByAdminId,
    createdAt: entity.createdAt,
    questionCount: entity.questionCount,
    durationMinutes: entity.durationMinutes,
    totalMarks: entity.totalMarks,
  );
}
