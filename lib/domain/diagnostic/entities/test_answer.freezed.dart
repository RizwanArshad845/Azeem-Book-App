// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_answer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TestAnswer {

 String get questionId; int get chapter; bool get isMcq; int? get selectedIndex; String? get textAnswer; double get scoreFraction;
/// Create a copy of TestAnswer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TestAnswerCopyWith<TestAnswer> get copyWith => _$TestAnswerCopyWithImpl<TestAnswer>(this as TestAnswer, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TestAnswer&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.chapter, chapter) || other.chapter == chapter)&&(identical(other.isMcq, isMcq) || other.isMcq == isMcq)&&(identical(other.selectedIndex, selectedIndex) || other.selectedIndex == selectedIndex)&&(identical(other.textAnswer, textAnswer) || other.textAnswer == textAnswer)&&(identical(other.scoreFraction, scoreFraction) || other.scoreFraction == scoreFraction));
}


@override
int get hashCode => Object.hash(runtimeType,questionId,chapter,isMcq,selectedIndex,textAnswer,scoreFraction);

@override
String toString() {
  return 'TestAnswer(questionId: $questionId, chapter: $chapter, isMcq: $isMcq, selectedIndex: $selectedIndex, textAnswer: $textAnswer, scoreFraction: $scoreFraction)';
}


}

/// @nodoc
abstract mixin class $TestAnswerCopyWith<$Res>  {
  factory $TestAnswerCopyWith(TestAnswer value, $Res Function(TestAnswer) _then) = _$TestAnswerCopyWithImpl;
@useResult
$Res call({
 String questionId, int chapter, bool isMcq, int? selectedIndex, String? textAnswer, double scoreFraction
});




}
/// @nodoc
class _$TestAnswerCopyWithImpl<$Res>
    implements $TestAnswerCopyWith<$Res> {
  _$TestAnswerCopyWithImpl(this._self, this._then);

  final TestAnswer _self;
  final $Res Function(TestAnswer) _then;

/// Create a copy of TestAnswer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questionId = null,Object? chapter = null,Object? isMcq = null,Object? selectedIndex = freezed,Object? textAnswer = freezed,Object? scoreFraction = null,}) {
  return _then(_self.copyWith(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,chapter: null == chapter ? _self.chapter : chapter // ignore: cast_nullable_to_non_nullable
as int,isMcq: null == isMcq ? _self.isMcq : isMcq // ignore: cast_nullable_to_non_nullable
as bool,selectedIndex: freezed == selectedIndex ? _self.selectedIndex : selectedIndex // ignore: cast_nullable_to_non_nullable
as int?,textAnswer: freezed == textAnswer ? _self.textAnswer : textAnswer // ignore: cast_nullable_to_non_nullable
as String?,scoreFraction: null == scoreFraction ? _self.scoreFraction : scoreFraction // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [TestAnswer].
extension TestAnswerPatterns on TestAnswer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TestAnswer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TestAnswer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TestAnswer value)  $default,){
final _that = this;
switch (_that) {
case _TestAnswer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TestAnswer value)?  $default,){
final _that = this;
switch (_that) {
case _TestAnswer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String questionId,  int chapter,  bool isMcq,  int? selectedIndex,  String? textAnswer,  double scoreFraction)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TestAnswer() when $default != null:
return $default(_that.questionId,_that.chapter,_that.isMcq,_that.selectedIndex,_that.textAnswer,_that.scoreFraction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String questionId,  int chapter,  bool isMcq,  int? selectedIndex,  String? textAnswer,  double scoreFraction)  $default,) {final _that = this;
switch (_that) {
case _TestAnswer():
return $default(_that.questionId,_that.chapter,_that.isMcq,_that.selectedIndex,_that.textAnswer,_that.scoreFraction);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String questionId,  int chapter,  bool isMcq,  int? selectedIndex,  String? textAnswer,  double scoreFraction)?  $default,) {final _that = this;
switch (_that) {
case _TestAnswer() when $default != null:
return $default(_that.questionId,_that.chapter,_that.isMcq,_that.selectedIndex,_that.textAnswer,_that.scoreFraction);case _:
  return null;

}
}

}

/// @nodoc


class _TestAnswer implements TestAnswer {
  const _TestAnswer({required this.questionId, required this.chapter, required this.isMcq, this.selectedIndex, this.textAnswer, required this.scoreFraction});
  

@override final  String questionId;
@override final  int chapter;
@override final  bool isMcq;
@override final  int? selectedIndex;
@override final  String? textAnswer;
@override final  double scoreFraction;

/// Create a copy of TestAnswer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TestAnswerCopyWith<_TestAnswer> get copyWith => __$TestAnswerCopyWithImpl<_TestAnswer>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TestAnswer&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.chapter, chapter) || other.chapter == chapter)&&(identical(other.isMcq, isMcq) || other.isMcq == isMcq)&&(identical(other.selectedIndex, selectedIndex) || other.selectedIndex == selectedIndex)&&(identical(other.textAnswer, textAnswer) || other.textAnswer == textAnswer)&&(identical(other.scoreFraction, scoreFraction) || other.scoreFraction == scoreFraction));
}


@override
int get hashCode => Object.hash(runtimeType,questionId,chapter,isMcq,selectedIndex,textAnswer,scoreFraction);

@override
String toString() {
  return 'TestAnswer(questionId: $questionId, chapter: $chapter, isMcq: $isMcq, selectedIndex: $selectedIndex, textAnswer: $textAnswer, scoreFraction: $scoreFraction)';
}


}

/// @nodoc
abstract mixin class _$TestAnswerCopyWith<$Res> implements $TestAnswerCopyWith<$Res> {
  factory _$TestAnswerCopyWith(_TestAnswer value, $Res Function(_TestAnswer) _then) = __$TestAnswerCopyWithImpl;
@override @useResult
$Res call({
 String questionId, int chapter, bool isMcq, int? selectedIndex, String? textAnswer, double scoreFraction
});




}
/// @nodoc
class __$TestAnswerCopyWithImpl<$Res>
    implements _$TestAnswerCopyWith<$Res> {
  __$TestAnswerCopyWithImpl(this._self, this._then);

  final _TestAnswer _self;
  final $Res Function(_TestAnswer) _then;

/// Create a copy of TestAnswer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questionId = null,Object? chapter = null,Object? isMcq = null,Object? selectedIndex = freezed,Object? textAnswer = freezed,Object? scoreFraction = null,}) {
  return _then(_TestAnswer(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,chapter: null == chapter ? _self.chapter : chapter // ignore: cast_nullable_to_non_nullable
as int,isMcq: null == isMcq ? _self.isMcq : isMcq // ignore: cast_nullable_to_non_nullable
as bool,selectedIndex: freezed == selectedIndex ? _self.selectedIndex : selectedIndex // ignore: cast_nullable_to_non_nullable
as int?,textAnswer: freezed == textAnswer ? _self.textAnswer : textAnswer // ignore: cast_nullable_to_non_nullable
as String?,scoreFraction: null == scoreFraction ? _self.scoreFraction : scoreFraction // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
