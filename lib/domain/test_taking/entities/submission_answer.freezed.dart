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

 String get questionId; String? get answerText; int? get selectedOptionIndex; bool? get isCorrect; bool get gradedByAi; String? get solutionExplanation;
/// Create a copy of SubmissionAnswer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubmissionAnswerCopyWith<SubmissionAnswer> get copyWith => _$SubmissionAnswerCopyWithImpl<SubmissionAnswer>(this as SubmissionAnswer, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmissionAnswer&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.answerText, answerText) || other.answerText == answerText)&&(identical(other.selectedOptionIndex, selectedOptionIndex) || other.selectedOptionIndex == selectedOptionIndex)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.gradedByAi, gradedByAi) || other.gradedByAi == gradedByAi)&&(identical(other.solutionExplanation, solutionExplanation) || other.solutionExplanation == solutionExplanation));
}


@override
int get hashCode => Object.hash(runtimeType,questionId,answerText,selectedOptionIndex,isCorrect,gradedByAi,solutionExplanation);

@override
String toString() {
  return 'SubmissionAnswer(questionId: $questionId, answerText: $answerText, selectedOptionIndex: $selectedOptionIndex, isCorrect: $isCorrect, gradedByAi: $gradedByAi, solutionExplanation: $solutionExplanation)';
}


}

/// @nodoc
abstract mixin class $SubmissionAnswerCopyWith<$Res>  {
  factory $SubmissionAnswerCopyWith(SubmissionAnswer value, $Res Function(SubmissionAnswer) _then) = _$SubmissionAnswerCopyWithImpl;
@useResult
$Res call({
 String questionId, String? answerText, int? selectedOptionIndex, bool? isCorrect, bool gradedByAi, String? solutionExplanation
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
@pragma('vm:prefer-inline') @override $Res call({Object? questionId = null,Object? answerText = freezed,Object? selectedOptionIndex = freezed,Object? isCorrect = freezed,Object? gradedByAi = null,Object? solutionExplanation = freezed,}) {
  return _then(_self.copyWith(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,answerText: freezed == answerText ? _self.answerText : answerText // ignore: cast_nullable_to_non_nullable
as String?,selectedOptionIndex: freezed == selectedOptionIndex ? _self.selectedOptionIndex : selectedOptionIndex // ignore: cast_nullable_to_non_nullable
as int?,isCorrect: freezed == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool?,gradedByAi: null == gradedByAi ? _self.gradedByAi : gradedByAi // ignore: cast_nullable_to_non_nullable
as bool,solutionExplanation: freezed == solutionExplanation ? _self.solutionExplanation : solutionExplanation // ignore: cast_nullable_to_non_nullable
as String?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String questionId,  String? answerText,  int? selectedOptionIndex,  bool? isCorrect,  bool gradedByAi,  String? solutionExplanation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubmissionAnswer() when $default != null:
return $default(_that.questionId,_that.answerText,_that.selectedOptionIndex,_that.isCorrect,_that.gradedByAi,_that.solutionExplanation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String questionId,  String? answerText,  int? selectedOptionIndex,  bool? isCorrect,  bool gradedByAi,  String? solutionExplanation)  $default,) {final _that = this;
switch (_that) {
case _SubmissionAnswer():
return $default(_that.questionId,_that.answerText,_that.selectedOptionIndex,_that.isCorrect,_that.gradedByAi,_that.solutionExplanation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String questionId,  String? answerText,  int? selectedOptionIndex,  bool? isCorrect,  bool gradedByAi,  String? solutionExplanation)?  $default,) {final _that = this;
switch (_that) {
case _SubmissionAnswer() when $default != null:
return $default(_that.questionId,_that.answerText,_that.selectedOptionIndex,_that.isCorrect,_that.gradedByAi,_that.solutionExplanation);case _:
  return null;

}
}

}

/// @nodoc


class _SubmissionAnswer implements SubmissionAnswer {
  const _SubmissionAnswer({required this.questionId, this.answerText, this.selectedOptionIndex, this.isCorrect, this.gradedByAi = false, this.solutionExplanation});
  

@override final  String questionId;
@override final  String? answerText;
@override final  int? selectedOptionIndex;
@override final  bool? isCorrect;
@override@JsonKey() final  bool gradedByAi;
@override final  String? solutionExplanation;

/// Create a copy of SubmissionAnswer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmissionAnswerCopyWith<_SubmissionAnswer> get copyWith => __$SubmissionAnswerCopyWithImpl<_SubmissionAnswer>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubmissionAnswer&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.answerText, answerText) || other.answerText == answerText)&&(identical(other.selectedOptionIndex, selectedOptionIndex) || other.selectedOptionIndex == selectedOptionIndex)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.gradedByAi, gradedByAi) || other.gradedByAi == gradedByAi)&&(identical(other.solutionExplanation, solutionExplanation) || other.solutionExplanation == solutionExplanation));
}


@override
int get hashCode => Object.hash(runtimeType,questionId,answerText,selectedOptionIndex,isCorrect,gradedByAi,solutionExplanation);

@override
String toString() {
  return 'SubmissionAnswer(questionId: $questionId, answerText: $answerText, selectedOptionIndex: $selectedOptionIndex, isCorrect: $isCorrect, gradedByAi: $gradedByAi, solutionExplanation: $solutionExplanation)';
}


}

/// @nodoc
abstract mixin class _$SubmissionAnswerCopyWith<$Res> implements $SubmissionAnswerCopyWith<$Res> {
  factory _$SubmissionAnswerCopyWith(_SubmissionAnswer value, $Res Function(_SubmissionAnswer) _then) = __$SubmissionAnswerCopyWithImpl;
@override @useResult
$Res call({
 String questionId, String? answerText, int? selectedOptionIndex, bool? isCorrect, bool gradedByAi, String? solutionExplanation
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
@override @pragma('vm:prefer-inline') $Res call({Object? questionId = null,Object? answerText = freezed,Object? selectedOptionIndex = freezed,Object? isCorrect = freezed,Object? gradedByAi = null,Object? solutionExplanation = freezed,}) {
  return _then(_SubmissionAnswer(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,answerText: freezed == answerText ? _self.answerText : answerText // ignore: cast_nullable_to_non_nullable
as String?,selectedOptionIndex: freezed == selectedOptionIndex ? _self.selectedOptionIndex : selectedOptionIndex // ignore: cast_nullable_to_non_nullable
as int?,isCorrect: freezed == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool?,gradedByAi: null == gradedByAi ? _self.gradedByAi : gradedByAi // ignore: cast_nullable_to_non_nullable
as bool,solutionExplanation: freezed == solutionExplanation ? _self.solutionExplanation : solutionExplanation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
