// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Teacher {

// --- User base fields (flattened; see class doc) ---
 String get id; String get name; String get phoneNumber;// Reuses the existing `UserRole` enum from domain/auth (already scoped
// to exactly {teacher, student}) instead of inventing a new one — a
// Teacher's `role` is always `UserRole.teacher`.
 UserRole get role; bool get isDeleted; DateTime get createdAt; DateTime get updatedAt;// --- Teacher-specific fields (§9.2) ---
 String get campusId; List<String> get subjects; List<String>? get classes; int? get declaredStudentCount; String? get salesmanId; TeacherOnboardingSource get onboardingSource; TeacherApprovalStatus get approvalStatus; double get actualEarnings; double? get projectedEarnings;
/// Create a copy of Teacher
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherCopyWith<Teacher> get copyWith => _$TeacherCopyWithImpl<Teacher>(this as Teacher, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Teacher&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.role, role) || other.role == role)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&const DeepCollectionEquality().equals(other.subjects, subjects)&&const DeepCollectionEquality().equals(other.classes, classes)&&(identical(other.declaredStudentCount, declaredStudentCount) || other.declaredStudentCount == declaredStudentCount)&&(identical(other.salesmanId, salesmanId) || other.salesmanId == salesmanId)&&(identical(other.onboardingSource, onboardingSource) || other.onboardingSource == onboardingSource)&&(identical(other.approvalStatus, approvalStatus) || other.approvalStatus == approvalStatus)&&(identical(other.actualEarnings, actualEarnings) || other.actualEarnings == actualEarnings)&&(identical(other.projectedEarnings, projectedEarnings) || other.projectedEarnings == projectedEarnings));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,phoneNumber,role,isDeleted,createdAt,updatedAt,campusId,const DeepCollectionEquality().hash(subjects),const DeepCollectionEquality().hash(classes),declaredStudentCount,salesmanId,onboardingSource,approvalStatus,actualEarnings,projectedEarnings);

@override
String toString() {
  return 'Teacher(id: $id, name: $name, phoneNumber: $phoneNumber, role: $role, isDeleted: $isDeleted, createdAt: $createdAt, updatedAt: $updatedAt, campusId: $campusId, subjects: $subjects, classes: $classes, declaredStudentCount: $declaredStudentCount, salesmanId: $salesmanId, onboardingSource: $onboardingSource, approvalStatus: $approvalStatus, actualEarnings: $actualEarnings, projectedEarnings: $projectedEarnings)';
}


}

/// @nodoc
abstract mixin class $TeacherCopyWith<$Res>  {
  factory $TeacherCopyWith(Teacher value, $Res Function(Teacher) _then) = _$TeacherCopyWithImpl;
@useResult
$Res call({
 String id, String name, String phoneNumber, UserRole role, bool isDeleted, DateTime createdAt, DateTime updatedAt, String campusId, List<String> subjects, List<String>? classes, int? declaredStudentCount, String? salesmanId, TeacherOnboardingSource onboardingSource, TeacherApprovalStatus approvalStatus, double actualEarnings, double? projectedEarnings
});




}
/// @nodoc
class _$TeacherCopyWithImpl<$Res>
    implements $TeacherCopyWith<$Res> {
  _$TeacherCopyWithImpl(this._self, this._then);

  final Teacher _self;
  final $Res Function(Teacher) _then;

/// Create a copy of Teacher
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? phoneNumber = null,Object? role = null,Object? isDeleted = null,Object? createdAt = null,Object? updatedAt = null,Object? campusId = null,Object? subjects = null,Object? classes = freezed,Object? declaredStudentCount = freezed,Object? salesmanId = freezed,Object? onboardingSource = null,Object? approvalStatus = null,Object? actualEarnings = null,Object? projectedEarnings = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,campusId: null == campusId ? _self.campusId : campusId // ignore: cast_nullable_to_non_nullable
as String,subjects: null == subjects ? _self.subjects : subjects // ignore: cast_nullable_to_non_nullable
as List<String>,classes: freezed == classes ? _self.classes : classes // ignore: cast_nullable_to_non_nullable
as List<String>?,declaredStudentCount: freezed == declaredStudentCount ? _self.declaredStudentCount : declaredStudentCount // ignore: cast_nullable_to_non_nullable
as int?,salesmanId: freezed == salesmanId ? _self.salesmanId : salesmanId // ignore: cast_nullable_to_non_nullable
as String?,onboardingSource: null == onboardingSource ? _self.onboardingSource : onboardingSource // ignore: cast_nullable_to_non_nullable
as TeacherOnboardingSource,approvalStatus: null == approvalStatus ? _self.approvalStatus : approvalStatus // ignore: cast_nullable_to_non_nullable
as TeacherApprovalStatus,actualEarnings: null == actualEarnings ? _self.actualEarnings : actualEarnings // ignore: cast_nullable_to_non_nullable
as double,projectedEarnings: freezed == projectedEarnings ? _self.projectedEarnings : projectedEarnings // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [Teacher].
extension TeacherPatterns on Teacher {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Teacher value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Teacher() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Teacher value)  $default,){
final _that = this;
switch (_that) {
case _Teacher():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Teacher value)?  $default,){
final _that = this;
switch (_that) {
case _Teacher() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String phoneNumber,  UserRole role,  bool isDeleted,  DateTime createdAt,  DateTime updatedAt,  String campusId,  List<String> subjects,  List<String>? classes,  int? declaredStudentCount,  String? salesmanId,  TeacherOnboardingSource onboardingSource,  TeacherApprovalStatus approvalStatus,  double actualEarnings,  double? projectedEarnings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Teacher() when $default != null:
return $default(_that.id,_that.name,_that.phoneNumber,_that.role,_that.isDeleted,_that.createdAt,_that.updatedAt,_that.campusId,_that.subjects,_that.classes,_that.declaredStudentCount,_that.salesmanId,_that.onboardingSource,_that.approvalStatus,_that.actualEarnings,_that.projectedEarnings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String phoneNumber,  UserRole role,  bool isDeleted,  DateTime createdAt,  DateTime updatedAt,  String campusId,  List<String> subjects,  List<String>? classes,  int? declaredStudentCount,  String? salesmanId,  TeacherOnboardingSource onboardingSource,  TeacherApprovalStatus approvalStatus,  double actualEarnings,  double? projectedEarnings)  $default,) {final _that = this;
switch (_that) {
case _Teacher():
return $default(_that.id,_that.name,_that.phoneNumber,_that.role,_that.isDeleted,_that.createdAt,_that.updatedAt,_that.campusId,_that.subjects,_that.classes,_that.declaredStudentCount,_that.salesmanId,_that.onboardingSource,_that.approvalStatus,_that.actualEarnings,_that.projectedEarnings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String phoneNumber,  UserRole role,  bool isDeleted,  DateTime createdAt,  DateTime updatedAt,  String campusId,  List<String> subjects,  List<String>? classes,  int? declaredStudentCount,  String? salesmanId,  TeacherOnboardingSource onboardingSource,  TeacherApprovalStatus approvalStatus,  double actualEarnings,  double? projectedEarnings)?  $default,) {final _that = this;
switch (_that) {
case _Teacher() when $default != null:
return $default(_that.id,_that.name,_that.phoneNumber,_that.role,_that.isDeleted,_that.createdAt,_that.updatedAt,_that.campusId,_that.subjects,_that.classes,_that.declaredStudentCount,_that.salesmanId,_that.onboardingSource,_that.approvalStatus,_that.actualEarnings,_that.projectedEarnings);case _:
  return null;

}
}

}

/// @nodoc


class _Teacher implements Teacher {
  const _Teacher({required this.id, required this.name, required this.phoneNumber, required this.role, this.isDeleted = false, required this.createdAt, required this.updatedAt, required this.campusId, required this.subjects, this.classes, this.declaredStudentCount, this.salesmanId, required this.onboardingSource, required this.approvalStatus, this.actualEarnings = 0, this.projectedEarnings});
  

// --- User base fields (flattened; see class doc) ---
@override final  String id;
@override final  String name;
@override final  String phoneNumber;
// Reuses the existing `UserRole` enum from domain/auth (already scoped
// to exactly {teacher, student}) instead of inventing a new one — a
// Teacher's `role` is always `UserRole.teacher`.
@override final  UserRole role;
@override@JsonKey() final  bool isDeleted;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
// --- Teacher-specific fields (§9.2) ---
@override final  String campusId;
@override final  List<String> subjects;
@override final  List<String>? classes;
@override final  int? declaredStudentCount;
@override final  String? salesmanId;
@override final  TeacherOnboardingSource onboardingSource;
@override final  TeacherApprovalStatus approvalStatus;
@override@JsonKey() final  double actualEarnings;
@override final  double? projectedEarnings;

/// Create a copy of Teacher
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeacherCopyWith<_Teacher> get copyWith => __$TeacherCopyWithImpl<_Teacher>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Teacher&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.role, role) || other.role == role)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&const DeepCollectionEquality().equals(other.subjects, subjects)&&const DeepCollectionEquality().equals(other.classes, classes)&&(identical(other.declaredStudentCount, declaredStudentCount) || other.declaredStudentCount == declaredStudentCount)&&(identical(other.salesmanId, salesmanId) || other.salesmanId == salesmanId)&&(identical(other.onboardingSource, onboardingSource) || other.onboardingSource == onboardingSource)&&(identical(other.approvalStatus, approvalStatus) || other.approvalStatus == approvalStatus)&&(identical(other.actualEarnings, actualEarnings) || other.actualEarnings == actualEarnings)&&(identical(other.projectedEarnings, projectedEarnings) || other.projectedEarnings == projectedEarnings));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,phoneNumber,role,isDeleted,createdAt,updatedAt,campusId,const DeepCollectionEquality().hash(subjects),const DeepCollectionEquality().hash(classes),declaredStudentCount,salesmanId,onboardingSource,approvalStatus,actualEarnings,projectedEarnings);

@override
String toString() {
  return 'Teacher(id: $id, name: $name, phoneNumber: $phoneNumber, role: $role, isDeleted: $isDeleted, createdAt: $createdAt, updatedAt: $updatedAt, campusId: $campusId, subjects: $subjects, classes: $classes, declaredStudentCount: $declaredStudentCount, salesmanId: $salesmanId, onboardingSource: $onboardingSource, approvalStatus: $approvalStatus, actualEarnings: $actualEarnings, projectedEarnings: $projectedEarnings)';
}


}

/// @nodoc
abstract mixin class _$TeacherCopyWith<$Res> implements $TeacherCopyWith<$Res> {
  factory _$TeacherCopyWith(_Teacher value, $Res Function(_Teacher) _then) = __$TeacherCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String phoneNumber, UserRole role, bool isDeleted, DateTime createdAt, DateTime updatedAt, String campusId, List<String> subjects, List<String>? classes, int? declaredStudentCount, String? salesmanId, TeacherOnboardingSource onboardingSource, TeacherApprovalStatus approvalStatus, double actualEarnings, double? projectedEarnings
});




}
/// @nodoc
class __$TeacherCopyWithImpl<$Res>
    implements _$TeacherCopyWith<$Res> {
  __$TeacherCopyWithImpl(this._self, this._then);

  final _Teacher _self;
  final $Res Function(_Teacher) _then;

/// Create a copy of Teacher
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? phoneNumber = null,Object? role = null,Object? isDeleted = null,Object? createdAt = null,Object? updatedAt = null,Object? campusId = null,Object? subjects = null,Object? classes = freezed,Object? declaredStudentCount = freezed,Object? salesmanId = freezed,Object? onboardingSource = null,Object? approvalStatus = null,Object? actualEarnings = null,Object? projectedEarnings = freezed,}) {
  return _then(_Teacher(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,campusId: null == campusId ? _self.campusId : campusId // ignore: cast_nullable_to_non_nullable
as String,subjects: null == subjects ? _self.subjects : subjects // ignore: cast_nullable_to_non_nullable
as List<String>,classes: freezed == classes ? _self.classes : classes // ignore: cast_nullable_to_non_nullable
as List<String>?,declaredStudentCount: freezed == declaredStudentCount ? _self.declaredStudentCount : declaredStudentCount // ignore: cast_nullable_to_non_nullable
as int?,salesmanId: freezed == salesmanId ? _self.salesmanId : salesmanId // ignore: cast_nullable_to_non_nullable
as String?,onboardingSource: null == onboardingSource ? _self.onboardingSource : onboardingSource // ignore: cast_nullable_to_non_nullable
as TeacherOnboardingSource,approvalStatus: null == approvalStatus ? _self.approvalStatus : approvalStatus // ignore: cast_nullable_to_non_nullable
as TeacherApprovalStatus,actualEarnings: null == actualEarnings ? _self.actualEarnings : actualEarnings // ignore: cast_nullable_to_non_nullable
as double,projectedEarnings: freezed == projectedEarnings ? _self.projectedEarnings : projectedEarnings // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
