// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TestSession {

 String get sessionId; List<TestQuestion> get questions; Map<String, TestAnswer> get answers; int get currentIndex; TestSessionStatus get status; bool get consentAcknowledged; DateTime? get startedAt;
/// Create a copy of TestSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TestSessionCopyWith<TestSession> get copyWith => _$TestSessionCopyWithImpl<TestSession>(this as TestSession, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TestSession&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&const DeepCollectionEquality().equals(other.questions, questions)&&const DeepCollectionEquality().equals(other.answers, answers)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.status, status) || other.status == status)&&(identical(other.consentAcknowledged, consentAcknowledged) || other.consentAcknowledged == consentAcknowledged)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,const DeepCollectionEquality().hash(questions),const DeepCollectionEquality().hash(answers),currentIndex,status,consentAcknowledged,startedAt);

@override
String toString() {
  return 'TestSession(sessionId: $sessionId, questions: $questions, answers: $answers, currentIndex: $currentIndex, status: $status, consentAcknowledged: $consentAcknowledged, startedAt: $startedAt)';
}


}

/// @nodoc
abstract mixin class $TestSessionCopyWith<$Res>  {
  factory $TestSessionCopyWith(TestSession value, $Res Function(TestSession) _then) = _$TestSessionCopyWithImpl;
@useResult
$Res call({
 String sessionId, List<TestQuestion> questions, Map<String, TestAnswer> answers, int currentIndex, TestSessionStatus status, bool consentAcknowledged, DateTime? startedAt
});




}
/// @nodoc
class _$TestSessionCopyWithImpl<$Res>
    implements $TestSessionCopyWith<$Res> {
  _$TestSessionCopyWithImpl(this._self, this._then);

  final TestSession _self;
  final $Res Function(TestSession) _then;

/// Create a copy of TestSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? questions = null,Object? answers = null,Object? currentIndex = null,Object? status = null,Object? consentAcknowledged = null,Object? startedAt = freezed,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<TestQuestion>,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as Map<String, TestAnswer>,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TestSessionStatus,consentAcknowledged: null == consentAcknowledged ? _self.consentAcknowledged : consentAcknowledged // ignore: cast_nullable_to_non_nullable
as bool,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TestSession].
extension TestSessionPatterns on TestSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TestSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TestSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TestSession value)  $default,){
final _that = this;
switch (_that) {
case _TestSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TestSession value)?  $default,){
final _that = this;
switch (_that) {
case _TestSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId,  List<TestQuestion> questions,  Map<String, TestAnswer> answers,  int currentIndex,  TestSessionStatus status,  bool consentAcknowledged,  DateTime? startedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TestSession() when $default != null:
return $default(_that.sessionId,_that.questions,_that.answers,_that.currentIndex,_that.status,_that.consentAcknowledged,_that.startedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId,  List<TestQuestion> questions,  Map<String, TestAnswer> answers,  int currentIndex,  TestSessionStatus status,  bool consentAcknowledged,  DateTime? startedAt)  $default,) {final _that = this;
switch (_that) {
case _TestSession():
return $default(_that.sessionId,_that.questions,_that.answers,_that.currentIndex,_that.status,_that.consentAcknowledged,_that.startedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId,  List<TestQuestion> questions,  Map<String, TestAnswer> answers,  int currentIndex,  TestSessionStatus status,  bool consentAcknowledged,  DateTime? startedAt)?  $default,) {final _that = this;
switch (_that) {
case _TestSession() when $default != null:
return $default(_that.sessionId,_that.questions,_that.answers,_that.currentIndex,_that.status,_that.consentAcknowledged,_that.startedAt);case _:
  return null;

}
}

}

/// @nodoc


class _TestSession implements TestSession {
  const _TestSession({required this.sessionId, required this.questions, required this.answers, required this.currentIndex, required this.status, required this.consentAcknowledged, this.startedAt});
  

@override final  String sessionId;
@override final  List<TestQuestion> questions;
@override final  Map<String, TestAnswer> answers;
@override final  int currentIndex;
@override final  TestSessionStatus status;
@override final  bool consentAcknowledged;
@override final  DateTime? startedAt;

/// Create a copy of TestSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TestSessionCopyWith<_TestSession> get copyWith => __$TestSessionCopyWithImpl<_TestSession>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TestSession&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&const DeepCollectionEquality().equals(other.questions, questions)&&const DeepCollectionEquality().equals(other.answers, answers)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.status, status) || other.status == status)&&(identical(other.consentAcknowledged, consentAcknowledged) || other.consentAcknowledged == consentAcknowledged)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,const DeepCollectionEquality().hash(questions),const DeepCollectionEquality().hash(answers),currentIndex,status,consentAcknowledged,startedAt);

@override
String toString() {
  return 'TestSession(sessionId: $sessionId, questions: $questions, answers: $answers, currentIndex: $currentIndex, status: $status, consentAcknowledged: $consentAcknowledged, startedAt: $startedAt)';
}


}

/// @nodoc
abstract mixin class _$TestSessionCopyWith<$Res> implements $TestSessionCopyWith<$Res> {
  factory _$TestSessionCopyWith(_TestSession value, $Res Function(_TestSession) _then) = __$TestSessionCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, List<TestQuestion> questions, Map<String, TestAnswer> answers, int currentIndex, TestSessionStatus status, bool consentAcknowledged, DateTime? startedAt
});




}
/// @nodoc
class __$TestSessionCopyWithImpl<$Res>
    implements _$TestSessionCopyWith<$Res> {
  __$TestSessionCopyWithImpl(this._self, this._then);

  final _TestSession _self;
  final $Res Function(_TestSession) _then;

/// Create a copy of TestSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? questions = null,Object? answers = null,Object? currentIndex = null,Object? status = null,Object? consentAcknowledged = null,Object? startedAt = freezed,}) {
  return _then(_TestSession(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<TestQuestion>,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as Map<String, TestAnswer>,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TestSessionStatus,consentAcknowledged: null == consentAcknowledged ? _self.consentAcknowledged : consentAcknowledged // ignore: cast_nullable_to_non_nullable
as bool,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
