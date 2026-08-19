// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'class_level_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ClassLevelDto {

 String get id; String get name; bool get isEnabled;
/// Create a copy of ClassLevelDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClassLevelDtoCopyWith<ClassLevelDto> get copyWith => _$ClassLevelDtoCopyWithImpl<ClassLevelDto>(this as ClassLevelDto, _$identity);

  /// Serializes this ClassLevelDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClassLevelDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,isEnabled);

@override
String toString() {
  return 'ClassLevelDto(id: $id, name: $name, isEnabled: $isEnabled)';
}


}

/// @nodoc
abstract mixin class $ClassLevelDtoCopyWith<$Res>  {
  factory $ClassLevelDtoCopyWith(ClassLevelDto value, $Res Function(ClassLevelDto) _then) = _$ClassLevelDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name, bool isEnabled
});




}
/// @nodoc
class _$ClassLevelDtoCopyWithImpl<$Res>
    implements $ClassLevelDtoCopyWith<$Res> {
  _$ClassLevelDtoCopyWithImpl(this._self, this._then);

  final ClassLevelDto _self;
  final $Res Function(ClassLevelDto) _then;

/// Create a copy of ClassLevelDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? isEnabled = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ClassLevelDto].
extension ClassLevelDtoPatterns on ClassLevelDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClassLevelDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClassLevelDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClassLevelDto value)  $default,){
final _that = this;
switch (_that) {
case _ClassLevelDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClassLevelDto value)?  $default,){
final _that = this;
switch (_that) {
case _ClassLevelDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  bool isEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClassLevelDto() when $default != null:
return $default(_that.id,_that.name,_that.isEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  bool isEnabled)  $default,) {final _that = this;
switch (_that) {
case _ClassLevelDto():
return $default(_that.id,_that.name,_that.isEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  bool isEnabled)?  $default,) {final _that = this;
switch (_that) {
case _ClassLevelDto() when $default != null:
return $default(_that.id,_that.name,_that.isEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClassLevelDto extends ClassLevelDto {
  const _ClassLevelDto({required this.id, required this.name, this.isEnabled = false}): super._();
  factory _ClassLevelDto.fromJson(Map<String, dynamic> json) => _$ClassLevelDtoFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  bool isEnabled;

/// Create a copy of ClassLevelDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClassLevelDtoCopyWith<_ClassLevelDto> get copyWith => __$ClassLevelDtoCopyWithImpl<_ClassLevelDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClassLevelDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClassLevelDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,isEnabled);

@override
String toString() {
  return 'ClassLevelDto(id: $id, name: $name, isEnabled: $isEnabled)';
}


}

/// @nodoc
abstract mixin class _$ClassLevelDtoCopyWith<$Res> implements $ClassLevelDtoCopyWith<$Res> {
  factory _$ClassLevelDtoCopyWith(_ClassLevelDto value, $Res Function(_ClassLevelDto) _then) = __$ClassLevelDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, bool isEnabled
});




}
/// @nodoc
class __$ClassLevelDtoCopyWithImpl<$Res>
    implements _$ClassLevelDtoCopyWith<$Res> {
  __$ClassLevelDtoCopyWithImpl(this._self, this._then);

  final _ClassLevelDto _self;
  final $Res Function(_ClassLevelDto) _then;

/// Create a copy of ClassLevelDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? isEnabled = null,}) {
  return _then(_ClassLevelDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
