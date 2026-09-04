// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TestDto _$TestDtoFromJson(Map<String, dynamic> json) => _TestDto(
  id: json['id'] as String,
  title: json['title'] as String,
  kind: $enumDecode(_$TestKindEnumMap, json['kind']),
  boardClassId: json['boardClassId'] as String,
  subjectId: json['subjectId'] as String,
  chapterId: json['chapterId'] as String?,
  isLive: json['isLive'] as bool? ?? false,
  liveDate: json['liveDate'] == null
      ? null
      : DateTime.parse(json['liveDate'] as String),
  isFreeSample: json['isFreeSample'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
  questionCount: (json['questionCount'] as num?)?.toInt() ?? 0,
  durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 0,
  totalMarks: (json['totalMarks'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$TestDtoToJson(_TestDto instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'kind': _$TestKindEnumMap[instance.kind]!,
  'boardClassId': instance.boardClassId,
  'subjectId': instance.subjectId,
  'chapterId': instance.chapterId,
  'isLive': instance.isLive,
  'liveDate': instance.liveDate?.toIso8601String(),
  'isFreeSample': instance.isFreeSample,
  'createdAt': instance.createdAt.toIso8601String(),
  'questionCount': instance.questionCount,
  'durationMinutes': instance.durationMinutes,
  'totalMarks': instance.totalMarks,
};

const _$TestKindEnumMap = {
  TestKind.subjectWiseGuessPaper: 'subjectWiseGuessPaper',
  TestKind.subjectWiseSimplePaper: 'subjectWiseSimplePaper',
  TestKind.chapterWise: 'chapterWise',
};
