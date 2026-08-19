// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'earnings_record_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EarningsRecordDto {

 String get id; String? get teacherId; String? get salesmanId; String get studentId; double get amount; EarningsTriggerEvent get triggerEvent; DateTime get createdAt;
/// Create a copy of EarningsRecordDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EarningsRecordDtoCopyWith<EarningsRecordDto> get copyWith => _$EarningsRecordDtoCopyWithImpl<EarningsRecordDto>(this as EarningsRecordDto, _$identity);

  /// Serializes this EarningsRecordDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EarningsRecordDto&&(identical(other.id, id) || other.id == id)&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId)&&(identical(other.salesmanId, salesmanId) || other.salesmanId == salesmanId)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.triggerEvent, triggerEvent) || other.triggerEvent == triggerEvent)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,teacherId,salesmanId,studentId,amount,triggerEvent,createdAt);

@override
String toString() {
  return 'EarningsRecordDto(id: $id, teacherId: $teacherId, salesmanId: $salesmanId, studentId: $studentId, amount: $amount, triggerEvent: $triggerEvent, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $EarningsRecordDtoCopyWith<$Res>  {
  factory $EarningsRecordDtoCopyWith(EarningsRecordDto value, $Res Function(EarningsRecordDto) _then) = _$EarningsRecordDtoCopyWithImpl;
@useResult
$Res call({
 String id, String? teacherId, String? salesmanId, String studentId, double amount, EarningsTriggerEvent triggerEvent, DateTime createdAt
});




}
/// @nodoc
class _$EarningsRecordDtoCopyWithImpl<$Res>
    implements $EarningsRecordDtoCopyWith<$Res> {
  _$EarningsRecordDtoCopyWithImpl(this._self, this._then);

  final EarningsRecordDto _self;
  final $Res Function(EarningsRecordDto) _then;

/// Create a copy of EarningsRecordDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? teacherId = freezed,Object? salesmanId = freezed,Object? studentId = null,Object? amount = null,Object? triggerEvent = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,teacherId: freezed == teacherId ? _self.teacherId : teacherId // ignore: cast_nullable_to_non_nullable
as String?,salesmanId: freezed == salesmanId ? _self.salesmanId : salesmanId // ignore: cast_nullable_to_non_nullable
as String?,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,triggerEvent: null == triggerEvent ? _self.triggerEvent : triggerEvent // ignore: cast_nullable_to_non_nullable
as EarningsTriggerEvent,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [EarningsRecordDto].
extension EarningsRecordDtoPatterns on EarningsRecordDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EarningsRecordDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EarningsRecordDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EarningsRecordDto value)  $default,){
final _that = this;
switch (_that) {
case _EarningsRecordDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EarningsRecordDto value)?  $default,){
final _that = this;
switch (_that) {
case _EarningsRecordDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? teacherId,  String? salesmanId,  String studentId,  double amount,  EarningsTriggerEvent triggerEvent,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EarningsRecordDto() when $default != null:
return $default(_that.id,_that.teacherId,_that.salesmanId,_that.studentId,_that.amount,_that.triggerEvent,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? teacherId,  String? salesmanId,  String studentId,  double amount,  EarningsTriggerEvent triggerEvent,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _EarningsRecordDto():
return $default(_that.id,_that.teacherId,_that.salesmanId,_that.studentId,_that.amount,_that.triggerEvent,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? teacherId,  String? salesmanId,  String studentId,  double amount,  EarningsTriggerEvent triggerEvent,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _EarningsRecordDto() when $default != null:
return $default(_that.id,_that.teacherId,_that.salesmanId,_that.studentId,_that.amount,_that.triggerEvent,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EarningsRecordDto extends EarningsRecordDto {
  const _EarningsRecordDto({required this.id, this.teacherId, this.salesmanId, required this.studentId, required this.amount, required this.triggerEvent, required this.createdAt}): super._();
  factory _EarningsRecordDto.fromJson(Map<String, dynamic> json) => _$EarningsRecordDtoFromJson(json);

@override final  String id;
@override final  String? teacherId;
@override final  String? salesmanId;
@override final  String studentId;
@override final  double amount;
@override final  EarningsTriggerEvent triggerEvent;
@override final  DateTime createdAt;

/// Create a copy of EarningsRecordDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EarningsRecordDtoCopyWith<_EarningsRecordDto> get copyWith => __$EarningsRecordDtoCopyWithImpl<_EarningsRecordDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EarningsRecordDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EarningsRecordDto&&(identical(other.id, id) || other.id == id)&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId)&&(identical(other.salesmanId, salesmanId) || other.salesmanId == salesmanId)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.triggerEvent, triggerEvent) || other.triggerEvent == triggerEvent)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,teacherId,salesmanId,studentId,amount,triggerEvent,createdAt);

@override
String toString() {
  return 'EarningsRecordDto(id: $id, teacherId: $teacherId, salesmanId: $salesmanId, studentId: $studentId, amount: $amount, triggerEvent: $triggerEvent, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$EarningsRecordDtoCopyWith<$Res> implements $EarningsRecordDtoCopyWith<$Res> {
  factory _$EarningsRecordDtoCopyWith(_EarningsRecordDto value, $Res Function(_EarningsRecordDto) _then) = __$EarningsRecordDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String? teacherId, String? salesmanId, String studentId, double amount, EarningsTriggerEvent triggerEvent, DateTime createdAt
});




}
/// @nodoc
class __$EarningsRecordDtoCopyWithImpl<$Res>
    implements _$EarningsRecordDtoCopyWith<$Res> {
  __$EarningsRecordDtoCopyWithImpl(this._self, this._then);

  final _EarningsRecordDto _self;
  final $Res Function(_EarningsRecordDto) _then;

/// Create a copy of EarningsRecordDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? teacherId = freezed,Object? salesmanId = freezed,Object? studentId = null,Object? amount = null,Object? triggerEvent = null,Object? createdAt = null,}) {
  return _then(_EarningsRecordDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,teacherId: freezed == teacherId ? _self.teacherId : teacherId // ignore: cast_nullable_to_non_nullable
as String?,salesmanId: freezed == salesmanId ? _self.salesmanId : salesmanId // ignore: cast_nullable_to_non_nullable
as String?,studentId: null == studentId ? _self.studentId : studentId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,triggerEvent: null == triggerEvent ? _self.triggerEvent : triggerEvent // ignore: cast_nullable_to_non_nullable
as EarningsTriggerEvent,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
