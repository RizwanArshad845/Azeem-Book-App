// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_option.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TeacherOption {

 String get id; String get name; String get campusId; List<String> get subjectIds;
/// Create a copy of TeacherOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherOptionCopyWith<TeacherOption> get copyWith => _$TeacherOptionCopyWithImpl<TeacherOption>(this as TeacherOption, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherOption&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&const DeepCollectionEquality().equals(other.subjectIds, subjectIds));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,campusId,const DeepCollectionEquality().hash(subjectIds));

@override
String toString() {
  return 'TeacherOption(id: $id, name: $name, campusId: $campusId, subjectIds: $subjectIds)';
}


}

/// @nodoc
abstract mixin class $TeacherOptionCopyWith<$Res>  {
  factory $TeacherOptionCopyWith(TeacherOption value, $Res Function(TeacherOption) _then) = _$TeacherOptionCopyWithImpl;
@useResult
$Res call({
 String id, String name, String campusId, List<String> subjectIds
});




}
/// @nodoc
class _$TeacherOptionCopyWithImpl<$Res>
    implements $TeacherOptionCopyWith<$Res> {
  _$TeacherOptionCopyWithImpl(this._self, this._then);

  final TeacherOption _self;
  final $Res Function(TeacherOption) _then;

/// Create a copy of TeacherOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? campusId = null,Object? subjectIds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,campusId: null == campusId ? _self.campusId : campusId // ignore: cast_nullable_to_non_nullable
as String,subjectIds: null == subjectIds ? _self.subjectIds : subjectIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [TeacherOption].
extension TeacherOptionPatterns on TeacherOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeacherOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeacherOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeacherOption value)  $default,){
final _that = this;
switch (_that) {
case _TeacherOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeacherOption value)?  $default,){
final _that = this;
switch (_that) {
case _TeacherOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String campusId,  List<String> subjectIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeacherOption() when $default != null:
return $default(_that.id,_that.name,_that.campusId,_that.subjectIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String campusId,  List<String> subjectIds)  $default,) {final _that = this;
switch (_that) {
case _TeacherOption():
return $default(_that.id,_that.name,_that.campusId,_that.subjectIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String campusId,  List<String> subjectIds)?  $default,) {final _that = this;
switch (_that) {
case _TeacherOption() when $default != null:
return $default(_that.id,_that.name,_that.campusId,_that.subjectIds);case _:
  return null;

}
}

}

/// @nodoc


class _TeacherOption implements TeacherOption {
  const _TeacherOption({required this.id, required this.name, required this.campusId, required this.subjectIds});
  

@override final  String id;
@override final  String name;
@override final  String campusId;
@override final  List<String> subjectIds;

/// Create a copy of TeacherOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeacherOptionCopyWith<_TeacherOption> get copyWith => __$TeacherOptionCopyWithImpl<_TeacherOption>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeacherOption&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&const DeepCollectionEquality().equals(other.subjectIds, subjectIds));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,campusId,const DeepCollectionEquality().hash(subjectIds));

@override
String toString() {
  return 'TeacherOption(id: $id, name: $name, campusId: $campusId, subjectIds: $subjectIds)';
}


}

/// @nodoc
abstract mixin class _$TeacherOptionCopyWith<$Res> implements $TeacherOptionCopyWith<$Res> {
  factory _$TeacherOptionCopyWith(_TeacherOption value, $Res Function(_TeacherOption) _then) = __$TeacherOptionCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String campusId, List<String> subjectIds
});




}
/// @nodoc
class __$TeacherOptionCopyWithImpl<$Res>
    implements _$TeacherOptionCopyWith<$Res> {
  __$TeacherOptionCopyWithImpl(this._self, this._then);

  final _TeacherOption _self;
  final $Res Function(_TeacherOption) _then;

/// Create a copy of TeacherOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? campusId = null,Object? subjectIds = null,}) {
  return _then(_TeacherOption(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,campusId: null == campusId ? _self.campusId : campusId // ignore: cast_nullable_to_non_nullable
as String,subjectIds: null == subjectIds ? _self.subjectIds : subjectIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
