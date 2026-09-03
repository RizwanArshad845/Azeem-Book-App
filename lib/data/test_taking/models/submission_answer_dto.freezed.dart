// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'submission_answer_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubmissionAnswerDto {

 String get questionId; QuestionType? get type; String? get questionText; String? get answerText; int? get selectedOptionIndex; String? get expectedAnswer; int? get marksAwarded; int? get possibleMarks; List<TokenJudgementDto>? get tokenJudgements; String? get justification; String? get solutionExplanation; bool get gradedByAi;
/// Create a copy of SubmissionAnswerDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubmissionAnswerDtoCopyWith<SubmissionAnswerDto> get copyWith => _$SubmissionAnswerDtoCopyWithImpl<SubmissionAnswerDto>(this as SubmissionAnswerDto, _$identity);

  /// Serializes this SubmissionAnswerDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmissionAnswerDto&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.type, type) || other.type == type)&&(identical(other.questionText, questionText) || other.questionText == questionText)&&(identical(other.answerText, answerText) || other.answerText == answerText)&&(identical(other.selectedOptionIndex, selectedOptionIndex) || other.selectedOptionIndex == selectedOptionIndex)&&(identical(other.expectedAnswer, expectedAnswer) || other.expectedAnswer == expectedAnswer)&&(identical(other.marksAwarded, marksAwarded) || other.marksAwarded == marksAwarded)&&(identical(other.possibleMarks, possibleMarks) || other.possibleMarks == possibleMarks)&&const DeepCollectionEquality().equals(other.tokenJudgements, tokenJudgements)&&(identical(other.justification, justification) || other.justification == justification)&&(identical(other.solutionExplanation, solutionExplanation) || other.solutionExplanation == solutionExplanation)&&(identical(other.gradedByAi, gradedByAi) || other.gradedByAi == gradedByAi));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,type,questionText,answerText,selectedOptionIndex,expectedAnswer,marksAwarded,possibleMarks,const DeepCollectionEquality().hash(tokenJudgements),justification,solutionExplanation,gradedByAi);

@override
String toString() {
  return 'SubmissionAnswerDto(questionId: $questionId, type: $type, questionText: $questionText, answerText: $answerText, selectedOptionIndex: $selectedOptionIndex, expectedAnswer: $expectedAnswer, marksAwarded: $marksAwarded, possibleMarks: $possibleMarks, tokenJudgements: $tokenJudgements, justification: $justification, solutionExplanation: $solutionExplanation, gradedByAi: $gradedByAi)';
}


}

/// @nodoc
abstract mixin class $SubmissionAnswerDtoCopyWith<$Res>  {
  factory $SubmissionAnswerDtoCopyWith(SubmissionAnswerDto value, $Res Function(SubmissionAnswerDto) _then) = _$SubmissionAnswerDtoCopyWithImpl;
@useResult
$Res call({
 String questionId, QuestionType? type, String? questionText, String? answerText, int? selectedOptionIndex, String? expectedAnswer, int? marksAwarded, int? possibleMarks, List<TokenJudgementDto>? tokenJudgements, String? justification, String? solutionExplanation, bool gradedByAi
});




}
/// @nodoc
class _$SubmissionAnswerDtoCopyWithImpl<$Res>
    implements $SubmissionAnswerDtoCopyWith<$Res> {
  _$SubmissionAnswerDtoCopyWithImpl(this._self, this._then);

  final SubmissionAnswerDto _self;
  final $Res Function(SubmissionAnswerDto) _then;

/// Create a copy of SubmissionAnswerDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questionId = null,Object? type = freezed,Object? questionText = freezed,Object? answerText = freezed,Object? selectedOptionIndex = freezed,Object? expectedAnswer = freezed,Object? marksAwarded = freezed,Object? possibleMarks = freezed,Object? tokenJudgements = freezed,Object? justification = freezed,Object? solutionExplanation = freezed,Object? gradedByAi = null,}) {
  return _then(_self.copyWith(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as QuestionType?,questionText: freezed == questionText ? _self.questionText : questionText // ignore: cast_nullable_to_non_nullable
as String?,answerText: freezed == answerText ? _self.answerText : answerText // ignore: cast_nullable_to_non_nullable
as String?,selectedOptionIndex: freezed == selectedOptionIndex ? _self.selectedOptionIndex : selectedOptionIndex // ignore: cast_nullable_to_non_nullable
as int?,expectedAnswer: freezed == expectedAnswer ? _self.expectedAnswer : expectedAnswer // ignore: cast_nullable_to_non_nullable
as String?,marksAwarded: freezed == marksAwarded ? _self.marksAwarded : marksAwarded // ignore: cast_nullable_to_non_nullable
as int?,possibleMarks: freezed == possibleMarks ? _self.possibleMarks : possibleMarks // ignore: cast_nullable_to_non_nullable
as int?,tokenJudgements: freezed == tokenJudgements ? _self.tokenJudgements : tokenJudgements // ignore: cast_nullable_to_non_nullable
as List<TokenJudgementDto>?,justification: freezed == justification ? _self.justification : justification // ignore: cast_nullable_to_non_nullable
as String?,solutionExplanation: freezed == solutionExplanation ? _self.solutionExplanation : solutionExplanation // ignore: cast_nullable_to_non_nullable
as String?,gradedByAi: null == gradedByAi ? _self.gradedByAi : gradedByAi // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SubmissionAnswerDto].
extension SubmissionAnswerDtoPatterns on SubmissionAnswerDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubmissionAnswerDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubmissionAnswerDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubmissionAnswerDto value)  $default,){
final _that = this;
switch (_that) {
case _SubmissionAnswerDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubmissionAnswerDto value)?  $default,){
final _that = this;
switch (_that) {
case _SubmissionAnswerDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String questionId,  QuestionType? type,  String? questionText,  String? answerText,  int? selectedOptionIndex,  String? expectedAnswer,  int? marksAwarded,  int? possibleMarks,  List<TokenJudgementDto>? tokenJudgements,  String? justification,  String? solutionExplanation,  bool gradedByAi)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubmissionAnswerDto() when $default != null:
return $default(_that.questionId,_that.type,_that.questionText,_that.answerText,_that.selectedOptionIndex,_that.expectedAnswer,_that.marksAwarded,_that.possibleMarks,_that.tokenJudgements,_that.justification,_that.solutionExplanation,_that.gradedByAi);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String questionId,  QuestionType? type,  String? questionText,  String? answerText,  int? selectedOptionIndex,  String? expectedAnswer,  int? marksAwarded,  int? possibleMarks,  List<TokenJudgementDto>? tokenJudgements,  String? justification,  String? solutionExplanation,  bool gradedByAi)  $default,) {final _that = this;
switch (_that) {
case _SubmissionAnswerDto():
return $default(_that.questionId,_that.type,_that.questionText,_that.answerText,_that.selectedOptionIndex,_that.expectedAnswer,_that.marksAwarded,_that.possibleMarks,_that.tokenJudgements,_that.justification,_that.solutionExplanation,_that.gradedByAi);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String questionId,  QuestionType? type,  String? questionText,  String? answerText,  int? selectedOptionIndex,  String? expectedAnswer,  int? marksAwarded,  int? possibleMarks,  List<TokenJudgementDto>? tokenJudgements,  String? justification,  String? solutionExplanation,  bool gradedByAi)?  $default,) {final _that = this;
switch (_that) {
case _SubmissionAnswerDto() when $default != null:
return $default(_that.questionId,_that.type,_that.questionText,_that.answerText,_that.selectedOptionIndex,_that.expectedAnswer,_that.marksAwarded,_that.possibleMarks,_that.tokenJudgements,_that.justification,_that.solutionExplanation,_that.gradedByAi);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubmissionAnswerDto extends SubmissionAnswerDto {
  const _SubmissionAnswerDto({required this.questionId, this.type, this.questionText, this.answerText, this.selectedOptionIndex, this.expectedAnswer, this.marksAwarded, this.possibleMarks, this.tokenJudgements, this.justification, this.solutionExplanation, this.gradedByAi = false}): super._();
  factory _SubmissionAnswerDto.fromJson(Map<String, dynamic> json) => _$SubmissionAnswerDtoFromJson(json);

@override final  String questionId;
@override final  QuestionType? type;
@override final  String? questionText;
@override final  String? answerText;
@override final  int? selectedOptionIndex;
@override final  String? expectedAnswer;
@override final  int? marksAwarded;
@override final  int? possibleMarks;
@override final  List<TokenJudgementDto>? tokenJudgements;
@override final  String? justification;
@override final  String? solutionExplanation;
@override@JsonKey() final  bool gradedByAi;

/// Create a copy of SubmissionAnswerDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmissionAnswerDtoCopyWith<_SubmissionAnswerDto> get copyWith => __$SubmissionAnswerDtoCopyWithImpl<_SubmissionAnswerDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubmissionAnswerDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubmissionAnswerDto&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.type, type) || other.type == type)&&(identical(other.questionText, questionText) || other.questionText == questionText)&&(identical(other.answerText, answerText) || other.answerText == answerText)&&(identical(other.selectedOptionIndex, selectedOptionIndex) || other.selectedOptionIndex == selectedOptionIndex)&&(identical(other.expectedAnswer, expectedAnswer) || other.expectedAnswer == expectedAnswer)&&(identical(other.marksAwarded, marksAwarded) || other.marksAwarded == marksAwarded)&&(identical(other.possibleMarks, possibleMarks) || other.possibleMarks == possibleMarks)&&const DeepCollectionEquality().equals(other.tokenJudgements, tokenJudgements)&&(identical(other.justification, justification) || other.justification == justification)&&(identical(other.solutionExplanation, solutionExplanation) || other.solutionExplanation == solutionExplanation)&&(identical(other.gradedByAi, gradedByAi) || other.gradedByAi == gradedByAi));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,type,questionText,answerText,selectedOptionIndex,expectedAnswer,marksAwarded,possibleMarks,const DeepCollectionEquality().hash(tokenJudgements),justification,solutionExplanation,gradedByAi);

@override
String toString() {
  return 'SubmissionAnswerDto(questionId: $questionId, type: $type, questionText: $questionText, answerText: $answerText, selectedOptionIndex: $selectedOptionIndex, expectedAnswer: $expectedAnswer, marksAwarded: $marksAwarded, possibleMarks: $possibleMarks, tokenJudgements: $tokenJudgements, justification: $justification, solutionExplanation: $solutionExplanation, gradedByAi: $gradedByAi)';
}


}

/// @nodoc
abstract mixin class _$SubmissionAnswerDtoCopyWith<$Res> implements $SubmissionAnswerDtoCopyWith<$Res> {
  factory _$SubmissionAnswerDtoCopyWith(_SubmissionAnswerDto value, $Res Function(_SubmissionAnswerDto) _then) = __$SubmissionAnswerDtoCopyWithImpl;
@override @useResult
$Res call({
 String questionId, QuestionType? type, String? questionText, String? answerText, int? selectedOptionIndex, String? expectedAnswer, int? marksAwarded, int? possibleMarks, List<TokenJudgementDto>? tokenJudgements, String? justification, String? solutionExplanation, bool gradedByAi
});




}
/// @nodoc
class __$SubmissionAnswerDtoCopyWithImpl<$Res>
    implements _$SubmissionAnswerDtoCopyWith<$Res> {
  __$SubmissionAnswerDtoCopyWithImpl(this._self, this._then);

  final _SubmissionAnswerDto _self;
  final $Res Function(_SubmissionAnswerDto) _then;

/// Create a copy of SubmissionAnswerDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questionId = null,Object? type = freezed,Object? questionText = freezed,Object? answerText = freezed,Object? selectedOptionIndex = freezed,Object? expectedAnswer = freezed,Object? marksAwarded = freezed,Object? possibleMarks = freezed,Object? tokenJudgements = freezed,Object? justification = freezed,Object? solutionExplanation = freezed,Object? gradedByAi = null,}) {
  return _then(_SubmissionAnswerDto(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as QuestionType?,questionText: freezed == questionText ? _self.questionText : questionText // ignore: cast_nullable_to_non_nullable
as String?,answerText: freezed == answerText ? _self.answerText : answerText // ignore: cast_nullable_to_non_nullable
as String?,selectedOptionIndex: freezed == selectedOptionIndex ? _self.selectedOptionIndex : selectedOptionIndex // ignore: cast_nullable_to_non_nullable
as int?,expectedAnswer: freezed == expectedAnswer ? _self.expectedAnswer : expectedAnswer // ignore: cast_nullable_to_non_nullable
as String?,marksAwarded: freezed == marksAwarded ? _self.marksAwarded : marksAwarded // ignore: cast_nullable_to_non_nullable
as int?,possibleMarks: freezed == possibleMarks ? _self.possibleMarks : possibleMarks // ignore: cast_nullable_to_non_nullable
as int?,tokenJudgements: freezed == tokenJudgements ? _self.tokenJudgements : tokenJudgements // ignore: cast_nullable_to_non_nullable
as List<TokenJudgementDto>?,justification: freezed == justification ? _self.justification : justification // ignore: cast_nullable_to_non_nullable
as String?,solutionExplanation: freezed == solutionExplanation ? _self.solutionExplanation : solutionExplanation // ignore: cast_nullable_to_non_nullable
as String?,gradedByAi: null == gradedByAi ? _self.gradedByAi : gradedByAi // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
