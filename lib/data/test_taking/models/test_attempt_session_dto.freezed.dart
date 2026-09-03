// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_attempt_session_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TestAttemptSessionDto {

 String get attemptId; DateTime get deadlineAt; List<AttemptQuestionDto> get questions;
/// Create a copy of TestAttemptSessionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TestAttemptSessionDtoCopyWith<TestAttemptSessionDto> get copyWith => _$TestAttemptSessionDtoCopyWithImpl<TestAttemptSessionDto>(this as TestAttemptSessionDto, _$identity);

  /// Serializes this TestAttemptSessionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TestAttemptSessionDto&&(identical(other.attemptId, attemptId) || other.attemptId == attemptId)&&(identical(other.deadlineAt, deadlineAt) || other.deadlineAt == deadlineAt)&&const DeepCollectionEquality().equals(other.questions, questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,attemptId,deadlineAt,const DeepCollectionEquality().hash(questions));

@override
String toString() {
  return 'TestAttemptSessionDto(attemptId: $attemptId, deadlineAt: $deadlineAt, questions: $questions)';
}


}

/// @nodoc
abstract mixin class $TestAttemptSessionDtoCopyWith<$Res>  {
  factory $TestAttemptSessionDtoCopyWith(TestAttemptSessionDto value, $Res Function(TestAttemptSessionDto) _then) = _$TestAttemptSessionDtoCopyWithImpl;
@useResult
$Res call({
 String attemptId, DateTime deadlineAt, List<AttemptQuestionDto> questions
});




}
/// @nodoc
class _$TestAttemptSessionDtoCopyWithImpl<$Res>
    implements $TestAttemptSessionDtoCopyWith<$Res> {
  _$TestAttemptSessionDtoCopyWithImpl(this._self, this._then);

  final TestAttemptSessionDto _self;
  final $Res Function(TestAttemptSessionDto) _then;

/// Create a copy of TestAttemptSessionDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? attemptId = null,Object? deadlineAt = null,Object? questions = null,}) {
  return _then(_self.copyWith(
attemptId: null == attemptId ? _self.attemptId : attemptId // ignore: cast_nullable_to_non_nullable
as String,deadlineAt: null == deadlineAt ? _self.deadlineAt : deadlineAt // ignore: cast_nullable_to_non_nullable
as DateTime,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<AttemptQuestionDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [TestAttemptSessionDto].
extension TestAttemptSessionDtoPatterns on TestAttemptSessionDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TestAttemptSessionDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TestAttemptSessionDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TestAttemptSessionDto value)  $default,){
final _that = this;
switch (_that) {
case _TestAttemptSessionDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TestAttemptSessionDto value)?  $default,){
final _that = this;
switch (_that) {
case _TestAttemptSessionDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String attemptId,  DateTime deadlineAt,  List<AttemptQuestionDto> questions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TestAttemptSessionDto() when $default != null:
return $default(_that.attemptId,_that.deadlineAt,_that.questions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String attemptId,  DateTime deadlineAt,  List<AttemptQuestionDto> questions)  $default,) {final _that = this;
switch (_that) {
case _TestAttemptSessionDto():
return $default(_that.attemptId,_that.deadlineAt,_that.questions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String attemptId,  DateTime deadlineAt,  List<AttemptQuestionDto> questions)?  $default,) {final _that = this;
switch (_that) {
case _TestAttemptSessionDto() when $default != null:
return $default(_that.attemptId,_that.deadlineAt,_that.questions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TestAttemptSessionDto extends TestAttemptSessionDto {
  const _TestAttemptSessionDto({required this.attemptId, required this.deadlineAt, required this.questions}): super._();
  factory _TestAttemptSessionDto.fromJson(Map<String, dynamic> json) => _$TestAttemptSessionDtoFromJson(json);

@override final  String attemptId;
@override final  DateTime deadlineAt;
@override final  List<AttemptQuestionDto> questions;

/// Create a copy of TestAttemptSessionDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TestAttemptSessionDtoCopyWith<_TestAttemptSessionDto> get copyWith => __$TestAttemptSessionDtoCopyWithImpl<_TestAttemptSessionDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TestAttemptSessionDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TestAttemptSessionDto&&(identical(other.attemptId, attemptId) || other.attemptId == attemptId)&&(identical(other.deadlineAt, deadlineAt) || other.deadlineAt == deadlineAt)&&const DeepCollectionEquality().equals(other.questions, questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,attemptId,deadlineAt,const DeepCollectionEquality().hash(questions));

@override
String toString() {
  return 'TestAttemptSessionDto(attemptId: $attemptId, deadlineAt: $deadlineAt, questions: $questions)';
}


}

/// @nodoc
abstract mixin class _$TestAttemptSessionDtoCopyWith<$Res> implements $TestAttemptSessionDtoCopyWith<$Res> {
  factory _$TestAttemptSessionDtoCopyWith(_TestAttemptSessionDto value, $Res Function(_TestAttemptSessionDto) _then) = __$TestAttemptSessionDtoCopyWithImpl;
@override @useResult
$Res call({
 String attemptId, DateTime deadlineAt, List<AttemptQuestionDto> questions
});




}
/// @nodoc
class __$TestAttemptSessionDtoCopyWithImpl<$Res>
    implements _$TestAttemptSessionDtoCopyWith<$Res> {
  __$TestAttemptSessionDtoCopyWithImpl(this._self, this._then);

  final _TestAttemptSessionDto _self;
  final $Res Function(_TestAttemptSessionDto) _then;

/// Create a copy of TestAttemptSessionDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? attemptId = null,Object? deadlineAt = null,Object? questions = null,}) {
  return _then(_TestAttemptSessionDto(
attemptId: null == attemptId ? _self.attemptId : attemptId // ignore: cast_nullable_to_non_nullable
as String,deadlineAt: null == deadlineAt ? _self.deadlineAt : deadlineAt // ignore: cast_nullable_to_non_nullable
as DateTime,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<AttemptQuestionDto>,
  ));
}


}

// dart format on
