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

 String get questionId; String? get answerText; int? get selectedOptionIndex; bool? get isCorrect; bool get gradedByAi; String? get solutionExplanation;
/// Create a copy of SubmissionAnswerDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubmissionAnswerDtoCopyWith<SubmissionAnswerDto> get copyWith => _$SubmissionAnswerDtoCopyWithImpl<SubmissionAnswerDto>(this as SubmissionAnswerDto, _$identity);

  /// Serializes this SubmissionAnswerDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmissionAnswerDto&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.answerText, answerText) || other.answerText == answerText)&&(identical(other.selectedOptionIndex, selectedOptionIndex) || other.selectedOptionIndex == selectedOptionIndex)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.gradedByAi, gradedByAi) || other.gradedByAi == gradedByAi)&&(identical(other.solutionExplanation, solutionExplanation) || other.solutionExplanation == solutionExplanation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,answerText,selectedOptionIndex,isCorrect,gradedByAi,solutionExplanation);

@override
String toString() {
  return 'SubmissionAnswerDto(questionId: $questionId, answerText: $answerText, selectedOptionIndex: $selectedOptionIndex, isCorrect: $isCorrect, gradedByAi: $gradedByAi, solutionExplanation: $solutionExplanation)';
}


}

/// @nodoc
abstract mixin class $SubmissionAnswerDtoCopyWith<$Res>  {
  factory $SubmissionAnswerDtoCopyWith(SubmissionAnswerDto value, $Res Function(SubmissionAnswerDto) _then) = _$SubmissionAnswerDtoCopyWithImpl;
@useResult
$Res call({
 String questionId, String? answerText, int? selectedOptionIndex, bool? isCorrect, bool gradedByAi, String? solutionExplanation
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String questionId,  String? answerText,  int? selectedOptionIndex,  bool? isCorrect,  bool gradedByAi,  String? solutionExplanation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubmissionAnswerDto() when $default != null:
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
case _SubmissionAnswerDto():
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
case _SubmissionAnswerDto() when $default != null:
return $default(_that.questionId,_that.answerText,_that.selectedOptionIndex,_that.isCorrect,_that.gradedByAi,_that.solutionExplanation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubmissionAnswerDto extends SubmissionAnswerDto {
  const _SubmissionAnswerDto({required this.questionId, this.answerText, this.selectedOptionIndex, this.isCorrect, this.gradedByAi = false, this.solutionExplanation}): super._();
  factory _SubmissionAnswerDto.fromJson(Map<String, dynamic> json) => _$SubmissionAnswerDtoFromJson(json);

@override final  String questionId;
@override final  String? answerText;
@override final  int? selectedOptionIndex;
@override final  bool? isCorrect;
@override@JsonKey() final  bool gradedByAi;
@override final  String? solutionExplanation;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubmissionAnswerDto&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.answerText, answerText) || other.answerText == answerText)&&(identical(other.selectedOptionIndex, selectedOptionIndex) || other.selectedOptionIndex == selectedOptionIndex)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.gradedByAi, gradedByAi) || other.gradedByAi == gradedByAi)&&(identical(other.solutionExplanation, solutionExplanation) || other.solutionExplanation == solutionExplanation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,questionId,answerText,selectedOptionIndex,isCorrect,gradedByAi,solutionExplanation);

@override
String toString() {
  return 'SubmissionAnswerDto(questionId: $questionId, answerText: $answerText, selectedOptionIndex: $selectedOptionIndex, isCorrect: $isCorrect, gradedByAi: $gradedByAi, solutionExplanation: $solutionExplanation)';
}


}

/// @nodoc
abstract mixin class _$SubmissionAnswerDtoCopyWith<$Res> implements $SubmissionAnswerDtoCopyWith<$Res> {
  factory _$SubmissionAnswerDtoCopyWith(_SubmissionAnswerDto value, $Res Function(_SubmissionAnswerDto) _then) = __$SubmissionAnswerDtoCopyWithImpl;
@override @useResult
$Res call({
 String questionId, String? answerText, int? selectedOptionIndex, bool? isCorrect, bool gradedByAi, String? solutionExplanation
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
@override @pragma('vm:prefer-inline') $Res call({Object? questionId = null,Object? answerText = freezed,Object? selectedOptionIndex = freezed,Object? isCorrect = freezed,Object? gradedByAi = null,Object? solutionExplanation = freezed,}) {
  return _then(_SubmissionAnswerDto(
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
