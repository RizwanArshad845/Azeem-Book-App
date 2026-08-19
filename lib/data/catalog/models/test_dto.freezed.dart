// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TestDto {

 String get id; String get title; TestKind get kind; String get boardClassId; String get subjectId; String? get chapterId; bool get isLive; DateTime? get liveDate; bool get isFreeSample; String get createdByAdminId; DateTime get createdAt;
/// Create a copy of TestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TestDtoCopyWith<TestDto> get copyWith => _$TestDtoCopyWithImpl<TestDto>(this as TestDto, _$identity);

  /// Serializes this TestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TestDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.boardClassId, boardClassId) || other.boardClassId == boardClassId)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.isLive, isLive) || other.isLive == isLive)&&(identical(other.liveDate, liveDate) || other.liveDate == liveDate)&&(identical(other.isFreeSample, isFreeSample) || other.isFreeSample == isFreeSample)&&(identical(other.createdByAdminId, createdByAdminId) || other.createdByAdminId == createdByAdminId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,kind,boardClassId,subjectId,chapterId,isLive,liveDate,isFreeSample,createdByAdminId,createdAt);

@override
String toString() {
  return 'TestDto(id: $id, title: $title, kind: $kind, boardClassId: $boardClassId, subjectId: $subjectId, chapterId: $chapterId, isLive: $isLive, liveDate: $liveDate, isFreeSample: $isFreeSample, createdByAdminId: $createdByAdminId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TestDtoCopyWith<$Res>  {
  factory $TestDtoCopyWith(TestDto value, $Res Function(TestDto) _then) = _$TestDtoCopyWithImpl;
@useResult
$Res call({
 String id, String title, TestKind kind, String boardClassId, String subjectId, String? chapterId, bool isLive, DateTime? liveDate, bool isFreeSample, String createdByAdminId, DateTime createdAt
});




}
/// @nodoc
class _$TestDtoCopyWithImpl<$Res>
    implements $TestDtoCopyWith<$Res> {
  _$TestDtoCopyWithImpl(this._self, this._then);

  final TestDto _self;
  final $Res Function(TestDto) _then;

/// Create a copy of TestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? kind = null,Object? boardClassId = null,Object? subjectId = null,Object? chapterId = freezed,Object? isLive = null,Object? liveDate = freezed,Object? isFreeSample = null,Object? createdByAdminId = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TestKind,boardClassId: null == boardClassId ? _self.boardClassId : boardClassId // ignore: cast_nullable_to_non_nullable
as String,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,chapterId: freezed == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as String?,isLive: null == isLive ? _self.isLive : isLive // ignore: cast_nullable_to_non_nullable
as bool,liveDate: freezed == liveDate ? _self.liveDate : liveDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isFreeSample: null == isFreeSample ? _self.isFreeSample : isFreeSample // ignore: cast_nullable_to_non_nullable
as bool,createdByAdminId: null == createdByAdminId ? _self.createdByAdminId : createdByAdminId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TestDto].
extension TestDtoPatterns on TestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TestDto value)  $default,){
final _that = this;
switch (_that) {
case _TestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TestDto value)?  $default,){
final _that = this;
switch (_that) {
case _TestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  TestKind kind,  String boardClassId,  String subjectId,  String? chapterId,  bool isLive,  DateTime? liveDate,  bool isFreeSample,  String createdByAdminId,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TestDto() when $default != null:
return $default(_that.id,_that.title,_that.kind,_that.boardClassId,_that.subjectId,_that.chapterId,_that.isLive,_that.liveDate,_that.isFreeSample,_that.createdByAdminId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  TestKind kind,  String boardClassId,  String subjectId,  String? chapterId,  bool isLive,  DateTime? liveDate,  bool isFreeSample,  String createdByAdminId,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _TestDto():
return $default(_that.id,_that.title,_that.kind,_that.boardClassId,_that.subjectId,_that.chapterId,_that.isLive,_that.liveDate,_that.isFreeSample,_that.createdByAdminId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  TestKind kind,  String boardClassId,  String subjectId,  String? chapterId,  bool isLive,  DateTime? liveDate,  bool isFreeSample,  String createdByAdminId,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _TestDto() when $default != null:
return $default(_that.id,_that.title,_that.kind,_that.boardClassId,_that.subjectId,_that.chapterId,_that.isLive,_that.liveDate,_that.isFreeSample,_that.createdByAdminId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TestDto extends TestDto {
  const _TestDto({required this.id, required this.title, required this.kind, required this.boardClassId, required this.subjectId, this.chapterId, this.isLive = false, this.liveDate, this.isFreeSample = false, required this.createdByAdminId, required this.createdAt}): super._();
  factory _TestDto.fromJson(Map<String, dynamic> json) => _$TestDtoFromJson(json);

@override final  String id;
@override final  String title;
@override final  TestKind kind;
@override final  String boardClassId;
@override final  String subjectId;
@override final  String? chapterId;
@override@JsonKey() final  bool isLive;
@override final  DateTime? liveDate;
@override@JsonKey() final  bool isFreeSample;
@override final  String createdByAdminId;
@override final  DateTime createdAt;

/// Create a copy of TestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TestDtoCopyWith<_TestDto> get copyWith => __$TestDtoCopyWithImpl<_TestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TestDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.boardClassId, boardClassId) || other.boardClassId == boardClassId)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.isLive, isLive) || other.isLive == isLive)&&(identical(other.liveDate, liveDate) || other.liveDate == liveDate)&&(identical(other.isFreeSample, isFreeSample) || other.isFreeSample == isFreeSample)&&(identical(other.createdByAdminId, createdByAdminId) || other.createdByAdminId == createdByAdminId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,kind,boardClassId,subjectId,chapterId,isLive,liveDate,isFreeSample,createdByAdminId,createdAt);

@override
String toString() {
  return 'TestDto(id: $id, title: $title, kind: $kind, boardClassId: $boardClassId, subjectId: $subjectId, chapterId: $chapterId, isLive: $isLive, liveDate: $liveDate, isFreeSample: $isFreeSample, createdByAdminId: $createdByAdminId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TestDtoCopyWith<$Res> implements $TestDtoCopyWith<$Res> {
  factory _$TestDtoCopyWith(_TestDto value, $Res Function(_TestDto) _then) = __$TestDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, TestKind kind, String boardClassId, String subjectId, String? chapterId, bool isLive, DateTime? liveDate, bool isFreeSample, String createdByAdminId, DateTime createdAt
});




}
/// @nodoc
class __$TestDtoCopyWithImpl<$Res>
    implements _$TestDtoCopyWith<$Res> {
  __$TestDtoCopyWithImpl(this._self, this._then);

  final _TestDto _self;
  final $Res Function(_TestDto) _then;

/// Create a copy of TestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? kind = null,Object? boardClassId = null,Object? subjectId = null,Object? chapterId = freezed,Object? isLive = null,Object? liveDate = freezed,Object? isFreeSample = null,Object? createdByAdminId = null,Object? createdAt = null,}) {
  return _then(_TestDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TestKind,boardClassId: null == boardClassId ? _self.boardClassId : boardClassId // ignore: cast_nullable_to_non_nullable
as String,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,chapterId: freezed == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as String?,isLive: null == isLive ? _self.isLive : isLive // ignore: cast_nullable_to_non_nullable
as bool,liveDate: freezed == liveDate ? _self.liveDate : liveDate // ignore: cast_nullable_to_non_nullable
as DateTime?,isFreeSample: null == isFreeSample ? _self.isFreeSample : isFreeSample // ignore: cast_nullable_to_non_nullable
as bool,createdByAdminId: null == createdByAdminId ? _self.createdByAdminId : createdByAdminId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
