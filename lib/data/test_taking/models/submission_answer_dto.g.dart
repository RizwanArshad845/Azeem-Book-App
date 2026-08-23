// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_answer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubmissionAnswerDto _$SubmissionAnswerDtoFromJson(Map<String, dynamic> json) =>
    _SubmissionAnswerDto(
      questionId: json['questionId'] as String,
      answerText: json['answerText'] as String?,
      selectedOptionIndex: (json['selectedOptionIndex'] as num?)?.toInt(),
      isCorrect: json['isCorrect'] as bool?,
      gradedByAi: json['gradedByAi'] as bool? ?? false,
      solutionExplanation: json['solutionExplanation'] as String?,
    );

Map<String, dynamic> _$SubmissionAnswerDtoToJson(
  _SubmissionAnswerDto instance,
) => <String, dynamic>{
  'questionId': instance.questionId,
  'answerText': instance.answerText,
  'selectedOptionIndex': instance.selectedOptionIndex,
  'isCorrect': instance.isCorrect,
  'gradedByAi': instance.gradedByAi,
  'solutionExplanation': instance.solutionExplanation,
};
