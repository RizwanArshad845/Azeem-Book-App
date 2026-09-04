// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CartItemDto {

// Wire shape is `{id, subjectId, price, discountedPrice}`
// (`FRONTEND_INTEGRATION.md` §6.5) — the backend doesn't echo back a
// subject name or test count, so those stay nullable and are resolved
// client-side from the catalog where displayed, same as
// `teacher_profile_view.dart`'s `subjectsById[id]?.name ?? id` pattern.
// `id` is absent from the outgoing add-to-cart request (server-assigned).
 String? get id; String get subjectId; String? get subjectName; int? get testCount;@DecimalStringConverter() double get price;@NullableDecimalStringConverter() double? get discountedPrice;
/// Create a copy of CartItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartItemDtoCopyWith<CartItemDto> get copyWith => _$CartItemDtoCopyWithImpl<CartItemDto>(this as CartItemDto, _$identity);

  /// Serializes this CartItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&(identical(other.testCount, testCount) || other.testCount == testCount)&&(identical(other.price, price) || other.price == price)&&(identical(other.discountedPrice, discountedPrice) || other.discountedPrice == discountedPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,subjectId,subjectName,testCount,price,discountedPrice);

@override
String toString() {
  return 'CartItemDto(id: $id, subjectId: $subjectId, subjectName: $subjectName, testCount: $testCount, price: $price, discountedPrice: $discountedPrice)';
}


}

/// @nodoc
abstract mixin class $CartItemDtoCopyWith<$Res>  {
  factory $CartItemDtoCopyWith(CartItemDto value, $Res Function(CartItemDto) _then) = _$CartItemDtoCopyWithImpl;
@useResult
$Res call({
 String? id, String subjectId, String? subjectName, int? testCount,@DecimalStringConverter() double price,@NullableDecimalStringConverter() double? discountedPrice
});




}
/// @nodoc
class _$CartItemDtoCopyWithImpl<$Res>
    implements $CartItemDtoCopyWith<$Res> {
  _$CartItemDtoCopyWithImpl(this._self, this._then);

  final CartItemDto _self;
  final $Res Function(CartItemDto) _then;

/// Create a copy of CartItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? subjectId = null,Object? subjectName = freezed,Object? testCount = freezed,Object? price = null,Object? discountedPrice = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,subjectName: freezed == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String?,testCount: freezed == testCount ? _self.testCount : testCount // ignore: cast_nullable_to_non_nullable
as int?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,discountedPrice: freezed == discountedPrice ? _self.discountedPrice : discountedPrice // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [CartItemDto].
extension CartItemDtoPatterns on CartItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CartItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CartItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CartItemDto value)  $default,){
final _that = this;
switch (_that) {
case _CartItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CartItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _CartItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String subjectId,  String? subjectName,  int? testCount, @DecimalStringConverter()  double price, @NullableDecimalStringConverter()  double? discountedPrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartItemDto() when $default != null:
return $default(_that.id,_that.subjectId,_that.subjectName,_that.testCount,_that.price,_that.discountedPrice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String subjectId,  String? subjectName,  int? testCount, @DecimalStringConverter()  double price, @NullableDecimalStringConverter()  double? discountedPrice)  $default,) {final _that = this;
switch (_that) {
case _CartItemDto():
return $default(_that.id,_that.subjectId,_that.subjectName,_that.testCount,_that.price,_that.discountedPrice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String subjectId,  String? subjectName,  int? testCount, @DecimalStringConverter()  double price, @NullableDecimalStringConverter()  double? discountedPrice)?  $default,) {final _that = this;
switch (_that) {
case _CartItemDto() when $default != null:
return $default(_that.id,_that.subjectId,_that.subjectName,_that.testCount,_that.price,_that.discountedPrice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CartItemDto extends CartItemDto {
  const _CartItemDto({this.id, required this.subjectId, this.subjectName, this.testCount, @DecimalStringConverter() required this.price, @NullableDecimalStringConverter() this.discountedPrice}): super._();
  factory _CartItemDto.fromJson(Map<String, dynamic> json) => _$CartItemDtoFromJson(json);

// Wire shape is `{id, subjectId, price, discountedPrice}`
// (`FRONTEND_INTEGRATION.md` §6.5) — the backend doesn't echo back a
// subject name or test count, so those stay nullable and are resolved
// client-side from the catalog where displayed, same as
// `teacher_profile_view.dart`'s `subjectsById[id]?.name ?? id` pattern.
// `id` is absent from the outgoing add-to-cart request (server-assigned).
@override final  String? id;
@override final  String subjectId;
@override final  String? subjectName;
@override final  int? testCount;
@override@DecimalStringConverter() final  double price;
@override@NullableDecimalStringConverter() final  double? discountedPrice;

/// Create a copy of CartItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartItemDtoCopyWith<_CartItemDto> get copyWith => __$CartItemDtoCopyWithImpl<_CartItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CartItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&(identical(other.testCount, testCount) || other.testCount == testCount)&&(identical(other.price, price) || other.price == price)&&(identical(other.discountedPrice, discountedPrice) || other.discountedPrice == discountedPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,subjectId,subjectName,testCount,price,discountedPrice);

@override
String toString() {
  return 'CartItemDto(id: $id, subjectId: $subjectId, subjectName: $subjectName, testCount: $testCount, price: $price, discountedPrice: $discountedPrice)';
}


}

/// @nodoc
abstract mixin class _$CartItemDtoCopyWith<$Res> implements $CartItemDtoCopyWith<$Res> {
  factory _$CartItemDtoCopyWith(_CartItemDto value, $Res Function(_CartItemDto) _then) = __$CartItemDtoCopyWithImpl;
@override @useResult
$Res call({
 String? id, String subjectId, String? subjectName, int? testCount,@DecimalStringConverter() double price,@NullableDecimalStringConverter() double? discountedPrice
});




}
/// @nodoc
class __$CartItemDtoCopyWithImpl<$Res>
    implements _$CartItemDtoCopyWith<$Res> {
  __$CartItemDtoCopyWithImpl(this._self, this._then);

  final _CartItemDto _self;
  final $Res Function(_CartItemDto) _then;

/// Create a copy of CartItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? subjectId = null,Object? subjectName = freezed,Object? testCount = freezed,Object? price = null,Object? discountedPrice = freezed,}) {
  return _then(_CartItemDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,subjectName: freezed == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String?,testCount: freezed == testCount ? _self.testCount : testCount // ignore: cast_nullable_to_non_nullable
as int?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,discountedPrice: freezed == discountedPrice ? _self.discountedPrice : discountedPrice // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
