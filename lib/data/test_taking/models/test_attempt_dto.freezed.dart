// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_attempt_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TestAttemptDto {

 String get id; String get studentId; String get testId; TestAttemptStatus get status; List<SubmissionAnswerDto> get answers; double get scorePercent; int? get totalMarksAwarded; int? get totalPossibleMarks; List<String>? get weakChapterIds; List<String>? get strongChapterIds; int? get durationSeconds; bool get isLiveTestAttempt; DateTime get attemptedAt;
/// Create a copy of TestAttemptDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TestAttemptDtoCopyWith<TestAttemptDto> get copyWith => _$TestAttemptDtoCopyWithImpl<TestAttemptDto>(this as TestAttemptDto, _$identity);

  /// Serializes this TestAttemptDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TestAttemptDto&&(identical(other.id, id) || other.id == id)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.testId, testId) || other.testId == testId)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.answers, answers)&&(identical(other.scorePercent, scorePercent) || other.scorePercent == scorePercent)&&(identical(other.totalMarksAwarded, totalMarksAwarded) || other.totalMarksAwarded == totalMarksAwarded)&&(identical(other.totalPossibleMarks, totalPossibleMarks) || other.totalPossibleMarks == totalPossibleMarks)&&const DeepCollectionEquality().equals(other.weakChapterIds, weakChapterIds)&&const DeepCollectionEquality().equals(other.strongChapterIds, strongChapterIds)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.isLiveTestAttempt, isLiveTestAttempt) || other.isLiveTestAttempt == isLiveTestAttempt)&&(identical(other.attemptedAt, attemptedAt) || other.attemptedAt == attemptedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,studentId,testId,status,const DeepCollectionEquality().hash(answers),scorePercent,totalMarksAwarded,totalPossibleMarks,const DeepCollectionEquality().hash(weakChapterIds),const DeepCollectionEquality().hash(strongChapterIds),durationSeconds,isLiveTestAttempt,attemptedAt);

@override
String toString() {
  return 'TestAttemptDto(id: $id, studentId: $studentId, testId: $testId, status: $status, answers: $answers, scorePercent: $scorePercent, totalMarksAwarded: $totalMarksAwarded, totalPossibleMarks: $totalPossibleMarks, weakChapterIds: $weakChapterIds, strongChapterIds: $strongChapterIds, durationSeconds: $durationSeconds, isLiveTestAttempt: $isLiveTestAttempt, attemptedAt: $attemptedAt)';
}


}

/// @nodoc
abstract mixin class $TestAttemptDtoCopyWith<$Res>  {
  factory $TestAttemptDtoCopyWith(TestAttemptDto value, $Res Function(TestAttemptDto) _then) = _$TestAttemptDtoCopyWithImpl;
@useResult
$Res call({
 String id, String studentId, String testId, TestAttemptStatus status, List<SubmissionAnswerDto> answers, double scorePercent, int? totalMarksAwarded, int? totalPossibleMarks, List<String>? weakChapterIds, List<String>? strongChapterIds, int? durationSeconds, bool isLiveTestAttempt, DateTime attemptedAt
});




}
/// @nodoc
class _$TestAttemptDtoCopyWithImpl<$Res>
    implements $TestAttemptDtoCopyWith<$Res> {
  _$TestAttemptDtoCopyWithImpl(this._self, this._then);

  final TestAttemptDto _self;
  final $Res Function(TestAttemptDto) _then;

/// Create a copy of TestAttemptDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? studentId = null,Object? testId = null,Object? status = null,Object? answers = null,Object? scorePercent = null,Object? totalMarksAwarded = freezed,Object? totalPossibleMarks = freezed,Object? weakChapterIds = freezed,Object? strongChapterIds = freezed,Object? durationSeconds = freezed,Object? isLiveTestAttempt = null,Object? attemptedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,testId: null == testId ? _self.testId : testId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TestAttemptStatus,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as List<SubmissionAnswerDto>,scorePercent: null == scorePercent ? _self.scorePercent : scorePercent // ignore: cast_nullable_to_non_nullable
as double,totalMarksAwarded: freezed == totalMarksAwarded ? _self.totalMarksAwarded : totalMarksAwarded // ignore: cast_nullable_to_non_nullable
as int?,totalPossibleMarks: freezed == totalPossibleMarks ? _self.totalPossibleMarks : totalPossibleMarks // ignore: cast_nullable_to_non_nullable
as int?,weakChapterIds: freezed == weakChapterIds ? _self.weakChapterIds : weakChapterIds // ignore: cast_nullable_to_non_nullable
as List<String>?,strongChapterIds: freezed == strongChapterIds ? _self.strongChapterIds : strongChapterIds // ignore: cast_nullable_to_non_nullable
as List<String>?,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,isLiveTestAttempt: null == isLiveTestAttempt ? _self.isLiveTestAttempt : isLiveTestAttempt // ignore: cast_nullable_to_non_nullable
as bool,attemptedAt: null == attemptedAt ? _self.attemptedAt : attemptedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TestAttemptDto].
extension TestAttemptDtoPatterns on TestAttemptDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TestAttemptDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TestAttemptDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TestAttemptDto value)  $default,){
final _that = this;
switch (_that) {
case _TestAttemptDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TestAttemptDto value)?  $default,){
final _that = this;
switch (_that) {
case _TestAttemptDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String studentId,  String testId,  TestAttemptStatus status,  List<SubmissionAnswerDto> answers,  double scorePercent,  int? totalMarksAwarded,  int? totalPossibleMarks,  List<String>? weakChapterIds,  List<String>? strongChapterIds,  int? durationSeconds,  bool isLiveTestAttempt,  DateTime attemptedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TestAttemptDto() when $default != null:
return $default(_that.id,_that.studentId,_that.testId,_that.status,_that.answers,_that.scorePercent,_that.totalMarksAwarded,_that.totalPossibleMarks,_that.weakChapterIds,_that.strongChapterIds,_that.durationSeconds,_that.isLiveTestAttempt,_that.attemptedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String studentId,  String testId,  TestAttemptStatus status,  List<SubmissionAnswerDto> answers,  double scorePercent,  int? totalMarksAwarded,  int? totalPossibleMarks,  List<String>? weakChapterIds,  List<String>? strongChapterIds,  int? durationSeconds,  bool isLiveTestAttempt,  DateTime attemptedAt)  $default,) {final _that = this;
switch (_that) {
case _TestAttemptDto():
return $default(_that.id,_that.studentId,_that.testId,_that.status,_that.answers,_that.scorePercent,_that.totalMarksAwarded,_that.totalPossibleMarks,_that.weakChapterIds,_that.strongChapterIds,_that.durationSeconds,_that.isLiveTestAttempt,_that.attemptedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String studentId,  String testId,  TestAttemptStatus status,  List<SubmissionAnswerDto> answers,  double scorePercent,  int? totalMarksAwarded,  int? totalPossibleMarks,  List<String>? weakChapterIds,  List<String>? strongChapterIds,  int? durationSeconds,  bool isLiveTestAttempt,  DateTime attemptedAt)?  $default,) {final _that = this;
switch (_that) {
case _TestAttemptDto() when $default != null:
return $default(_that.id,_that.studentId,_that.testId,_that.status,_that.answers,_that.scorePercent,_that.totalMarksAwarded,_that.totalPossibleMarks,_that.weakChapterIds,_that.strongChapterIds,_that.durationSeconds,_that.isLiveTestAttempt,_that.attemptedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TestAttemptDto extends TestAttemptDto {
  const _TestAttemptDto({required this.id, required this.studentId, required this.testId, required this.status, this.answers = const <SubmissionAnswerDto>[], this.scorePercent = 0.0, this.totalMarksAwarded, this.totalPossibleMarks, this.weakChapterIds, this.strongChapterIds, this.durationSeconds, this.isLiveTestAttempt = false, required this.attemptedAt}): super._();
  factory _TestAttemptDto.fromJson(Map<String, dynamic> json) => _$TestAttemptDtoFromJson(json);

@override final  String id;
@override final  String studentId;
@override final  String testId;
@override final  TestAttemptStatus status;
@override@JsonKey() final  List<SubmissionAnswerDto> answers;
@override@JsonKey() final  double scorePercent;
@override final  int? totalMarksAwarded;
@override final  int? totalPossibleMarks;
@override final  List<String>? weakChapterIds;
@override final  List<String>? strongChapterIds;
@override final  int? durationSeconds;
@override@JsonKey() final  bool isLiveTestAttempt;
@override final  DateTime attemptedAt;

/// Create a copy of TestAttemptDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TestAttemptDtoCopyWith<_TestAttemptDto> get copyWith => __$TestAttemptDtoCopyWithImpl<_TestAttemptDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TestAttemptDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TestAttemptDto&&(identical(other.id, id) || other.id == id)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.testId, testId) || other.testId == testId)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.answers, answers)&&(identical(other.scorePercent, scorePercent) || other.scorePercent == scorePercent)&&(identical(other.totalMarksAwarded, totalMarksAwarded) || other.totalMarksAwarded == totalMarksAwarded)&&(identical(other.totalPossibleMarks, totalPossibleMarks) || other.totalPossibleMarks == totalPossibleMarks)&&const DeepCollectionEquality().equals(other.weakChapterIds, weakChapterIds)&&const DeepCollectionEquality().equals(other.strongChapterIds, strongChapterIds)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.isLiveTestAttempt, isLiveTestAttempt) || other.isLiveTestAttempt == isLiveTestAttempt)&&(identical(other.attemptedAt, attemptedAt) || other.attemptedAt == attemptedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,studentId,testId,status,const DeepCollectionEquality().hash(answers),scorePercent,totalMarksAwarded,totalPossibleMarks,const DeepCollectionEquality().hash(weakChapterIds),const DeepCollectionEquality().hash(strongChapterIds),durationSeconds,isLiveTestAttempt,attemptedAt);

@override
String toString() {
  return 'TestAttemptDto(id: $id, studentId: $studentId, testId: $testId, status: $status, answers: $answers, scorePercent: $scorePercent, totalMarksAwarded: $totalMarksAwarded, totalPossibleMarks: $totalPossibleMarks, weakChapterIds: $weakChapterIds, strongChapterIds: $strongChapterIds, durationSeconds: $durationSeconds, isLiveTestAttempt: $isLiveTestAttempt, attemptedAt: $attemptedAt)';
}


}

/// @nodoc
abstract mixin class _$TestAttemptDtoCopyWith<$Res> implements $TestAttemptDtoCopyWith<$Res> {
  factory _$TestAttemptDtoCopyWith(_TestAttemptDto value, $Res Function(_TestAttemptDto) _then) = __$TestAttemptDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String studentId, String testId, TestAttemptStatus status, List<SubmissionAnswerDto> answers, double scorePercent, int? totalMarksAwarded, int? totalPossibleMarks, List<String>? weakChapterIds, List<String>? strongChapterIds, int? durationSeconds, bool isLiveTestAttempt, DateTime attemptedAt
});




}
/// @nodoc
class __$TestAttemptDtoCopyWithImpl<$Res>
    implements _$TestAttemptDtoCopyWith<$Res> {
  __$TestAttemptDtoCopyWithImpl(this._self, this._then);

  final _TestAttemptDto _self;
  final $Res Function(_TestAttemptDto) _then;

/// Create a copy of TestAttemptDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? studentId = null,Object? testId = null,Object? status = null,Object? answers = null,Object? scorePercent = null,Object? totalMarksAwarded = freezed,Object? totalPossibleMarks = freezed,Object? weakChapterIds = freezed,Object? strongChapterIds = freezed,Object? durationSeconds = freezed,Object? isLiveTestAttempt = null,Object? attemptedAt = null,}) {
  return _then(_TestAttemptDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,testId: null == testId ? _self.testId : testId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TestAttemptStatus,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as List<SubmissionAnswerDto>,scorePercent: null == scorePercent ? _self.scorePercent : scorePercent // ignore: cast_nullable_to_non_nullable
as double,totalMarksAwarded: freezed == totalMarksAwarded ? _self.totalMarksAwarded : totalMarksAwarded // ignore: cast_nullable_to_non_nullable
as int?,totalPossibleMarks: freezed == totalPossibleMarks ? _self.totalPossibleMarks : totalPossibleMarks // ignore: cast_nullable_to_non_nullable
as int?,weakChapterIds: freezed == weakChapterIds ? _self.weakChapterIds : weakChapterIds // ignore: cast_nullable_to_non_nullable
as List<String>?,strongChapterIds: freezed == strongChapterIds ? _self.strongChapterIds : strongChapterIds // ignore: cast_nullable_to_non_nullable
as List<String>?,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,isLiveTestAttempt: null == isLiveTestAttempt ? _self.isLiveTestAttempt : isLiveTestAttempt // ignore: cast_nullable_to_non_nullable
as bool,attemptedAt: null == attemptedAt ? _self.attemptedAt : attemptedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
