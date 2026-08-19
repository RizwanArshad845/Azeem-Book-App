// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'campus_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CampusDto {

 String get id; String get name; String get city;
/// Create a copy of CampusDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CampusDtoCopyWith<CampusDto> get copyWith => _$CampusDtoCopyWithImpl<CampusDto>(this as CampusDto, _$identity);

  /// Serializes this CampusDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CampusDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.city, city) || other.city == city));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,city);

@override
String toString() {
  return 'CampusDto(id: $id, name: $name, city: $city)';
}


}

/// @nodoc
abstract mixin class $CampusDtoCopyWith<$Res>  {
  factory $CampusDtoCopyWith(CampusDto value, $Res Function(CampusDto) _then) = _$CampusDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name, String city
});




}
/// @nodoc
class _$CampusDtoCopyWithImpl<$Res>
    implements $CampusDtoCopyWith<$Res> {
  _$CampusDtoCopyWithImpl(this._self, this._then);

  final CampusDto _self;
  final $Res Function(CampusDto) _then;

/// Create a copy of CampusDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? city = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CampusDto].
extension CampusDtoPatterns on CampusDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CampusDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CampusDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CampusDto value)  $default,){
final _that = this;
switch (_that) {
case _CampusDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CampusDto value)?  $default,){
final _that = this;
switch (_that) {
case _CampusDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String city)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CampusDto() when $default != null:
return $default(_that.id,_that.name,_that.city);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String city)  $default,) {final _that = this;
switch (_that) {
case _CampusDto():
return $default(_that.id,_that.name,_that.city);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String city)?  $default,) {final _that = this;
switch (_that) {
case _CampusDto() when $default != null:
return $default(_that.id,_that.name,_that.city);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CampusDto extends CampusDto {
  const _CampusDto({required this.id, required this.name, required this.city}): super._();
  factory _CampusDto.fromJson(Map<String, dynamic> json) => _$CampusDtoFromJson(json);

@override final  String id;
@override final  String name;
@override final  String city;

/// Create a copy of CampusDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CampusDtoCopyWith<_CampusDto> get copyWith => __$CampusDtoCopyWithImpl<_CampusDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CampusDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CampusDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.city, city) || other.city == city));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,city);

@override
String toString() {
  return 'CampusDto(id: $id, name: $name, city: $city)';
}


}

/// @nodoc
abstract mixin class _$CampusDtoCopyWith<$Res> implements $CampusDtoCopyWith<$Res> {
  factory _$CampusDtoCopyWith(_CampusDto value, $Res Function(_CampusDto) _then) = __$CampusDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String city
});




}
/// @nodoc
class __$CampusDtoCopyWithImpl<$Res>
    implements _$CampusDtoCopyWith<$Res> {
  __$CampusDtoCopyWithImpl(this._self, this._then);

  final _CampusDto _self;
  final $Res Function(_CampusDto) _then;

/// Create a copy of CampusDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? city = null,}) {
  return _then(_CampusDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
