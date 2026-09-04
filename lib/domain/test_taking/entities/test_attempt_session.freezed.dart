// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_attempt_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TestAttemptSession {

 String get attemptId;// Nullable: `FRONTEND_INTEGRATION.md` §6.6 types this `iso8601|null`.
 DateTime? get deadlineAt; List<AttemptQuestion> get questions;
/// Create a copy of TestAttemptSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TestAttemptSessionCopyWith<TestAttemptSession> get copyWith => _$TestAttemptSessionCopyWithImpl<TestAttemptSession>(this as TestAttemptSession, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TestAttemptSession&&(identical(other.attemptId, attemptId) || other.attemptId == attemptId)&&(identical(other.deadlineAt, deadlineAt) || other.deadlineAt == deadlineAt)&&const DeepCollectionEquality().equals(other.questions, questions));
}


@override
int get hashCode => Object.hash(runtimeType,attemptId,deadlineAt,const DeepCollectionEquality().hash(questions));

@override
String toString() {
  return 'TestAttemptSession(attemptId: $attemptId, deadlineAt: $deadlineAt, questions: $questions)';
}


}

/// @nodoc
abstract mixin class $TestAttemptSessionCopyWith<$Res>  {
  factory $TestAttemptSessionCopyWith(TestAttemptSession value, $Res Function(TestAttemptSession) _then) = _$TestAttemptSessionCopyWithImpl;
@useResult
$Res call({
 String attemptId, DateTime? deadlineAt, List<AttemptQuestion> questions
});




}
/// @nodoc
class _$TestAttemptSessionCopyWithImpl<$Res>
    implements $TestAttemptSessionCopyWith<$Res> {
  _$TestAttemptSessionCopyWithImpl(this._self, this._then);

  final TestAttemptSession _self;
  final $Res Function(TestAttemptSession) _then;

/// Create a copy of TestAttemptSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? attemptId = null,Object? deadlineAt = freezed,Object? questions = null,}) {
  return _then(_self.copyWith(
attemptId: null == attemptId ? _self.attemptId : attemptId // ignore: cast_nullable_to_non_nullable
as String,deadlineAt: freezed == deadlineAt ? _self.deadlineAt : deadlineAt // ignore: cast_nullable_to_non_nullable
as DateTime?,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<AttemptQuestion>,
  ));
}

}


/// Adds pattern-matching-related methods to [TestAttemptSession].
extension TestAttemptSessionPatterns on TestAttemptSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TestAttemptSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TestAttemptSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TestAttemptSession value)  $default,){
final _that = this;
switch (_that) {
case _TestAttemptSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TestAttemptSession value)?  $default,){
final _that = this;
switch (_that) {
case _TestAttemptSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String attemptId,  DateTime? deadlineAt,  List<AttemptQuestion> questions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TestAttemptSession() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String attemptId,  DateTime? deadlineAt,  List<AttemptQuestion> questions)  $default,) {final _that = this;
switch (_that) {
case _TestAttemptSession():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String attemptId,  DateTime? deadlineAt,  List<AttemptQuestion> questions)?  $default,) {final _that = this;
switch (_that) {
case _TestAttemptSession() when $default != null:
return $default(_that.attemptId,_that.deadlineAt,_that.questions);case _:
  return null;

}
}

}

/// @nodoc


class _TestAttemptSession implements TestAttemptSession {
  const _TestAttemptSession({required this.attemptId, this.deadlineAt, required this.questions});
  

@override final  String attemptId;
// Nullable: `FRONTEND_INTEGRATION.md` §6.6 types this `iso8601|null`.
@override final  DateTime? deadlineAt;
@override final  List<AttemptQuestion> questions;

/// Create a copy of TestAttemptSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TestAttemptSessionCopyWith<_TestAttemptSession> get copyWith => __$TestAttemptSessionCopyWithImpl<_TestAttemptSession>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TestAttemptSession&&(identical(other.attemptId, attemptId) || other.attemptId == attemptId)&&(identical(other.deadlineAt, deadlineAt) || other.deadlineAt == deadlineAt)&&const DeepCollectionEquality().equals(other.questions, questions));
}


@override
int get hashCode => Object.hash(runtimeType,attemptId,deadlineAt,const DeepCollectionEquality().hash(questions));

@override
String toString() {
  return 'TestAttemptSession(attemptId: $attemptId, deadlineAt: $deadlineAt, questions: $questions)';
}


}

/// @nodoc
abstract mixin class _$TestAttemptSessionCopyWith<$Res> implements $TestAttemptSessionCopyWith<$Res> {
  factory _$TestAttemptSessionCopyWith(_TestAttemptSession value, $Res Function(_TestAttemptSession) _then) = __$TestAttemptSessionCopyWithImpl;
@override @useResult
$Res call({
 String attemptId, DateTime? deadlineAt, List<AttemptQuestion> questions
});




}
/// @nodoc
class __$TestAttemptSessionCopyWithImpl<$Res>
    implements _$TestAttemptSessionCopyWith<$Res> {
  __$TestAttemptSessionCopyWithImpl(this._self, this._then);

  final _TestAttemptSession _self;
  final $Res Function(_TestAttemptSession) _then;

/// Create a copy of TestAttemptSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? attemptId = null,Object? deadlineAt = freezed,Object? questions = null,}) {
  return _then(_TestAttemptSession(
attemptId: null == attemptId ? _self.attemptId : attemptId // ignore: cast_nullable_to_non_nullable
as String,deadlineAt: freezed == deadlineAt ? _self.deadlineAt : deadlineAt // ignore: cast_nullable_to_non_nullable
as DateTime?,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<AttemptQuestion>,
  ));
}


}

// dart format on
