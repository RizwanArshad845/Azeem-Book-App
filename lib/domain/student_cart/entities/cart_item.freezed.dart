// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CartItem {

 String get subjectId; String get subjectName; int get testCount; double get price; double? get discountedPrice;
/// Create a copy of CartItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartItemCopyWith<CartItem> get copyWith => _$CartItemCopyWithImpl<CartItem>(this as CartItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartItem&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&(identical(other.testCount, testCount) || other.testCount == testCount)&&(identical(other.price, price) || other.price == price)&&(identical(other.discountedPrice, discountedPrice) || other.discountedPrice == discountedPrice));
}


@override
int get hashCode => Object.hash(runtimeType,subjectId,subjectName,testCount,price,discountedPrice);

@override
String toString() {
  return 'CartItem(subjectId: $subjectId, subjectName: $subjectName, testCount: $testCount, price: $price, discountedPrice: $discountedPrice)';
}


}

/// @nodoc
abstract mixin class $CartItemCopyWith<$Res>  {
  factory $CartItemCopyWith(CartItem value, $Res Function(CartItem) _then) = _$CartItemCopyWithImpl;
@useResult
$Res call({
 String subjectId, String subjectName, int testCount, double price, double? discountedPrice
});




}
/// @nodoc
class _$CartItemCopyWithImpl<$Res>
    implements $CartItemCopyWith<$Res> {
  _$CartItemCopyWithImpl(this._self, this._then);

  final CartItem _self;
  final $Res Function(CartItem) _then;

/// Create a copy of CartItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subjectId = null,Object? subjectName = null,Object? testCount = null,Object? price = null,Object? discountedPrice = freezed,}) {
  return _then(_self.copyWith(
subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,subjectName: null == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String,testCount: null == testCount ? _self.testCount : testCount // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,discountedPrice: freezed == discountedPrice ? _self.discountedPrice : discountedPrice // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [CartItem].
extension CartItemPatterns on CartItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CartItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CartItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CartItem value)  $default,){
final _that = this;
switch (_that) {
case _CartItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CartItem value)?  $default,){
final _that = this;
switch (_that) {
case _CartItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String subjectId,  String subjectName,  int testCount,  double price,  double? discountedPrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartItem() when $default != null:
return $default(_that.subjectId,_that.subjectName,_that.testCount,_that.price,_that.discountedPrice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String subjectId,  String subjectName,  int testCount,  double price,  double? discountedPrice)  $default,) {final _that = this;
switch (_that) {
case _CartItem():
return $default(_that.subjectId,_that.subjectName,_that.testCount,_that.price,_that.discountedPrice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String subjectId,  String subjectName,  int testCount,  double price,  double? discountedPrice)?  $default,) {final _that = this;
switch (_that) {
case _CartItem() when $default != null:
return $default(_that.subjectId,_that.subjectName,_that.testCount,_that.price,_that.discountedPrice);case _:
  return null;

}
}

}

/// @nodoc


class _CartItem implements CartItem {
  const _CartItem({required this.subjectId, required this.subjectName, required this.testCount, required this.price, this.discountedPrice});
  

@override final  String subjectId;
@override final  String subjectName;
@override final  int testCount;
@override final  double price;
@override final  double? discountedPrice;

/// Create a copy of CartItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartItemCopyWith<_CartItem> get copyWith => __$CartItemCopyWithImpl<_CartItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartItem&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.subjectName, subjectName) || other.subjectName == subjectName)&&(identical(other.testCount, testCount) || other.testCount == testCount)&&(identical(other.price, price) || other.price == price)&&(identical(other.discountedPrice, discountedPrice) || other.discountedPrice == discountedPrice));
}


@override
int get hashCode => Object.hash(runtimeType,subjectId,subjectName,testCount,price,discountedPrice);

@override
String toString() {
  return 'CartItem(subjectId: $subjectId, subjectName: $subjectName, testCount: $testCount, price: $price, discountedPrice: $discountedPrice)';
}


}

/// @nodoc
abstract mixin class _$CartItemCopyWith<$Res> implements $CartItemCopyWith<$Res> {
  factory _$CartItemCopyWith(_CartItem value, $Res Function(_CartItem) _then) = __$CartItemCopyWithImpl;
@override @useResult
$Res call({
 String subjectId, String subjectName, int testCount, double price, double? discountedPrice
});




}
/// @nodoc
class __$CartItemCopyWithImpl<$Res>
    implements _$CartItemCopyWith<$Res> {
  __$CartItemCopyWithImpl(this._self, this._then);

  final _CartItem _self;
  final $Res Function(_CartItem) _then;

/// Create a copy of CartItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subjectId = null,Object? subjectName = null,Object? testCount = null,Object? price = null,Object? discountedPrice = freezed,}) {
  return _then(_CartItem(
subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,subjectName: null == subjectName ? _self.subjectName : subjectName // ignore: cast_nullable_to_non_nullable
as String,testCount: null == testCount ? _self.testCount : testCount // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,discountedPrice: freezed == discountedPrice ? _self.discountedPrice : discountedPrice // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
