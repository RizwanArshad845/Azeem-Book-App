// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subject_enrollment_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubjectEnrollmentDto {

 String get studentId; String get subjectId; String? get teacherId; bool get discountApplied;
/// Create a copy of SubjectEnrollmentDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubjectEnrollmentDtoCopyWith<SubjectEnrollmentDto> get copyWith => _$SubjectEnrollmentDtoCopyWithImpl<SubjectEnrollmentDto>(this as SubjectEnrollmentDto, _$identity);

  /// Serializes this SubjectEnrollmentDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubjectEnrollmentDto&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId)&&(identical(other.discountApplied, discountApplied) || other.discountApplied == discountApplied));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,studentId,subjectId,teacherId,discountApplied);

@override
String toString() {
  return 'SubjectEnrollmentDto(studentId: $studentId, subjectId: $subjectId, teacherId: $teacherId, discountApplied: $discountApplied)';
}


}

/// @nodoc
abstract mixin class $SubjectEnrollmentDtoCopyWith<$Res>  {
  factory $SubjectEnrollmentDtoCopyWith(SubjectEnrollmentDto value, $Res Function(SubjectEnrollmentDto) _then) = _$SubjectEnrollmentDtoCopyWithImpl;
@useResult
$Res call({
 String studentId, String subjectId, String? teacherId, bool discountApplied
});




}
/// @nodoc
class _$SubjectEnrollmentDtoCopyWithImpl<$Res>
    implements $SubjectEnrollmentDtoCopyWith<$Res> {
  _$SubjectEnrollmentDtoCopyWithImpl(this._self, this._then);

  final SubjectEnrollmentDto _self;
  final $Res Function(SubjectEnrollmentDto) _then;

/// Create a copy of SubjectEnrollmentDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? studentId = null,Object? subjectId = null,Object? teacherId = freezed,Object? discountApplied = null,}) {
  return _then(_self.copyWith(
studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,teacherId: freezed == teacherId ? _self.teacherId : teacherId // ignore: cast_nullable_to_non_nullable
as String?,discountApplied: null == discountApplied ? _self.discountApplied : discountApplied // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SubjectEnrollmentDto].
extension SubjectEnrollmentDtoPatterns on SubjectEnrollmentDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubjectEnrollmentDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubjectEnrollmentDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubjectEnrollmentDto value)  $default,){
final _that = this;
switch (_that) {
case _SubjectEnrollmentDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubjectEnrollmentDto value)?  $default,){
final _that = this;
switch (_that) {
case _SubjectEnrollmentDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String studentId,  String subjectId,  String? teacherId,  bool discountApplied)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubjectEnrollmentDto() when $default != null:
return $default(_that.studentId,_that.subjectId,_that.teacherId,_that.discountApplied);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String studentId,  String subjectId,  String? teacherId,  bool discountApplied)  $default,) {final _that = this;
switch (_that) {
case _SubjectEnrollmentDto():
return $default(_that.studentId,_that.subjectId,_that.teacherId,_that.discountApplied);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String studentId,  String subjectId,  String? teacherId,  bool discountApplied)?  $default,) {final _that = this;
switch (_that) {
case _SubjectEnrollmentDto() when $default != null:
return $default(_that.studentId,_that.subjectId,_that.teacherId,_that.discountApplied);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubjectEnrollmentDto extends SubjectEnrollmentDto {
  const _SubjectEnrollmentDto({required this.studentId, required this.subjectId, this.teacherId, this.discountApplied = false}): super._();
  factory _SubjectEnrollmentDto.fromJson(Map<String, dynamic> json) => _$SubjectEnrollmentDtoFromJson(json);

@override final  String studentId;
@override final  String subjectId;
@override final  String? teacherId;
@override@JsonKey() final  bool discountApplied;

/// Create a copy of SubjectEnrollmentDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubjectEnrollmentDtoCopyWith<_SubjectEnrollmentDto> get copyWith => __$SubjectEnrollmentDtoCopyWithImpl<_SubjectEnrollmentDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubjectEnrollmentDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubjectEnrollmentDto&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId)&&(identical(other.discountApplied, discountApplied) || other.discountApplied == discountApplied));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,studentId,subjectId,teacherId,discountApplied);

@override
String toString() {
  return 'SubjectEnrollmentDto(studentId: $studentId, subjectId: $subjectId, teacherId: $teacherId, discountApplied: $discountApplied)';
}


}

/// @nodoc
abstract mixin class _$SubjectEnrollmentDtoCopyWith<$Res> implements $SubjectEnrollmentDtoCopyWith<$Res> {
  factory _$SubjectEnrollmentDtoCopyWith(_SubjectEnrollmentDto value, $Res Function(_SubjectEnrollmentDto) _then) = __$SubjectEnrollmentDtoCopyWithImpl;
@override @useResult
$Res call({
 String studentId, String subjectId, String? teacherId, bool discountApplied
});




}
/// @nodoc
class __$SubjectEnrollmentDtoCopyWithImpl<$Res>
    implements _$SubjectEnrollmentDtoCopyWith<$Res> {
  __$SubjectEnrollmentDtoCopyWithImpl(this._self, this._then);

  final _SubjectEnrollmentDto _self;
  final $Res Function(_SubjectEnrollmentDto) _then;

/// Create a copy of SubjectEnrollmentDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? studentId = null,Object? subjectId = null,Object? teacherId = freezed,Object? discountApplied = null,}) {
  return _then(_SubjectEnrollmentDto(
studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,teacherId: freezed == teacherId ? _self.teacherId : teacherId // ignore: cast_nullable_to_non_nullable
as String?,discountApplied: null == discountApplied ? _self.discountApplied : discountApplied // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
