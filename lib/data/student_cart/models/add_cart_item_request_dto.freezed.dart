// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_cart_item_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddCartItemRequestDto {

 String get subjectId;
/// Create a copy of AddCartItemRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddCartItemRequestDtoCopyWith<AddCartItemRequestDto> get copyWith => _$AddCartItemRequestDtoCopyWithImpl<AddCartItemRequestDto>(this as AddCartItemRequestDto, _$identity);

  /// Serializes this AddCartItemRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddCartItemRequestDto&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subjectId);

@override
String toString() {
  return 'AddCartItemRequestDto(subjectId: $subjectId)';
}


}

/// @nodoc
abstract mixin class $AddCartItemRequestDtoCopyWith<$Res>  {
  factory $AddCartItemRequestDtoCopyWith(AddCartItemRequestDto value, $Res Function(AddCartItemRequestDto) _then) = _$AddCartItemRequestDtoCopyWithImpl;
@useResult
$Res call({
 String subjectId
});




}
/// @nodoc
class _$AddCartItemRequestDtoCopyWithImpl<$Res>
    implements $AddCartItemRequestDtoCopyWith<$Res> {
  _$AddCartItemRequestDtoCopyWithImpl(this._self, this._then);

  final AddCartItemRequestDto _self;
  final $Res Function(AddCartItemRequestDto) _then;

/// Create a copy of AddCartItemRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subjectId = null,}) {
  return _then(_self.copyWith(
subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AddCartItemRequestDto].
extension AddCartItemRequestDtoPatterns on AddCartItemRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddCartItemRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddCartItemRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddCartItemRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _AddCartItemRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddCartItemRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _AddCartItemRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String subjectId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddCartItemRequestDto() when $default != null:
return $default(_that.subjectId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String subjectId)  $default,) {final _that = this;
switch (_that) {
case _AddCartItemRequestDto():
return $default(_that.subjectId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String subjectId)?  $default,) {final _that = this;
switch (_that) {
case _AddCartItemRequestDto() when $default != null:
return $default(_that.subjectId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AddCartItemRequestDto implements AddCartItemRequestDto {
  const _AddCartItemRequestDto({required this.subjectId});
  factory _AddCartItemRequestDto.fromJson(Map<String, dynamic> json) => _$AddCartItemRequestDtoFromJson(json);

@override final  String subjectId;

/// Create a copy of AddCartItemRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddCartItemRequestDtoCopyWith<_AddCartItemRequestDto> get copyWith => __$AddCartItemRequestDtoCopyWithImpl<_AddCartItemRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddCartItemRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddCartItemRequestDto&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subjectId);

@override
String toString() {
  return 'AddCartItemRequestDto(subjectId: $subjectId)';
}


}

/// @nodoc
abstract mixin class _$AddCartItemRequestDtoCopyWith<$Res> implements $AddCartItemRequestDtoCopyWith<$Res> {
  factory _$AddCartItemRequestDtoCopyWith(_AddCartItemRequestDto value, $Res Function(_AddCartItemRequestDto) _then) = __$AddCartItemRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String subjectId
});




}
/// @nodoc
class __$AddCartItemRequestDtoCopyWithImpl<$Res>
    implements _$AddCartItemRequestDtoCopyWith<$Res> {
  __$AddCartItemRequestDtoCopyWithImpl(this._self, this._then);

  final _AddCartItemRequestDto _self;
  final $Res Function(_AddCartItemRequestDto) _then;

/// Create a copy of AddCartItemRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subjectId = null,}) {
  return _then(_AddCartItemRequestDto(
subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
