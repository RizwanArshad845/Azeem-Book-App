// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Student {

 String get id; String get name; String get phoneNumber;// Reuses the existing UserRole enum (already scoped to {teacher,
// student}, see lib/domain/auth/entities/user_role.dart) rather than
// inventing a separate Student-specific role type.
 UserRole get role; bool get isDeleted; DateTime get createdAt; DateTime get updatedAt; String get campusId;// Must reference an Admin-enabled BoardClass (§9.2 note).
 String? get boardClassId; List<SubjectEnrollment>? get subjectEnrollments;// No cart feature exists yet — nullable FK carried for forward
// compatibility per §9.2.
 String? get cartId;
/// Create a copy of Student
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentCopyWith<Student> get copyWith => _$StudentCopyWithImpl<Student>(this as Student, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Student&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.role, role) || other.role == role)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&(identical(other.boardClassId, boardClassId) || other.boardClassId == boardClassId)&&const DeepCollectionEquality().equals(other.subjectEnrollments, subjectEnrollments)&&(identical(other.cartId, cartId) || other.cartId == cartId));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,phoneNumber,role,isDeleted,createdAt,updatedAt,campusId,boardClassId,const DeepCollectionEquality().hash(subjectEnrollments),cartId);

@override
String toString() {
  return 'Student(id: $id, name: $name, phoneNumber: $phoneNumber, role: $role, isDeleted: $isDeleted, createdAt: $createdAt, updatedAt: $updatedAt, campusId: $campusId, boardClassId: $boardClassId, subjectEnrollments: $subjectEnrollments, cartId: $cartId)';
}


}

/// @nodoc
abstract mixin class $StudentCopyWith<$Res>  {
  factory $StudentCopyWith(Student value, $Res Function(Student) _then) = _$StudentCopyWithImpl;
@useResult
$Res call({
 String id, String name, String phoneNumber, UserRole role, bool isDeleted, DateTime createdAt, DateTime updatedAt, String campusId, String? boardClassId, List<SubjectEnrollment>? subjectEnrollments, String? cartId
});




}
/// @nodoc
class _$StudentCopyWithImpl<$Res>
    implements $StudentCopyWith<$Res> {
  _$StudentCopyWithImpl(this._self, this._then);

  final Student _self;
  final $Res Function(Student) _then;

/// Create a copy of Student
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
as List<SubjectEnrollment>?,cartId: freezed == cartId ? _self.cartId : cartId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Student].
extension StudentPatterns on Student {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Student value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Student() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Student value)  $default,){
final _that = this;
switch (_that) {
case _Student():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Student value)?  $default,){
final _that = this;
switch (_that) {
case _Student() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String phoneNumber,  UserRole role,  bool isDeleted,  DateTime createdAt,  DateTime updatedAt,  String campusId,  String? boardClassId,  List<SubjectEnrollment>? subjectEnrollments,  String? cartId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Student() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String phoneNumber,  UserRole role,  bool isDeleted,  DateTime createdAt,  DateTime updatedAt,  String campusId,  String? boardClassId,  List<SubjectEnrollment>? subjectEnrollments,  String? cartId)  $default,) {final _that = this;
switch (_that) {
case _Student():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String phoneNumber,  UserRole role,  bool isDeleted,  DateTime createdAt,  DateTime updatedAt,  String campusId,  String? boardClassId,  List<SubjectEnrollment>? subjectEnrollments,  String? cartId)?  $default,) {final _that = this;
switch (_that) {
case _Student() when $default != null:
return $default(_that.id,_that.name,_that.phoneNumber,_that.role,_that.isDeleted,_that.createdAt,_that.updatedAt,_that.campusId,_that.boardClassId,_that.subjectEnrollments,_that.cartId);case _:
  return null;

}
}

}

/// @nodoc


class _Student implements Student {
  const _Student({required this.id, required this.name, required this.phoneNumber, required this.role, this.isDeleted = false, required this.createdAt, required this.updatedAt, required this.campusId, this.boardClassId, this.subjectEnrollments, this.cartId});
  

@override final  String id;
@override final  String name;
@override final  String phoneNumber;
// Reuses the existing UserRole enum (already scoped to {teacher,
// student}, see lib/domain/auth/entities/user_role.dart) rather than
// inventing a separate Student-specific role type.
@override final  UserRole role;
@override@JsonKey() final  bool isDeleted;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String campusId;
// Must reference an Admin-enabled BoardClass (§9.2 note).
@override final  String? boardClassId;
@override final  List<SubjectEnrollment>? subjectEnrollments;
// No cart feature exists yet — nullable FK carried for forward
// compatibility per §9.2.
@override final  String? cartId;

/// Create a copy of Student
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentCopyWith<_Student> get copyWith => __$StudentCopyWithImpl<_Student>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Student&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.role, role) || other.role == role)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&(identical(other.boardClassId, boardClassId) || other.boardClassId == boardClassId)&&const DeepCollectionEquality().equals(other.subjectEnrollments, subjectEnrollments)&&(identical(other.cartId, cartId) || other.cartId == cartId));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,phoneNumber,role,isDeleted,createdAt,updatedAt,campusId,boardClassId,const DeepCollectionEquality().hash(subjectEnrollments),cartId);

@override
String toString() {
  return 'Student(id: $id, name: $name, phoneNumber: $phoneNumber, role: $role, isDeleted: $isDeleted, createdAt: $createdAt, updatedAt: $updatedAt, campusId: $campusId, boardClassId: $boardClassId, subjectEnrollments: $subjectEnrollments, cartId: $cartId)';
}


}

/// @nodoc
abstract mixin class _$StudentCopyWith<$Res> implements $StudentCopyWith<$Res> {
  factory _$StudentCopyWith(_Student value, $Res Function(_Student) _then) = __$StudentCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String phoneNumber, UserRole role, bool isDeleted, DateTime createdAt, DateTime updatedAt, String campusId, String? boardClassId, List<SubjectEnrollment>? subjectEnrollments, String? cartId
});




}
/// @nodoc
class __$StudentCopyWithImpl<$Res>
    implements _$StudentCopyWith<$Res> {
  __$StudentCopyWithImpl(this._self, this._then);

  final _Student _self;
  final $Res Function(_Student) _then;

/// Create a copy of Student
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? phoneNumber = null,Object? role = null,Object? isDeleted = null,Object? createdAt = null,Object? updatedAt = null,Object? campusId = null,Object? boardClassId = freezed,Object? subjectEnrollments = freezed,Object? cartId = freezed,}) {
  return _then(_Student(
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
as List<SubjectEnrollment>?,cartId: freezed == cartId ? _self.cartId : cartId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
