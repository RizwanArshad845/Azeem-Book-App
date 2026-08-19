// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_attempt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TestAttempt {

 String get id; String get studentId; String get testId; List<SubmissionAnswer> get answers; double get scorePercent; List<String>? get weakChapterIds; List<String>? get strongChapterIds; int? get durationSeconds; bool get isLiveTestAttempt; DateTime get attemptedAt;
/// Create a copy of TestAttempt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TestAttemptCopyWith<TestAttempt> get copyWith => _$TestAttemptCopyWithImpl<TestAttempt>(this as TestAttempt, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TestAttempt&&(identical(other.id, id) || other.id == id)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.testId, testId) || other.testId == testId)&&const DeepCollectionEquality().equals(other.answers, answers)&&(identical(other.scorePercent, scorePercent) || other.scorePercent == scorePercent)&&const DeepCollectionEquality().equals(other.weakChapterIds, weakChapterIds)&&const DeepCollectionEquality().equals(other.strongChapterIds, strongChapterIds)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.isLiveTestAttempt, isLiveTestAttempt) || other.isLiveTestAttempt == isLiveTestAttempt)&&(identical(other.attemptedAt, attemptedAt) || other.attemptedAt == attemptedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,studentId,testId,const DeepCollectionEquality().hash(answers),scorePercent,const DeepCollectionEquality().hash(weakChapterIds),const DeepCollectionEquality().hash(strongChapterIds),durationSeconds,isLiveTestAttempt,attemptedAt);

@override
String toString() {
  return 'TestAttempt(id: $id, studentId: $studentId, testId: $testId, answers: $answers, scorePercent: $scorePercent, weakChapterIds: $weakChapterIds, strongChapterIds: $strongChapterIds, durationSeconds: $durationSeconds, isLiveTestAttempt: $isLiveTestAttempt, attemptedAt: $attemptedAt)';
}


}

/// @nodoc
abstract mixin class $TestAttemptCopyWith<$Res>  {
  factory $TestAttemptCopyWith(TestAttempt value, $Res Function(TestAttempt) _then) = _$TestAttemptCopyWithImpl;
@useResult
$Res call({
 String id, String studentId, String testId, List<SubmissionAnswer> answers, double scorePercent, List<String>? weakChapterIds, List<String>? strongChapterIds, int? durationSeconds, bool isLiveTestAttempt, DateTime attemptedAt
});




}
/// @nodoc
class _$TestAttemptCopyWithImpl<$Res>
    implements $TestAttemptCopyWith<$Res> {
  _$TestAttemptCopyWithImpl(this._self, this._then);

  final TestAttempt _self;
  final $Res Function(TestAttempt) _then;

/// Create a copy of TestAttempt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? studentId = null,Object? testId = null,Object? answers = null,Object? scorePercent = null,Object? weakChapterIds = freezed,Object? strongChapterIds = freezed,Object? durationSeconds = freezed,Object? isLiveTestAttempt = null,Object? attemptedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,testId: null == testId ? _self.testId : testId // ignore: cast_nullable_to_non_nullable
as String,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as List<SubmissionAnswer>,scorePercent: null == scorePercent ? _self.scorePercent : scorePercent // ignore: cast_nullable_to_non_nullable
as double,weakChapterIds: freezed == weakChapterIds ? _self.weakChapterIds : weakChapterIds // ignore: cast_nullable_to_non_nullable
as List<String>?,strongChapterIds: freezed == strongChapterIds ? _self.strongChapterIds : strongChapterIds // ignore: cast_nullable_to_non_nullable
as List<String>?,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,isLiveTestAttempt: null == isLiveTestAttempt ? _self.isLiveTestAttempt : isLiveTestAttempt // ignore: cast_nullable_to_non_nullable
as bool,attemptedAt: null == attemptedAt ? _self.attemptedAt : attemptedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TestAttempt].
extension TestAttemptPatterns on TestAttempt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TestAttempt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TestAttempt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TestAttempt value)  $default,){
final _that = this;
switch (_that) {
case _TestAttempt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TestAttempt value)?  $default,){
final _that = this;
switch (_that) {
case _TestAttempt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String studentId,  String testId,  List<SubmissionAnswer> answers,  double scorePercent,  List<String>? weakChapterIds,  List<String>? strongChapterIds,  int? durationSeconds,  bool isLiveTestAttempt,  DateTime attemptedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TestAttempt() when $default != null:
return $default(_that.id,_that.studentId,_that.testId,_that.answers,_that.scorePercent,_that.weakChapterIds,_that.strongChapterIds,_that.durationSeconds,_that.isLiveTestAttempt,_that.attemptedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String studentId,  String testId,  List<SubmissionAnswer> answers,  double scorePercent,  List<String>? weakChapterIds,  List<String>? strongChapterIds,  int? durationSeconds,  bool isLiveTestAttempt,  DateTime attemptedAt)  $default,) {final _that = this;
switch (_that) {
case _TestAttempt():
return $default(_that.id,_that.studentId,_that.testId,_that.answers,_that.scorePercent,_that.weakChapterIds,_that.strongChapterIds,_that.durationSeconds,_that.isLiveTestAttempt,_that.attemptedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String studentId,  String testId,  List<SubmissionAnswer> answers,  double scorePercent,  List<String>? weakChapterIds,  List<String>? strongChapterIds,  int? durationSeconds,  bool isLiveTestAttempt,  DateTime attemptedAt)?  $default,) {final _that = this;
switch (_that) {
case _TestAttempt() when $default != null:
return $default(_that.id,_that.studentId,_that.testId,_that.answers,_that.scorePercent,_that.weakChapterIds,_that.strongChapterIds,_that.durationSeconds,_that.isLiveTestAttempt,_that.attemptedAt);case _:
  return null;

}
}

}

/// @nodoc


class _TestAttempt implements TestAttempt {
  const _TestAttempt({required this.id, required this.studentId, required this.testId, required this.answers, required this.scorePercent, this.weakChapterIds, this.strongChapterIds, this.durationSeconds, this.isLiveTestAttempt = false, required this.attemptedAt});
  

@override final  String id;
@override final  String studentId;
@override final  String testId;
@override final  List<SubmissionAnswer> answers;
@override final  double scorePercent;
@override final  List<String>? weakChapterIds;
@override final  List<String>? strongChapterIds;
@override final  int? durationSeconds;
@override@JsonKey() final  bool isLiveTestAttempt;
@override final  DateTime attemptedAt;

/// Create a copy of TestAttempt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TestAttemptCopyWith<_TestAttempt> get copyWith => __$TestAttemptCopyWithImpl<_TestAttempt>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TestAttempt&&(identical(other.id, id) || other.id == id)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.testId, testId) || other.testId == testId)&&const DeepCollectionEquality().equals(other.answers, answers)&&(identical(other.scorePercent, scorePercent) || other.scorePercent == scorePercent)&&const DeepCollectionEquality().equals(other.weakChapterIds, weakChapterIds)&&const DeepCollectionEquality().equals(other.strongChapterIds, strongChapterIds)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.isLiveTestAttempt, isLiveTestAttempt) || other.isLiveTestAttempt == isLiveTestAttempt)&&(identical(other.attemptedAt, attemptedAt) || other.attemptedAt == attemptedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,studentId,testId,const DeepCollectionEquality().hash(answers),scorePercent,const DeepCollectionEquality().hash(weakChapterIds),const DeepCollectionEquality().hash(strongChapterIds),durationSeconds,isLiveTestAttempt,attemptedAt);

@override
String toString() {
  return 'TestAttempt(id: $id, studentId: $studentId, testId: $testId, answers: $answers, scorePercent: $scorePercent, weakChapterIds: $weakChapterIds, strongChapterIds: $strongChapterIds, durationSeconds: $durationSeconds, isLiveTestAttempt: $isLiveTestAttempt, attemptedAt: $attemptedAt)';
}


}

/// @nodoc
abstract mixin class _$TestAttemptCopyWith<$Res> implements $TestAttemptCopyWith<$Res> {
  factory _$TestAttemptCopyWith(_TestAttempt value, $Res Function(_TestAttempt) _then) = __$TestAttemptCopyWithImpl;
@override @useResult
$Res call({
 String id, String studentId, String testId, List<SubmissionAnswer> answers, double scorePercent, List<String>? weakChapterIds, List<String>? strongChapterIds, int? durationSeconds, bool isLiveTestAttempt, DateTime attemptedAt
});




}
/// @nodoc
class __$TestAttemptCopyWithImpl<$Res>
    implements _$TestAttemptCopyWith<$Res> {
  __$TestAttemptCopyWithImpl(this._self, this._then);

  final _TestAttempt _self;
  final $Res Function(_TestAttempt) _then;

/// Create a copy of TestAttempt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? studentId = null,Object? testId = null,Object? answers = null,Object? scorePercent = null,Object? weakChapterIds = freezed,Object? strongChapterIds = freezed,Object? durationSeconds = freezed,Object? isLiveTestAttempt = null,Object? attemptedAt = null,}) {
  return _then(_TestAttempt(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,testId: null == testId ? _self.testId : testId // ignore: cast_nullable_to_non_nullable
as String,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as List<SubmissionAnswer>,scorePercent: null == scorePercent ? _self.scorePercent : scorePercent // ignore: cast_nullable_to_non_nullable
as double,weakChapterIds: freezed == weakChapterIds ? _self.weakChapterIds : weakChapterIds // ignore: cast_nullable_to_non_nullable
as List<String>?,strongChapterIds: freezed == strongChapterIds ? _self.strongChapterIds : strongChapterIds // ignore: cast_nullable_to_non_nullable
as List<String>?,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,isLiveTestAttempt: null == isLiveTestAttempt ? _self.isLiveTestAttempt : isLiveTestAttempt // ignore: cast_nullable_to_non_nullable
as bool,attemptedAt: null == attemptedAt ? _self.attemptedAt : attemptedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
