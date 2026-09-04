// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CartDto {

 String get id; String get studentId; List<CartItemDto>? get items;@DecimalStringConverter() double get totalAmount;
/// Create a copy of CartDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartDtoCopyWith<CartDto> get copyWith => _$CartDtoCopyWithImpl<CartDto>(this as CartDto, _$identity);

  /// Serializes this CartDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartDto&&(identical(other.id, id) || other.id == id)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,studentId,const DeepCollectionEquality().hash(items),totalAmount);

@override
String toString() {
  return 'CartDto(id: $id, studentId: $studentId, items: $items, totalAmount: $totalAmount)';
}


}

/// @nodoc
abstract mixin class $CartDtoCopyWith<$Res>  {
  factory $CartDtoCopyWith(CartDto value, $Res Function(CartDto) _then) = _$CartDtoCopyWithImpl;
@useResult
$Res call({
 String id, String studentId, List<CartItemDto>? items,@DecimalStringConverter() double totalAmount
});




}
/// @nodoc
class _$CartDtoCopyWithImpl<$Res>
    implements $CartDtoCopyWith<$Res> {
  _$CartDtoCopyWithImpl(this._self, this._then);

  final CartDto _self;
  final $Res Function(CartDto) _then;

/// Create a copy of CartDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? studentId = null,Object? items = freezed,Object? totalAmount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,items: freezed == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CartItemDto>?,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [CartDto].
extension CartDtoPatterns on CartDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CartDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CartDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CartDto value)  $default,){
final _that = this;
switch (_that) {
case _CartDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CartDto value)?  $default,){
final _that = this;
switch (_that) {
case _CartDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String studentId,  List<CartItemDto>? items, @DecimalStringConverter()  double totalAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartDto() when $default != null:
return $default(_that.id,_that.studentId,_that.items,_that.totalAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String studentId,  List<CartItemDto>? items, @DecimalStringConverter()  double totalAmount)  $default,) {final _that = this;
switch (_that) {
case _CartDto():
return $default(_that.id,_that.studentId,_that.items,_that.totalAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String studentId,  List<CartItemDto>? items, @DecimalStringConverter()  double totalAmount)?  $default,) {final _that = this;
switch (_that) {
case _CartDto() when $default != null:
return $default(_that.id,_that.studentId,_that.items,_that.totalAmount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CartDto extends CartDto {
  const _CartDto({required this.id, required this.studentId, this.items, @DecimalStringConverter() this.totalAmount = 0}): super._();
  factory _CartDto.fromJson(Map<String, dynamic> json) => _$CartDtoFromJson(json);

@override final  String id;
@override final  String studentId;
@override final  List<CartItemDto>? items;
@override@JsonKey()@DecimalStringConverter() final  double totalAmount;

/// Create a copy of CartDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartDtoCopyWith<_CartDto> get copyWith => __$CartDtoCopyWithImpl<_CartDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CartDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartDto&&(identical(other.id, id) || other.id == id)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,studentId,const DeepCollectionEquality().hash(items),totalAmount);

@override
String toString() {
  return 'CartDto(id: $id, studentId: $studentId, items: $items, totalAmount: $totalAmount)';
}


}

/// @nodoc
abstract mixin class _$CartDtoCopyWith<$Res> implements $CartDtoCopyWith<$Res> {
  factory _$CartDtoCopyWith(_CartDto value, $Res Function(_CartDto) _then) = __$CartDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String studentId, List<CartItemDto>? items,@DecimalStringConverter() double totalAmount
});




}
/// @nodoc
class __$CartDtoCopyWithImpl<$Res>
    implements _$CartDtoCopyWith<$Res> {
  __$CartDtoCopyWithImpl(this._self, this._then);

  final _CartDto _self;
  final $Res Function(_CartDto) _then;

/// Create a copy of CartDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? studentId = null,Object? items = freezed,Object? totalAmount = null,}) {
  return _then(_CartDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,items: freezed == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CartItemDto>?,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
