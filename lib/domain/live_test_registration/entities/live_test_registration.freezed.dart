// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'live_test_registration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LiveTestRegistration {

 String get id; String get studentId; String get testId; DateTime get registeredAt; double? get finalScore; int? get timingSeconds; int? get prizeRank;
/// Create a copy of LiveTestRegistration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LiveTestRegistrationCopyWith<LiveTestRegistration> get copyWith => _$LiveTestRegistrationCopyWithImpl<LiveTestRegistration>(this as LiveTestRegistration, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LiveTestRegistration&&(identical(other.id, id) || other.id == id)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.testId, testId) || other.testId == testId)&&(identical(other.registeredAt, registeredAt) || other.registeredAt == registeredAt)&&(identical(other.finalScore, finalScore) || other.finalScore == finalScore)&&(identical(other.timingSeconds, timingSeconds) || other.timingSeconds == timingSeconds)&&(identical(other.prizeRank, prizeRank) || other.prizeRank == prizeRank));
}


@override
int get hashCode => Object.hash(runtimeType,id,studentId,testId,registeredAt,finalScore,timingSeconds,prizeRank);

@override
String toString() {
  return 'LiveTestRegistration(id: $id, studentId: $studentId, testId: $testId, registeredAt: $registeredAt, finalScore: $finalScore, timingSeconds: $timingSeconds, prizeRank: $prizeRank)';
}


}

/// @nodoc
abstract mixin class $LiveTestRegistrationCopyWith<$Res>  {
  factory $LiveTestRegistrationCopyWith(LiveTestRegistration value, $Res Function(LiveTestRegistration) _then) = _$LiveTestRegistrationCopyWithImpl;
@useResult
$Res call({
 String id, String studentId, String testId, DateTime registeredAt, double? finalScore, int? timingSeconds, int? prizeRank
});




}
/// @nodoc
class _$LiveTestRegistrationCopyWithImpl<$Res>
    implements $LiveTestRegistrationCopyWith<$Res> {
  _$LiveTestRegistrationCopyWithImpl(this._self, this._then);

  final LiveTestRegistration _self;
  final $Res Function(LiveTestRegistration) _then;

/// Create a copy of LiveTestRegistration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? studentId = null,Object? testId = null,Object? registeredAt = null,Object? finalScore = freezed,Object? timingSeconds = freezed,Object? prizeRank = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,testId: null == testId ? _self.testId : testId // ignore: cast_nullable_to_non_nullable
as String,registeredAt: null == registeredAt ? _self.registeredAt : registeredAt // ignore: cast_nullable_to_non_nullable
as DateTime,finalScore: freezed == finalScore ? _self.finalScore : finalScore // ignore: cast_nullable_to_non_nullable
as double?,timingSeconds: freezed == timingSeconds ? _self.timingSeconds : timingSeconds // ignore: cast_nullable_to_non_nullable
as int?,prizeRank: freezed == prizeRank ? _self.prizeRank : prizeRank // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [LiveTestRegistration].
extension LiveTestRegistrationPatterns on LiveTestRegistration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LiveTestRegistration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LiveTestRegistration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LiveTestRegistration value)  $default,){
final _that = this;
switch (_that) {
case _LiveTestRegistration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LiveTestRegistration value)?  $default,){
final _that = this;
switch (_that) {
case _LiveTestRegistration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String studentId,  String testId,  DateTime registeredAt,  double? finalScore,  int? timingSeconds,  int? prizeRank)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LiveTestRegistration() when $default != null:
return $default(_that.id,_that.studentId,_that.testId,_that.registeredAt,_that.finalScore,_that.timingSeconds,_that.prizeRank);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String studentId,  String testId,  DateTime registeredAt,  double? finalScore,  int? timingSeconds,  int? prizeRank)  $default,) {final _that = this;
switch (_that) {
case _LiveTestRegistration():
return $default(_that.id,_that.studentId,_that.testId,_that.registeredAt,_that.finalScore,_that.timingSeconds,_that.prizeRank);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String studentId,  String testId,  DateTime registeredAt,  double? finalScore,  int? timingSeconds,  int? prizeRank)?  $default,) {final _that = this;
switch (_that) {
case _LiveTestRegistration() when $default != null:
return $default(_that.id,_that.studentId,_that.testId,_that.registeredAt,_that.finalScore,_that.timingSeconds,_that.prizeRank);case _:
  return null;

}
}

}

/// @nodoc


class _LiveTestRegistration implements LiveTestRegistration {
  const _LiveTestRegistration({required this.id, required this.studentId, required this.testId, required this.registeredAt, this.finalScore, this.timingSeconds, this.prizeRank});
  

@override final  String id;
@override final  String studentId;
@override final  String testId;
@override final  DateTime registeredAt;
@override final  double? finalScore;
@override final  int? timingSeconds;
@override final  int? prizeRank;

/// Create a copy of LiveTestRegistration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LiveTestRegistrationCopyWith<_LiveTestRegistration> get copyWith => __$LiveTestRegistrationCopyWithImpl<_LiveTestRegistration>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LiveTestRegistration&&(identical(other.id, id) || other.id == id)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.testId, testId) || other.testId == testId)&&(identical(other.registeredAt, registeredAt) || other.registeredAt == registeredAt)&&(identical(other.finalScore, finalScore) || other.finalScore == finalScore)&&(identical(other.timingSeconds, timingSeconds) || other.timingSeconds == timingSeconds)&&(identical(other.prizeRank, prizeRank) || other.prizeRank == prizeRank));
}


@override
int get hashCode => Object.hash(runtimeType,id,studentId,testId,registeredAt,finalScore,timingSeconds,prizeRank);

@override
String toString() {
  return 'LiveTestRegistration(id: $id, studentId: $studentId, testId: $testId, registeredAt: $registeredAt, finalScore: $finalScore, timingSeconds: $timingSeconds, prizeRank: $prizeRank)';
}


}

/// @nodoc
abstract mixin class _$LiveTestRegistrationCopyWith<$Res> implements $LiveTestRegistrationCopyWith<$Res> {
  factory _$LiveTestRegistrationCopyWith(_LiveTestRegistration value, $Res Function(_LiveTestRegistration) _then) = __$LiveTestRegistrationCopyWithImpl;
@override @useResult
$Res call({
 String id, String studentId, String testId, DateTime registeredAt, double? finalScore, int? timingSeconds, int? prizeRank
});




}
/// @nodoc
class __$LiveTestRegistrationCopyWithImpl<$Res>
    implements _$LiveTestRegistrationCopyWith<$Res> {
  __$LiveTestRegistrationCopyWithImpl(this._self, this._then);

  final _LiveTestRegistration _self;
  final $Res Function(_LiveTestRegistration) _then;

/// Create a copy of LiveTestRegistration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? studentId = null,Object? testId = null,Object? registeredAt = null,Object? finalScore = freezed,Object? timingSeconds = freezed,Object? prizeRank = freezed,}) {
  return _then(_LiveTestRegistration(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,testId: null == testId ? _self.testId : testId // ignore: cast_nullable_to_non_nullable
as String,registeredAt: null == registeredAt ? _self.registeredAt : registeredAt // ignore: cast_nullable_to_non_nullable
as DateTime,finalScore: freezed == finalScore ? _self.finalScore : finalScore // ignore: cast_nullable_to_non_nullable
as double?,timingSeconds: freezed == timingSeconds ? _self.timingSeconds : timingSeconds // ignore: cast_nullable_to_non_nullable
as int?,prizeRank: freezed == prizeRank ? _self.prizeRank : prizeRank // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
