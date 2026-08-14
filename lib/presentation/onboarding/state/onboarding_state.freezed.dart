// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingState {

 String get phoneNumber; bool get otpVerified; int get otpAttempts; bool get otpLocked; String get name; String get city; String get college; ClassLevel? get classLevel; String get classCode; int get subjectCount; List<String> get subjects; bool get submitted;
/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingStateCopyWith<OnboardingState> get copyWith => _$OnboardingStateCopyWithImpl<OnboardingState>(this as OnboardingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingState&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.otpVerified, otpVerified) || other.otpVerified == otpVerified)&&(identical(other.otpAttempts, otpAttempts) || other.otpAttempts == otpAttempts)&&(identical(other.otpLocked, otpLocked) || other.otpLocked == otpLocked)&&(identical(other.name, name) || other.name == name)&&(identical(other.city, city) || other.city == city)&&(identical(other.college, college) || other.college == college)&&(identical(other.classLevel, classLevel) || other.classLevel == classLevel)&&(identical(other.classCode, classCode) || other.classCode == classCode)&&(identical(other.subjectCount, subjectCount) || other.subjectCount == subjectCount)&&const DeepCollectionEquality().equals(other.subjects, subjects)&&(identical(other.submitted, submitted) || other.submitted == submitted));
}


@override
int get hashCode => Object.hash(runtimeType,phoneNumber,otpVerified,otpAttempts,otpLocked,name,city,college,classLevel,classCode,subjectCount,const DeepCollectionEquality().hash(subjects),submitted);

@override
String toString() {
  return 'OnboardingState(phoneNumber: $phoneNumber, otpVerified: $otpVerified, otpAttempts: $otpAttempts, otpLocked: $otpLocked, name: $name, city: $city, college: $college, classLevel: $classLevel, classCode: $classCode, subjectCount: $subjectCount, subjects: $subjects, submitted: $submitted)';
}


}

/// @nodoc
abstract mixin class $OnboardingStateCopyWith<$Res>  {
  factory $OnboardingStateCopyWith(OnboardingState value, $Res Function(OnboardingState) _then) = _$OnboardingStateCopyWithImpl;
@useResult
$Res call({
 String phoneNumber, bool otpVerified, int otpAttempts, bool otpLocked, String name, String city, String college, ClassLevel? classLevel, String classCode, int subjectCount, List<String> subjects, bool submitted
});




}
/// @nodoc
class _$OnboardingStateCopyWithImpl<$Res>
    implements $OnboardingStateCopyWith<$Res> {
  _$OnboardingStateCopyWithImpl(this._self, this._then);

  final OnboardingState _self;
  final $Res Function(OnboardingState) _then;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phoneNumber = null,Object? otpVerified = null,Object? otpAttempts = null,Object? otpLocked = null,Object? name = null,Object? city = null,Object? college = null,Object? classLevel = freezed,Object? classCode = null,Object? subjectCount = null,Object? subjects = null,Object? submitted = null,}) {
  return _then(_self.copyWith(
phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,otpVerified: null == otpVerified ? _self.otpVerified : otpVerified // ignore: cast_nullable_to_non_nullable
as bool,otpAttempts: null == otpAttempts ? _self.otpAttempts : otpAttempts // ignore: cast_nullable_to_non_nullable
as int,otpLocked: null == otpLocked ? _self.otpLocked : otpLocked // ignore: cast_nullable_to_non_nullable
as bool,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,college: null == college ? _self.college : college // ignore: cast_nullable_to_non_nullable
as String,classLevel: freezed == classLevel ? _self.classLevel : classLevel // ignore: cast_nullable_to_non_nullable
as ClassLevel?,classCode: null == classCode ? _self.classCode : classCode // ignore: cast_nullable_to_non_nullable
as String,subjectCount: null == subjectCount ? _self.subjectCount : subjectCount // ignore: cast_nullable_to_non_nullable
as int,subjects: null == subjects ? _self.subjects : subjects // ignore: cast_nullable_to_non_nullable
as List<String>,submitted: null == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingState].
extension OnboardingStatePatterns on OnboardingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingState value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingState value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String phoneNumber,  bool otpVerified,  int otpAttempts,  bool otpLocked,  String name,  String city,  String college,  ClassLevel? classLevel,  String classCode,  int subjectCount,  List<String> subjects,  bool submitted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.phoneNumber,_that.otpVerified,_that.otpAttempts,_that.otpLocked,_that.name,_that.city,_that.college,_that.classLevel,_that.classCode,_that.subjectCount,_that.subjects,_that.submitted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String phoneNumber,  bool otpVerified,  int otpAttempts,  bool otpLocked,  String name,  String city,  String college,  ClassLevel? classLevel,  String classCode,  int subjectCount,  List<String> subjects,  bool submitted)  $default,) {final _that = this;
switch (_that) {
case _OnboardingState():
return $default(_that.phoneNumber,_that.otpVerified,_that.otpAttempts,_that.otpLocked,_that.name,_that.city,_that.college,_that.classLevel,_that.classCode,_that.subjectCount,_that.subjects,_that.submitted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String phoneNumber,  bool otpVerified,  int otpAttempts,  bool otpLocked,  String name,  String city,  String college,  ClassLevel? classLevel,  String classCode,  int subjectCount,  List<String> subjects,  bool submitted)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.phoneNumber,_that.otpVerified,_that.otpAttempts,_that.otpLocked,_that.name,_that.city,_that.college,_that.classLevel,_that.classCode,_that.subjectCount,_that.subjects,_that.submitted);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingState extends OnboardingState {
  const _OnboardingState({this.phoneNumber = '', this.otpVerified = false, this.otpAttempts = 0, this.otpLocked = false, this.name = '', this.city = '', this.college = '', this.classLevel, this.classCode = '', this.subjectCount = 3, this.subjects = const <String>[], this.submitted = false}): super._();
  

@override@JsonKey() final  String phoneNumber;
@override@JsonKey() final  bool otpVerified;
@override@JsonKey() final  int otpAttempts;
@override@JsonKey() final  bool otpLocked;
@override@JsonKey() final  String name;
@override@JsonKey() final  String city;
@override@JsonKey() final  String college;
@override final  ClassLevel? classLevel;
@override@JsonKey() final  String classCode;
@override@JsonKey() final  int subjectCount;
@override@JsonKey() final  List<String> subjects;
@override@JsonKey() final  bool submitted;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingStateCopyWith<_OnboardingState> get copyWith => __$OnboardingStateCopyWithImpl<_OnboardingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingState&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.otpVerified, otpVerified) || other.otpVerified == otpVerified)&&(identical(other.otpAttempts, otpAttempts) || other.otpAttempts == otpAttempts)&&(identical(other.otpLocked, otpLocked) || other.otpLocked == otpLocked)&&(identical(other.name, name) || other.name == name)&&(identical(other.city, city) || other.city == city)&&(identical(other.college, college) || other.college == college)&&(identical(other.classLevel, classLevel) || other.classLevel == classLevel)&&(identical(other.classCode, classCode) || other.classCode == classCode)&&(identical(other.subjectCount, subjectCount) || other.subjectCount == subjectCount)&&const DeepCollectionEquality().equals(other.subjects, subjects)&&(identical(other.submitted, submitted) || other.submitted == submitted));
}


@override
int get hashCode => Object.hash(runtimeType,phoneNumber,otpVerified,otpAttempts,otpLocked,name,city,college,classLevel,classCode,subjectCount,const DeepCollectionEquality().hash(subjects),submitted);

@override
String toString() {
  return 'OnboardingState(phoneNumber: $phoneNumber, otpVerified: $otpVerified, otpAttempts: $otpAttempts, otpLocked: $otpLocked, name: $name, city: $city, college: $college, classLevel: $classLevel, classCode: $classCode, subjectCount: $subjectCount, subjects: $subjects, submitted: $submitted)';
}


}

/// @nodoc
abstract mixin class _$OnboardingStateCopyWith<$Res> implements $OnboardingStateCopyWith<$Res> {
  factory _$OnboardingStateCopyWith(_OnboardingState value, $Res Function(_OnboardingState) _then) = __$OnboardingStateCopyWithImpl;
@override @useResult
$Res call({
 String phoneNumber, bool otpVerified, int otpAttempts, bool otpLocked, String name, String city, String college, ClassLevel? classLevel, String classCode, int subjectCount, List<String> subjects, bool submitted
});




}
/// @nodoc
class __$OnboardingStateCopyWithImpl<$Res>
    implements _$OnboardingStateCopyWith<$Res> {
  __$OnboardingStateCopyWithImpl(this._self, this._then);

  final _OnboardingState _self;
  final $Res Function(_OnboardingState) _then;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phoneNumber = null,Object? otpVerified = null,Object? otpAttempts = null,Object? otpLocked = null,Object? name = null,Object? city = null,Object? college = null,Object? classLevel = freezed,Object? classCode = null,Object? subjectCount = null,Object? subjects = null,Object? submitted = null,}) {
  return _then(_OnboardingState(
phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,otpVerified: null == otpVerified ? _self.otpVerified : otpVerified // ignore: cast_nullable_to_non_nullable
as bool,otpAttempts: null == otpAttempts ? _self.otpAttempts : otpAttempts // ignore: cast_nullable_to_non_nullable
as int,otpLocked: null == otpLocked ? _self.otpLocked : otpLocked // ignore: cast_nullable_to_non_nullable
as bool,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,college: null == college ? _self.college : college // ignore: cast_nullable_to_non_nullable
as String,classLevel: freezed == classLevel ? _self.classLevel : classLevel // ignore: cast_nullable_to_non_nullable
as ClassLevel?,classCode: null == classCode ? _self.classCode : classCode // ignore: cast_nullable_to_non_nullable
as String,subjectCount: null == subjectCount ? _self.subjectCount : subjectCount // ignore: cast_nullable_to_non_nullable
as int,subjects: null == subjects ? _self.subjects : subjects // ignore: cast_nullable_to_non_nullable
as List<String>,submitted: null == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
