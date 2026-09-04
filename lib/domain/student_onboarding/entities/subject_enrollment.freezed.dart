// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subject_enrollment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SubjectEnrollment {

// Nullable: the wire response for `PUT /students/{id}/subject-
// enrollments` (`FRONTEND_INTEGRATION.md` §6.3) is `{id, subjectId,
// teacherId, discountApplied}` — no `studentId` (implied by the URL) —
// this is only populated client-side at construction time via [create].
 String? get studentId; String? get id; String get subjectId; String? get teacherId; bool get discountApplied;
/// Create a copy of SubjectEnrollment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubjectEnrollmentCopyWith<SubjectEnrollment> get copyWith => _$SubjectEnrollmentCopyWithImpl<SubjectEnrollment>(this as SubjectEnrollment, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubjectEnrollment&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.id, id) || other.id == id)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId)&&(identical(other.discountApplied, discountApplied) || other.discountApplied == discountApplied));
}


@override
int get hashCode => Object.hash(runtimeType,studentId,id,subjectId,teacherId,discountApplied);

@override
String toString() {
  return 'SubjectEnrollment(studentId: $studentId, id: $id, subjectId: $subjectId, teacherId: $teacherId, discountApplied: $discountApplied)';
}


}

/// @nodoc
abstract mixin class $SubjectEnrollmentCopyWith<$Res>  {
  factory $SubjectEnrollmentCopyWith(SubjectEnrollment value, $Res Function(SubjectEnrollment) _then) = _$SubjectEnrollmentCopyWithImpl;
@useResult
$Res call({
 String? studentId, String? id, String subjectId, String? teacherId, bool discountApplied
});




}
/// @nodoc
class _$SubjectEnrollmentCopyWithImpl<$Res>
    implements $SubjectEnrollmentCopyWith<$Res> {
  _$SubjectEnrollmentCopyWithImpl(this._self, this._then);

  final SubjectEnrollment _self;
  final $Res Function(SubjectEnrollment) _then;

/// Create a copy of SubjectEnrollment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? studentId = freezed,Object? id = freezed,Object? subjectId = null,Object? teacherId = freezed,Object? discountApplied = null,}) {
  return _then(_self.copyWith(
studentId: freezed == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,teacherId: freezed == teacherId ? _self.teacherId : teacherId // ignore: cast_nullable_to_non_nullable
as String?,discountApplied: null == discountApplied ? _self.discountApplied : discountApplied // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SubjectEnrollment].
extension SubjectEnrollmentPatterns on SubjectEnrollment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubjectEnrollment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubjectEnrollment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubjectEnrollment value)  $default,){
final _that = this;
switch (_that) {
case _SubjectEnrollment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubjectEnrollment value)?  $default,){
final _that = this;
switch (_that) {
case _SubjectEnrollment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? studentId,  String? id,  String subjectId,  String? teacherId,  bool discountApplied)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubjectEnrollment() when $default != null:
return $default(_that.studentId,_that.id,_that.subjectId,_that.teacherId,_that.discountApplied);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? studentId,  String? id,  String subjectId,  String? teacherId,  bool discountApplied)  $default,) {final _that = this;
switch (_that) {
case _SubjectEnrollment():
return $default(_that.studentId,_that.id,_that.subjectId,_that.teacherId,_that.discountApplied);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? studentId,  String? id,  String subjectId,  String? teacherId,  bool discountApplied)?  $default,) {final _that = this;
switch (_that) {
case _SubjectEnrollment() when $default != null:
return $default(_that.studentId,_that.id,_that.subjectId,_that.teacherId,_that.discountApplied);case _:
  return null;

}
}

}

/// @nodoc


class _SubjectEnrollment extends SubjectEnrollment {
  const _SubjectEnrollment({this.studentId, this.id, required this.subjectId, this.teacherId, this.discountApplied = false}): super._();
  

// Nullable: the wire response for `PUT /students/{id}/subject-
// enrollments` (`FRONTEND_INTEGRATION.md` §6.3) is `{id, subjectId,
// teacherId, discountApplied}` — no `studentId` (implied by the URL) —
// this is only populated client-side at construction time via [create].
@override final  String? studentId;
@override final  String? id;
@override final  String subjectId;
@override final  String? teacherId;
@override@JsonKey() final  bool discountApplied;

/// Create a copy of SubjectEnrollment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubjectEnrollmentCopyWith<_SubjectEnrollment> get copyWith => __$SubjectEnrollmentCopyWithImpl<_SubjectEnrollment>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubjectEnrollment&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.id, id) || other.id == id)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId)&&(identical(other.discountApplied, discountApplied) || other.discountApplied == discountApplied));
}


@override
int get hashCode => Object.hash(runtimeType,studentId,id,subjectId,teacherId,discountApplied);

@override
String toString() {
  return 'SubjectEnrollment(studentId: $studentId, id: $id, subjectId: $subjectId, teacherId: $teacherId, discountApplied: $discountApplied)';
}


}

/// @nodoc
abstract mixin class _$SubjectEnrollmentCopyWith<$Res> implements $SubjectEnrollmentCopyWith<$Res> {
  factory _$SubjectEnrollmentCopyWith(_SubjectEnrollment value, $Res Function(_SubjectEnrollment) _then) = __$SubjectEnrollmentCopyWithImpl;
@override @useResult
$Res call({
 String? studentId, String? id, String subjectId, String? teacherId, bool discountApplied
});




}
/// @nodoc
class __$SubjectEnrollmentCopyWithImpl<$Res>
    implements _$SubjectEnrollmentCopyWith<$Res> {
  __$SubjectEnrollmentCopyWithImpl(this._self, this._then);

  final _SubjectEnrollment _self;
  final $Res Function(_SubjectEnrollment) _then;

/// Create a copy of SubjectEnrollment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? studentId = freezed,Object? id = freezed,Object? subjectId = null,Object? teacherId = freezed,Object? discountApplied = null,}) {
  return _then(_SubjectEnrollment(
studentId: freezed == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String?,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,teacherId: freezed == teacherId ? _self.teacherId : teacherId // ignore: cast_nullable_to_non_nullable
as String?,discountApplied: null == discountApplied ? _self.discountApplied : discountApplied // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
