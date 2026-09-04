// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'submission_answer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SubmissionAnswer {

 String get questionId; QuestionType? get type; String? get questionText; String? get answerText; int? get selectedOptionIndex; int? get correctOptionIndex; String? get expectedAnswer; int? get marksAwarded; int? get possibleMarks; List<TokenJudgement>? get tokenJudgements; String? get justification; String? get solutionExplanation; bool get gradedByAi;
/// Create a copy of SubmissionAnswer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubmissionAnswerCopyWith<SubmissionAnswer> get copyWith => _$SubmissionAnswerCopyWithImpl<SubmissionAnswer>(this as SubmissionAnswer, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmissionAnswer&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.type, type) || other.type == type)&&(identical(other.questionText, questionText) || other.questionText == questionText)&&(identical(other.answerText, answerText) || other.answerText == answerText)&&(identical(other.selectedOptionIndex, selectedOptionIndex) || other.selectedOptionIndex == selectedOptionIndex)&&(identical(other.correctOptionIndex, correctOptionIndex) || other.correctOptionIndex == correctOptionIndex)&&(identical(other.expectedAnswer, expectedAnswer) || other.expectedAnswer == expectedAnswer)&&(identical(other.marksAwarded, marksAwarded) || other.marksAwarded == marksAwarded)&&(identical(other.possibleMarks, possibleMarks) || other.possibleMarks == possibleMarks)&&const DeepCollectionEquality().equals(other.tokenJudgements, tokenJudgements)&&(identical(other.justification, justification) || other.justification == justification)&&(identical(other.solutionExplanation, solutionExplanation) || other.solutionExplanation == solutionExplanation)&&(identical(other.gradedByAi, gradedByAi) || other.gradedByAi == gradedByAi));
}


@override
int get hashCode => Object.hash(runtimeType,questionId,type,questionText,answerText,selectedOptionIndex,correctOptionIndex,expectedAnswer,marksAwarded,possibleMarks,const DeepCollectionEquality().hash(tokenJudgements),justification,solutionExplanation,gradedByAi);

@override
String toString() {
  return 'SubmissionAnswer(questionId: $questionId, type: $type, questionText: $questionText, answerText: $answerText, selectedOptionIndex: $selectedOptionIndex, correctOptionIndex: $correctOptionIndex, expectedAnswer: $expectedAnswer, marksAwarded: $marksAwarded, possibleMarks: $possibleMarks, tokenJudgements: $tokenJudgements, justification: $justification, solutionExplanation: $solutionExplanation, gradedByAi: $gradedByAi)';
}


}

/// @nodoc
abstract mixin class $SubmissionAnswerCopyWith<$Res>  {
  factory $SubmissionAnswerCopyWith(SubmissionAnswer value, $Res Function(SubmissionAnswer) _then) = _$SubmissionAnswerCopyWithImpl;
@useResult
$Res call({
 String questionId, QuestionType? type, String? questionText, String? answerText, int? selectedOptionIndex, int? correctOptionIndex, String? expectedAnswer, int? marksAwarded, int? possibleMarks, List<TokenJudgement>? tokenJudgements, String? justification, String? solutionExplanation, bool gradedByAi
});




}
/// @nodoc
class _$SubmissionAnswerCopyWithImpl<$Res>
    implements $SubmissionAnswerCopyWith<$Res> {
  _$SubmissionAnswerCopyWithImpl(this._self, this._then);

  final SubmissionAnswer _self;
  final $Res Function(SubmissionAnswer) _then;

/// Create a copy of SubmissionAnswer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questionId = null,Object? type = freezed,Object? questionText = freezed,Object? answerText = freezed,Object? selectedOptionIndex = freezed,Object? correctOptionIndex = freezed,Object? expectedAnswer = freezed,Object? marksAwarded = freezed,Object? possibleMarks = freezed,Object? tokenJudgements = freezed,Object? justification = freezed,Object? solutionExplanation = freezed,Object? gradedByAi = null,}) {
  return _then(_self.copyWith(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as QuestionType?,questionText: freezed == questionText ? _self.questionText : questionText // ignore: cast_nullable_to_non_nullable
as String?,answerText: freezed == answerText ? _self.answerText : answerText // ignore: cast_nullable_to_non_nullable
as String?,selectedOptionIndex: freezed == selectedOptionIndex ? _self.selectedOptionIndex : selectedOptionIndex // ignore: cast_nullable_to_non_nullable
as int?,correctOptionIndex: freezed == correctOptionIndex ? _self.correctOptionIndex : correctOptionIndex // ignore: cast_nullable_to_non_nullable
as int?,expectedAnswer: freezed == expectedAnswer ? _self.expectedAnswer : expectedAnswer // ignore: cast_nullable_to_non_nullable
as String?,marksAwarded: freezed == marksAwarded ? _self.marksAwarded : marksAwarded // ignore: cast_nullable_to_non_nullable
as int?,possibleMarks: freezed == possibleMarks ? _self.possibleMarks : possibleMarks // ignore: cast_nullable_to_non_nullable
as int?,tokenJudgements: freezed == tokenJudgements ? _self.tokenJudgements : tokenJudgements // ignore: cast_nullable_to_non_nullable
as List<TokenJudgement>?,justification: freezed == justification ? _self.justification : justification // ignore: cast_nullable_to_non_nullable
as String?,solutionExplanation: freezed == solutionExplanation ? _self.solutionExplanation : solutionExplanation // ignore: cast_nullable_to_non_nullable
as String?,gradedByAi: null == gradedByAi ? _self.gradedByAi : gradedByAi // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SubmissionAnswer].
extension SubmissionAnswerPatterns on SubmissionAnswer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubmissionAnswer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubmissionAnswer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubmissionAnswer value)  $default,){
final _that = this;
switch (_that) {
case _SubmissionAnswer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubmissionAnswer value)?  $default,){
final _that = this;
switch (_that) {
case _SubmissionAnswer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String questionId,  QuestionType? type,  String? questionText,  String? answerText,  int? selectedOptionIndex,  int? correctOptionIndex,  String? expectedAnswer,  int? marksAwarded,  int? possibleMarks,  List<TokenJudgement>? tokenJudgements,  String? justification,  String? solutionExplanation,  bool gradedByAi)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubmissionAnswer() when $default != null:
return $default(_that.questionId,_that.type,_that.questionText,_that.answerText,_that.selectedOptionIndex,_that.correctOptionIndex,_that.expectedAnswer,_that.marksAwarded,_that.possibleMarks,_that.tokenJudgements,_that.justification,_that.solutionExplanation,_that.gradedByAi);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String questionId,  QuestionType? type,  String? questionText,  String? answerText,  int? selectedOptionIndex,  int? correctOptionIndex,  String? expectedAnswer,  int? marksAwarded,  int? possibleMarks,  List<TokenJudgement>? tokenJudgements,  String? justification,  String? solutionExplanation,  bool gradedByAi)  $default,) {final _that = this;
switch (_that) {
case _SubmissionAnswer():
return $default(_that.questionId,_that.type,_that.questionText,_that.answerText,_that.selectedOptionIndex,_that.correctOptionIndex,_that.expectedAnswer,_that.marksAwarded,_that.possibleMarks,_that.tokenJudgements,_that.justification,_that.solutionExplanation,_that.gradedByAi);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String questionId,  QuestionType? type,  String? questionText,  String? answerText,  int? selectedOptionIndex,  int? correctOptionIndex,  String? expectedAnswer,  int? marksAwarded,  int? possibleMarks,  List<TokenJudgement>? tokenJudgements,  String? justification,  String? solutionExplanation,  bool gradedByAi)?  $default,) {final _that = this;
switch (_that) {
case _SubmissionAnswer() when $default != null:
return $default(_that.questionId,_that.type,_that.questionText,_that.answerText,_that.selectedOptionIndex,_that.correctOptionIndex,_that.expectedAnswer,_that.marksAwarded,_that.possibleMarks,_that.tokenJudgements,_that.justification,_that.solutionExplanation,_that.gradedByAi);case _:
  return null;

}
}

}

/// @nodoc


class _SubmissionAnswer extends SubmissionAnswer {
  const _SubmissionAnswer({required this.questionId, this.type, this.questionText, this.answerText, this.selectedOptionIndex, this.correctOptionIndex, this.expectedAnswer, this.marksAwarded, this.possibleMarks, this.tokenJudgements, this.justification, this.solutionExplanation, this.gradedByAi = false}): super._();
  

@override final  String questionId;
@override final  QuestionType? type;
@override final  String? questionText;
@override final  String? answerText;
@override final  int? selectedOptionIndex;
@override final  int? correctOptionIndex;
@override final  String? expectedAnswer;
@override final  int? marksAwarded;
@override final  int? possibleMarks;
@override final  List<TokenJudgement>? tokenJudgements;
@override final  String? justification;
@override final  String? solutionExplanation;
@override@JsonKey() final  bool gradedByAi;

/// Create a copy of SubmissionAnswer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmissionAnswerCopyWith<_SubmissionAnswer> get copyWith => __$SubmissionAnswerCopyWithImpl<_SubmissionAnswer>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubmissionAnswer&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.type, type) || other.type == type)&&(identical(other.questionText, questionText) || other.questionText == questionText)&&(identical(other.answerText, answerText) || other.answerText == answerText)&&(identical(other.selectedOptionIndex, selectedOptionIndex) || other.selectedOptionIndex == selectedOptionIndex)&&(identical(other.correctOptionIndex, correctOptionIndex) || other.correctOptionIndex == correctOptionIndex)&&(identical(other.expectedAnswer, expectedAnswer) || other.expectedAnswer == expectedAnswer)&&(identical(other.marksAwarded, marksAwarded) || other.marksAwarded == marksAwarded)&&(identical(other.possibleMarks, possibleMarks) || other.possibleMarks == possibleMarks)&&const DeepCollectionEquality().equals(other.tokenJudgements, tokenJudgements)&&(identical(other.justification, justification) || other.justification == justification)&&(identical(other.solutionExplanation, solutionExplanation) || other.solutionExplanation == solutionExplanation)&&(identical(other.gradedByAi, gradedByAi) || other.gradedByAi == gradedByAi));
}


@override
int get hashCode => Object.hash(runtimeType,questionId,type,questionText,answerText,selectedOptionIndex,correctOptionIndex,expectedAnswer,marksAwarded,possibleMarks,const DeepCollectionEquality().hash(tokenJudgements),justification,solutionExplanation,gradedByAi);

@override
String toString() {
  return 'SubmissionAnswer(questionId: $questionId, type: $type, questionText: $questionText, answerText: $answerText, selectedOptionIndex: $selectedOptionIndex, correctOptionIndex: $correctOptionIndex, expectedAnswer: $expectedAnswer, marksAwarded: $marksAwarded, possibleMarks: $possibleMarks, tokenJudgements: $tokenJudgements, justification: $justification, solutionExplanation: $solutionExplanation, gradedByAi: $gradedByAi)';
}


}

/// @nodoc
abstract mixin class _$SubmissionAnswerCopyWith<$Res> implements $SubmissionAnswerCopyWith<$Res> {
  factory _$SubmissionAnswerCopyWith(_SubmissionAnswer value, $Res Function(_SubmissionAnswer) _then) = __$SubmissionAnswerCopyWithImpl;
@override @useResult
$Res call({
 String questionId, QuestionType? type, String? questionText, String? answerText, int? selectedOptionIndex, int? correctOptionIndex, String? expectedAnswer, int? marksAwarded, int? possibleMarks, List<TokenJudgement>? tokenJudgements, String? justification, String? solutionExplanation, bool gradedByAi
});




}
/// @nodoc
class __$SubmissionAnswerCopyWithImpl<$Res>
    implements _$SubmissionAnswerCopyWith<$Res> {
  __$SubmissionAnswerCopyWithImpl(this._self, this._then);

  final _SubmissionAnswer _self;
  final $Res Function(_SubmissionAnswer) _then;

/// Create a copy of SubmissionAnswer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questionId = null,Object? type = freezed,Object? questionText = freezed,Object? answerText = freezed,Object? selectedOptionIndex = freezed,Object? correctOptionIndex = freezed,Object? expectedAnswer = freezed,Object? marksAwarded = freezed,Object? possibleMarks = freezed,Object? tokenJudgements = freezed,Object? justification = freezed,Object? solutionExplanation = freezed,Object? gradedByAi = null,}) {
  return _then(_SubmissionAnswer(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as QuestionType?,questionText: freezed == questionText ? _self.questionText : questionText // ignore: cast_nullable_to_non_nullable
as String?,answerText: freezed == answerText ? _self.answerText : answerText // ignore: cast_nullable_to_non_nullable
as String?,selectedOptionIndex: freezed == selectedOptionIndex ? _self.selectedOptionIndex : selectedOptionIndex // ignore: cast_nullable_to_non_nullable
as int?,correctOptionIndex: freezed == correctOptionIndex ? _self.correctOptionIndex : correctOptionIndex // ignore: cast_nullable_to_non_nullable
as int?,expectedAnswer: freezed == expectedAnswer ? _self.expectedAnswer : expectedAnswer // ignore: cast_nullable_to_non_nullable
as String?,marksAwarded: freezed == marksAwarded ? _self.marksAwarded : marksAwarded // ignore: cast_nullable_to_non_nullable
as int?,possibleMarks: freezed == possibleMarks ? _self.possibleMarks : possibleMarks // ignore: cast_nullable_to_non_nullable
as int?,tokenJudgements: freezed == tokenJudgements ? _self.tokenJudgements : tokenJudgements // ignore: cast_nullable_to_non_nullable
as List<TokenJudgement>?,justification: freezed == justification ? _self.justification : justification // ignore: cast_nullable_to_non_nullable
as String?,solutionExplanation: freezed == solutionExplanation ? _self.solutionExplanation : solutionExplanation // ignore: cast_nullable_to_non_nullable
as String?,gradedByAi: null == gradedByAi ? _self.gradedByAi : gradedByAi // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
