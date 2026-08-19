// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StudentDto {

 String get id; String get name; String get phoneNumber; UserRole get role; bool get isDeleted; DateTime get createdAt; DateTime get updatedAt; String get campusId; String? get boardClassId; List<SubjectEnrollmentDto>? get subjectEnrollments; String? get cartId;
/// Create a copy of StudentDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentDtoCopyWith<StudentDto> get copyWith => _$StudentDtoCopyWithImpl<StudentDto>(this as StudentDto, _$identity);

  /// Serializes this StudentDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.role, role) || other.role == role)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&(identical(other.boardClassId, boardClassId) || other.boardClassId == boardClassId)&&const DeepCollectionEquality().equals(other.subjectEnrollments, subjectEnrollments)&&(identical(other.cartId, cartId) || other.cartId == cartId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phoneNumber,role,isDeleted,createdAt,updatedAt,campusId,boardClassId,const DeepCollectionEquality().hash(subjectEnrollments),cartId);

@override
String toString() {
  return 'StudentDto(id: $id, name: $name, phoneNumber: $phoneNumber, role: $role, isDeleted: $isDeleted, createdAt: $createdAt, updatedAt: $updatedAt, campusId: $campusId, boardClassId: $boardClassId, subjectEnrollments: $subjectEnrollments, cartId: $cartId)';
}


}

/// @nodoc
abstract mixin class $StudentDtoCopyWith<$Res>  {
  factory $StudentDtoCopyWith(StudentDto value, $Res Function(StudentDto) _then) = _$StudentDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name, String phoneNumber, UserRole role, bool isDeleted, DateTime createdAt, DateTime updatedAt, String campusId, String? boardClassId, List<SubjectEnrollmentDto>? subjectEnrollments, String? cartId
});




}
/// @nodoc
class _$StudentDtoCopyWithImpl<$Res>
    implements $StudentDtoCopyWith<$Res> {
  _$StudentDtoCopyWithImpl(this._self, this._then);

  final StudentDto _self;
  final $Res Function(StudentDto) _then;

/// Create a copy of StudentDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? phoneNumber = null,Object? role = null,Object? isDeleted = null,Object? createdAt = null,Object? updatedAt = null,Object? campusId = null,Object? boardClassId = freezed,Object? subjectEnrollments = freezed,Object? cartId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,campusId: null == campusId ? _self.campusId : campusId // ignore: cast_nullable_to_non_nullable
as String,boardClassId: freezed == boardClassId ? _self.boardClassId : boardClassId // ignore: cast_nullable_to_non_nullable
as String?,subjectEnrollments: freezed == subjectEnrollments ? _self.subjectEnrollments : subjectEnrollments // ignore: cast_nullable_to_non_nullable
as List<SubjectEnrollmentDto>?,cartId: freezed == cartId ? _self.cartId : cartId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StudentDto].
extension StudentDtoPatterns on StudentDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentDto value)  $default,){
final _that = this;
switch (_that) {
case _StudentDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentDto value)?  $default,){
final _that = this;
switch (_that) {
case _StudentDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String phoneNumber,  UserRole role,  bool isDeleted,  DateTime createdAt,  DateTime updatedAt,  String campusId,  String? boardClassId,  List<SubjectEnrollmentDto>? subjectEnrollments,  String? cartId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentDto() when $default != null:
return $default(_that.id,_that.name,_that.phoneNumber,_that.role,_that.isDeleted,_that.createdAt,_that.updatedAt,_that.campusId,_that.boardClassId,_that.subjectEnrollments,_that.cartId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String phoneNumber,  UserRole role,  bool isDeleted,  DateTime createdAt,  DateTime updatedAt,  String campusId,  String? boardClassId,  List<SubjectEnrollmentDto>? subjectEnrollments,  String? cartId)  $default,) {final _that = this;
switch (_that) {
case _StudentDto():
return $default(_that.id,_that.name,_that.phoneNumber,_that.role,_that.isDeleted,_that.createdAt,_that.updatedAt,_that.campusId,_that.boardClassId,_that.subjectEnrollments,_that.cartId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String phoneNumber,  UserRole role,  bool isDeleted,  DateTime createdAt,  DateTime updatedAt,  String campusId,  String? boardClassId,  List<SubjectEnrollmentDto>? subjectEnrollments,  String? cartId)?  $default,) {final _that = this;
switch (_that) {
case _StudentDto() when $default != null:
return $default(_that.id,_that.name,_that.phoneNumber,_that.role,_that.isDeleted,_that.createdAt,_that.updatedAt,_that.campusId,_that.boardClassId,_that.subjectEnrollments,_that.cartId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StudentDto extends StudentDto {
  const _StudentDto({required this.id, required this.name, required this.phoneNumber, required this.role, this.isDeleted = false, required this.createdAt, required this.updatedAt, required this.campusId, this.boardClassId, this.subjectEnrollments, this.cartId}): super._();
  factory _StudentDto.fromJson(Map<String, dynamic> json) => _$StudentDtoFromJson(json);

@override final  String id;
@override final  String name;
@override final  String phoneNumber;
@override final  UserRole role;
@override@JsonKey() final  bool isDeleted;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String campusId;
@override final  String? boardClassId;
@override final  List<SubjectEnrollmentDto>? subjectEnrollments;
@override final  String? cartId;

/// Create a copy of StudentDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentDtoCopyWith<_StudentDto> get copyWith => __$StudentDtoCopyWithImpl<_StudentDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudentDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.role, role) || other.role == role)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&(identical(other.boardClassId, boardClassId) || other.boardClassId == boardClassId)&&const DeepCollectionEquality().equals(other.subjectEnrollments, subjectEnrollments)&&(identical(other.cartId, cartId) || other.cartId == cartId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phoneNumber,role,isDeleted,createdAt,updatedAt,campusId,boardClassId,const DeepCollectionEquality().hash(subjectEnrollments),cartId);

@override
String toString() {
  return 'StudentDto(id: $id, name: $name, phoneNumber: $phoneNumber, role: $role, isDeleted: $isDeleted, createdAt: $createdAt, updatedAt: $updatedAt, campusId: $campusId, boardClassId: $boardClassId, subjectEnrollments: $subjectEnrollments, cartId: $cartId)';
}


}

/// @nodoc
abstract mixin class _$StudentDtoCopyWith<$Res> implements $StudentDtoCopyWith<$Res> {
  factory _$StudentDtoCopyWith(_StudentDto value, $Res Function(_StudentDto) _then) = __$StudentDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String phoneNumber, UserRole role, bool isDeleted, DateTime createdAt, DateTime updatedAt, String campusId, String? boardClassId, List<SubjectEnrollmentDto>? subjectEnrollments, String? cartId
});




}
/// @nodoc
class __$StudentDtoCopyWithImpl<$Res>
    implements _$StudentDtoCopyWith<$Res> {
  __$StudentDtoCopyWithImpl(this._self, this._then);

  final _StudentDto _self;
  final $Res Function(_StudentDto) _then;

/// Create a copy of StudentDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? phoneNumber = null,Object? role = null,Object? isDeleted = null,Object? createdAt = null,Object? updatedAt = null,Object? campusId = null,Object? boardClassId = freezed,Object? subjectEnrollments = freezed,Object? cartId = freezed,}) {
  return _then(_StudentDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,campusId: null == campusId ? _self.campusId : campusId // ignore: cast_nullable_to_non_nullable
as String,boardClassId: freezed == boardClassId ? _self.boardClassId : boardClassId // ignore: cast_nullable_to_non_nullable
as String?,subjectEnrollments: freezed == subjectEnrollments ? _self.subjectEnrollments : subjectEnrollments // ignore: cast_nullable_to_non_nullable
as List<SubjectEnrollmentDto>?,cartId: freezed == cartId ? _self.cartId : cartId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
