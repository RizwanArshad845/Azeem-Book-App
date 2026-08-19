// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'earnings_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EarningsRecord {

 String get id; String? get teacherId; String? get salesmanId; String get studentId; double get amount; EarningsTriggerEvent get triggerEvent; DateTime get createdAt;
/// Create a copy of EarningsRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EarningsRecordCopyWith<EarningsRecord> get copyWith => _$EarningsRecordCopyWithImpl<EarningsRecord>(this as EarningsRecord, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EarningsRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId)&&(identical(other.salesmanId, salesmanId) || other.salesmanId == salesmanId)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.triggerEvent, triggerEvent) || other.triggerEvent == triggerEvent)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,teacherId,salesmanId,studentId,amount,triggerEvent,createdAt);

@override
String toString() {
  return 'EarningsRecord(id: $id, teacherId: $teacherId, salesmanId: $salesmanId, studentId: $studentId, amount: $amount, triggerEvent: $triggerEvent, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $EarningsRecordCopyWith<$Res>  {
  factory $EarningsRecordCopyWith(EarningsRecord value, $Res Function(EarningsRecord) _then) = _$EarningsRecordCopyWithImpl;
@useResult
$Res call({
 String id, String? teacherId, String? salesmanId, String studentId, double amount, EarningsTriggerEvent triggerEvent, DateTime createdAt
});




}
/// @nodoc
class _$EarningsRecordCopyWithImpl<$Res>
    implements $EarningsRecordCopyWith<$Res> {
  _$EarningsRecordCopyWithImpl(this._self, this._then);

  final EarningsRecord _self;
  final $Res Function(EarningsRecord) _then;

/// Create a copy of EarningsRecord
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


/// Adds pattern-matching-related methods to [EarningsRecord].
extension EarningsRecordPatterns on EarningsRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EarningsRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EarningsRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EarningsRecord value)  $default,){
final _that = this;
switch (_that) {
case _EarningsRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EarningsRecord value)?  $default,){
final _that = this;
switch (_that) {
case _EarningsRecord() when $default != null:
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
case _EarningsRecord() when $default != null:
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
case _EarningsRecord():
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
case _EarningsRecord() when $default != null:
return $default(_that.id,_that.teacherId,_that.salesmanId,_that.studentId,_that.amount,_that.triggerEvent,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _EarningsRecord implements EarningsRecord {
  const _EarningsRecord({required this.id, this.teacherId, this.salesmanId, required this.studentId, required this.amount, required this.triggerEvent, required this.createdAt});
  

@override final  String id;
@override final  String? teacherId;
@override final  String? salesmanId;
@override final  String studentId;
@override final  double amount;
@override final  EarningsTriggerEvent triggerEvent;
@override final  DateTime createdAt;

/// Create a copy of EarningsRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EarningsRecordCopyWith<_EarningsRecord> get copyWith => __$EarningsRecordCopyWithImpl<_EarningsRecord>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EarningsRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.teacherId, teacherId) || other.teacherId == teacherId)&&(identical(other.salesmanId, salesmanId) || other.salesmanId == salesmanId)&&(identical(other.studentId, studentId) || other.studentId == studentId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.triggerEvent, triggerEvent) || other.triggerEvent == triggerEvent)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,teacherId,salesmanId,studentId,amount,triggerEvent,createdAt);

@override
String toString() {
  return 'EarningsRecord(id: $id, teacherId: $teacherId, salesmanId: $salesmanId, studentId: $studentId, amount: $amount, triggerEvent: $triggerEvent, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$EarningsRecordCopyWith<$Res> implements $EarningsRecordCopyWith<$Res> {
  factory _$EarningsRecordCopyWith(_EarningsRecord value, $Res Function(_EarningsRecord) _then) = __$EarningsRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String? teacherId, String? salesmanId, String studentId, double amount, EarningsTriggerEvent triggerEvent, DateTime createdAt
});




}
/// @nodoc
class __$EarningsRecordCopyWithImpl<$Res>
    implements _$EarningsRecordCopyWith<$Res> {
  __$EarningsRecordCopyWithImpl(this._self, this._then);

  final _EarningsRecord _self;
  final $Res Function(_EarningsRecord) _then;

/// Create a copy of EarningsRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? teacherId = freezed,Object? salesmanId = freezed,Object? studentId = null,Object? amount = null,Object? triggerEvent = null,Object? createdAt = null,}) {
  return _then(_EarningsRecord(
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
