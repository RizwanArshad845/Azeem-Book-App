// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaymentDto {

 String get id; String get studentId;@DecimalStringConverter() double get amount; PaymentStatus get status; String? get gatewayReference; DateTime get createdAt;
/// Create a copy of PaymentDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentDtoCopyWith<PaymentDto> get copyWith => _$PaymentDtoCopyWithImpl<PaymentDto>(this as PaymentDto, _$identity);

  /// Serializes this PaymentDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentDto&&(identical(other.id, id) || other.id == id)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.status, status) || other.status == status)&&(identical(other.gatewayReference, gatewayReference) || other.gatewayReference == gatewayReference)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,studentId,amount,status,gatewayReference,createdAt);

@override
String toString() {
  return 'PaymentDto(id: $id, studentId: $studentId, amount: $amount, status: $status, gatewayReference: $gatewayReference, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PaymentDtoCopyWith<$Res>  {
  factory $PaymentDtoCopyWith(PaymentDto value, $Res Function(PaymentDto) _then) = _$PaymentDtoCopyWithImpl;
@useResult
$Res call({
 String id, String studentId,@DecimalStringConverter() double amount, PaymentStatus status, String? gatewayReference, DateTime createdAt
});




}
/// @nodoc
class _$PaymentDtoCopyWithImpl<$Res>
    implements $PaymentDtoCopyWith<$Res> {
  _$PaymentDtoCopyWithImpl(this._self, this._then);

  final PaymentDto _self;
  final $Res Function(PaymentDto) _then;

/// Create a copy of PaymentDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? studentId = null,Object? amount = null,Object? status = null,Object? gatewayReference = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,gatewayReference: freezed == gatewayReference ? _self.gatewayReference : gatewayReference // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentDto].
extension PaymentDtoPatterns on PaymentDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentDto value)  $default,){
final _that = this;
switch (_that) {
case _PaymentDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentDto value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String studentId, @DecimalStringConverter()  double amount,  PaymentStatus status,  String? gatewayReference,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentDto() when $default != null:
return $default(_that.id,_that.studentId,_that.amount,_that.status,_that.gatewayReference,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String studentId, @DecimalStringConverter()  double amount,  PaymentStatus status,  String? gatewayReference,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _PaymentDto():
return $default(_that.id,_that.studentId,_that.amount,_that.status,_that.gatewayReference,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String studentId, @DecimalStringConverter()  double amount,  PaymentStatus status,  String? gatewayReference,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PaymentDto() when $default != null:
return $default(_that.id,_that.studentId,_that.amount,_that.status,_that.gatewayReference,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentDto extends PaymentDto {
  const _PaymentDto({required this.id, required this.studentId, @DecimalStringConverter() required this.amount, required this.status, this.gatewayReference, required this.createdAt}): super._();
  factory _PaymentDto.fromJson(Map<String, dynamic> json) => _$PaymentDtoFromJson(json);

@override final  String id;
@override final  String studentId;
@override@DecimalStringConverter() final  double amount;
@override final  PaymentStatus status;
@override final  String? gatewayReference;
@override final  DateTime createdAt;

/// Create a copy of PaymentDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentDtoCopyWith<_PaymentDto> get copyWith => __$PaymentDtoCopyWithImpl<_PaymentDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentDto&&(identical(other.id, id) || other.id == id)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.status, status) || other.status == status)&&(identical(other.gatewayReference, gatewayReference) || other.gatewayReference == gatewayReference)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,studentId,amount,status,gatewayReference,createdAt);

@override
String toString() {
  return 'PaymentDto(id: $id, studentId: $studentId, amount: $amount, status: $status, gatewayReference: $gatewayReference, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PaymentDtoCopyWith<$Res> implements $PaymentDtoCopyWith<$Res> {
  factory _$PaymentDtoCopyWith(_PaymentDto value, $Res Function(_PaymentDto) _then) = __$PaymentDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String studentId,@DecimalStringConverter() double amount, PaymentStatus status, String? gatewayReference, DateTime createdAt
});




}
/// @nodoc
class __$PaymentDtoCopyWithImpl<$Res>
    implements _$PaymentDtoCopyWith<$Res> {
  __$PaymentDtoCopyWithImpl(this._self, this._then);

  final _PaymentDto _self;
  final $Res Function(_PaymentDto) _then;

/// Create a copy of PaymentDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? studentId = null,Object? amount = null,Object? status = null,Object? gatewayReference = freezed,Object? createdAt = null,}) {
  return _then(_PaymentDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,gatewayReference: freezed == gatewayReference ? _self.gatewayReference : gatewayReference // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
