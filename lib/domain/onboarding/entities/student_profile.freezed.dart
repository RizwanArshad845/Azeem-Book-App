// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StudentProfile {

 String get phoneNumber; String get name; String get city; String get college; ClassLevel get classLevel; String? get classCode; List<String> get subjects;
/// Create a copy of StudentProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudentProfileCopyWith<StudentProfile> get copyWith => _$StudentProfileCopyWithImpl<StudentProfile>(this as StudentProfile, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudentProfile&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.name, name) || other.name == name)&&(identical(other.city, city) || other.city == city)&&(identical(other.college, college) || other.college == college)&&(identical(other.classLevel, classLevel) || other.classLevel == classLevel)&&(identical(other.classCode, classCode) || other.classCode == classCode)&&const DeepCollectionEquality().equals(other.subjects, subjects));
}


@override
int get hashCode => Object.hash(runtimeType,phoneNumber,name,city,college,classLevel,classCode,const DeepCollectionEquality().hash(subjects));

@override
String toString() {
  return 'StudentProfile(phoneNumber: $phoneNumber, name: $name, city: $city, college: $college, classLevel: $classLevel, classCode: $classCode, subjects: $subjects)';
}


}

/// @nodoc
abstract mixin class $StudentProfileCopyWith<$Res>  {
  factory $StudentProfileCopyWith(StudentProfile value, $Res Function(StudentProfile) _then) = _$StudentProfileCopyWithImpl;
@useResult
$Res call({
 String phoneNumber, String name, String city, String college, ClassLevel classLevel, String? classCode, List<String> subjects
});




}
/// @nodoc
class _$StudentProfileCopyWithImpl<$Res>
    implements $StudentProfileCopyWith<$Res> {
  _$StudentProfileCopyWithImpl(this._self, this._then);

  final StudentProfile _self;
  final $Res Function(StudentProfile) _then;

/// Create a copy of StudentProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phoneNumber = null,Object? name = null,Object? city = null,Object? college = null,Object? classLevel = null,Object? classCode = freezed,Object? subjects = null,}) {
  return _then(_self.copyWith(
phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,college: null == college ? _self.college : college // ignore: cast_nullable_to_non_nullable
as String,classLevel: null == classLevel ? _self.classLevel : classLevel // ignore: cast_nullable_to_non_nullable
as ClassLevel,classCode: freezed == classCode ? _self.classCode : classCode // ignore: cast_nullable_to_non_nullable
as String?,subjects: null == subjects ? _self.subjects : subjects // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [StudentProfile].
extension StudentProfilePatterns on StudentProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudentProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudentProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudentProfile value)  $default,){
final _that = this;
switch (_that) {
case _StudentProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudentProfile value)?  $default,){
final _that = this;
switch (_that) {
case _StudentProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String phoneNumber,  String name,  String city,  String college,  ClassLevel classLevel,  String? classCode,  List<String> subjects)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudentProfile() when $default != null:
return $default(_that.phoneNumber,_that.name,_that.city,_that.college,_that.classLevel,_that.classCode,_that.subjects);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String phoneNumber,  String name,  String city,  String college,  ClassLevel classLevel,  String? classCode,  List<String> subjects)  $default,) {final _that = this;
switch (_that) {
case _StudentProfile():
return $default(_that.phoneNumber,_that.name,_that.city,_that.college,_that.classLevel,_that.classCode,_that.subjects);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String phoneNumber,  String name,  String city,  String college,  ClassLevel classLevel,  String? classCode,  List<String> subjects)?  $default,) {final _that = this;
switch (_that) {
case _StudentProfile() when $default != null:
return $default(_that.phoneNumber,_that.name,_that.city,_that.college,_that.classLevel,_that.classCode,_that.subjects);case _:
  return null;

}
}

}

/// @nodoc


class _StudentProfile implements StudentProfile {
  const _StudentProfile({required this.phoneNumber, required this.name, required this.city, required this.college, required this.classLevel, this.classCode, required this.subjects});
  

@override final  String phoneNumber;
@override final  String name;
@override final  String city;
@override final  String college;
@override final  ClassLevel classLevel;
@override final  String? classCode;
@override final  List<String> subjects;

/// Create a copy of StudentProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudentProfileCopyWith<_StudentProfile> get copyWith => __$StudentProfileCopyWithImpl<_StudentProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudentProfile&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.name, name) || other.name == name)&&(identical(other.city, city) || other.city == city)&&(identical(other.college, college) || other.college == college)&&(identical(other.classLevel, classLevel) || other.classLevel == classLevel)&&(identical(other.classCode, classCode) || other.classCode == classCode)&&const DeepCollectionEquality().equals(other.subjects, subjects));
}


@override
int get hashCode => Object.hash(runtimeType,phoneNumber,name,city,college,classLevel,classCode,const DeepCollectionEquality().hash(subjects));

@override
String toString() {
  return 'StudentProfile(phoneNumber: $phoneNumber, name: $name, city: $city, college: $college, classLevel: $classLevel, classCode: $classCode, subjects: $subjects)';
}


}

/// @nodoc
abstract mixin class _$StudentProfileCopyWith<$Res> implements $StudentProfileCopyWith<$Res> {
  factory _$StudentProfileCopyWith(_StudentProfile value, $Res Function(_StudentProfile) _then) = __$StudentProfileCopyWithImpl;
@override @useResult
$Res call({
 String phoneNumber, String name, String city, String college, ClassLevel classLevel, String? classCode, List<String> subjects
});




}
/// @nodoc
class __$StudentProfileCopyWithImpl<$Res>
    implements _$StudentProfileCopyWith<$Res> {
  __$StudentProfileCopyWithImpl(this._self, this._then);

  final _StudentProfile _self;
  final $Res Function(_StudentProfile) _then;

/// Create a copy of StudentProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phoneNumber = null,Object? name = null,Object? city = null,Object? college = null,Object? classLevel = null,Object? classCode = freezed,Object? subjects = null,}) {
  return _then(_StudentProfile(
phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,college: null == college ? _self.college : college // ignore: cast_nullable_to_non_nullable
as String,classLevel: null == classLevel ? _self.classLevel : classLevel // ignore: cast_nullable_to_non_nullable
as ClassLevel,classCode: freezed == classCode ? _self.classCode : classCode // ignore: cast_nullable_to_non_nullable
as String?,subjects: null == subjects ? _self.subjects : subjects // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
