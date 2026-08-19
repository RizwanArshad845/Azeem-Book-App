// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'teacher_option_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeacherOptionDto {

 String get id; String get name; String get campusId; List<String> get subjectIds;
/// Create a copy of TeacherOptionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeacherOptionDtoCopyWith<TeacherOptionDto> get copyWith => _$TeacherOptionDtoCopyWithImpl<TeacherOptionDto>(this as TeacherOptionDto, _$identity);

  /// Serializes this TeacherOptionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeacherOptionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&const DeepCollectionEquality().equals(other.subjectIds, subjectIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,campusId,const DeepCollectionEquality().hash(subjectIds));

@override
String toString() {
  return 'TeacherOptionDto(id: $id, name: $name, campusId: $campusId, subjectIds: $subjectIds)';
}


}

/// @nodoc
abstract mixin class $TeacherOptionDtoCopyWith<$Res>  {
  factory $TeacherOptionDtoCopyWith(TeacherOptionDto value, $Res Function(TeacherOptionDto) _then) = _$TeacherOptionDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name, String campusId, List<String> subjectIds
});




}
/// @nodoc
class _$TeacherOptionDtoCopyWithImpl<$Res>
    implements $TeacherOptionDtoCopyWith<$Res> {
  _$TeacherOptionDtoCopyWithImpl(this._self, this._then);

  final TeacherOptionDto _self;
  final $Res Function(TeacherOptionDto) _then;

/// Create a copy of TeacherOptionDto
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


/// Adds pattern-matching-related methods to [TeacherOptionDto].
extension TeacherOptionDtoPatterns on TeacherOptionDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeacherOptionDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeacherOptionDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeacherOptionDto value)  $default,){
final _that = this;
switch (_that) {
case _TeacherOptionDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeacherOptionDto value)?  $default,){
final _that = this;
switch (_that) {
case _TeacherOptionDto() when $default != null:
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
case _TeacherOptionDto() when $default != null:
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
case _TeacherOptionDto():
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
case _TeacherOptionDto() when $default != null:
return $default(_that.id,_that.name,_that.campusId,_that.subjectIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeacherOptionDto extends TeacherOptionDto {
  const _TeacherOptionDto({required this.id, required this.name, required this.campusId, required this.subjectIds}): super._();
  factory _TeacherOptionDto.fromJson(Map<String, dynamic> json) => _$TeacherOptionDtoFromJson(json);

@override final  String id;
@override final  String name;
@override final  String campusId;
@override final  List<String> subjectIds;

/// Create a copy of TeacherOptionDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeacherOptionDtoCopyWith<_TeacherOptionDto> get copyWith => __$TeacherOptionDtoCopyWithImpl<_TeacherOptionDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeacherOptionDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeacherOptionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.campusId, campusId) || other.campusId == campusId)&&const DeepCollectionEquality().equals(other.subjectIds, subjectIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,campusId,const DeepCollectionEquality().hash(subjectIds));

@override
String toString() {
  return 'TeacherOptionDto(id: $id, name: $name, campusId: $campusId, subjectIds: $subjectIds)';
}


}

/// @nodoc
abstract mixin class _$TeacherOptionDtoCopyWith<$Res> implements $TeacherOptionDtoCopyWith<$Res> {
  factory _$TeacherOptionDtoCopyWith(_TeacherOptionDto value, $Res Function(_TeacherOptionDto) _then) = __$TeacherOptionDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String campusId, List<String> subjectIds
});




}
/// @nodoc
class __$TeacherOptionDtoCopyWithImpl<$Res>
    implements _$TeacherOptionDtoCopyWith<$Res> {
  __$TeacherOptionDtoCopyWithImpl(this._self, this._then);

  final _TeacherOptionDto _self;
  final $Res Function(_TeacherOptionDto) _then;

/// Create a copy of TeacherOptionDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? campusId = null,Object? subjectIds = null,}) {
  return _then(_TeacherOptionDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,campusId: null == campusId ? _self.campusId : campusId // ignore: cast_nullable_to_non_nullable
as String,subjectIds: null == subjectIds ? _self.subjectIds : subjectIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
