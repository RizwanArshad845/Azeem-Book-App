// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ebook_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EbookDto {

 String get subjectId; String get status; int? get pageCount;
/// Create a copy of EbookDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EbookDtoCopyWith<EbookDto> get copyWith => _$EbookDtoCopyWithImpl<EbookDto>(this as EbookDto, _$identity);

  /// Serializes this EbookDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EbookDto&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.status, status) || other.status == status)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subjectId,status,pageCount);

@override
String toString() {
  return 'EbookDto(subjectId: $subjectId, status: $status, pageCount: $pageCount)';
}


}

/// @nodoc
abstract mixin class $EbookDtoCopyWith<$Res>  {
  factory $EbookDtoCopyWith(EbookDto value, $Res Function(EbookDto) _then) = _$EbookDtoCopyWithImpl;
@useResult
$Res call({
 String subjectId, String status, int? pageCount
});




}
/// @nodoc
class _$EbookDtoCopyWithImpl<$Res>
    implements $EbookDtoCopyWith<$Res> {
  _$EbookDtoCopyWithImpl(this._self, this._then);

  final EbookDto _self;
  final $Res Function(EbookDto) _then;

/// Create a copy of EbookDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subjectId = null,Object? status = null,Object? pageCount = freezed,}) {
  return _then(_self.copyWith(
subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,pageCount: freezed == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [EbookDto].
extension EbookDtoPatterns on EbookDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EbookDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EbookDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EbookDto value)  $default,){
final _that = this;
switch (_that) {
case _EbookDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EbookDto value)?  $default,){
final _that = this;
switch (_that) {
case _EbookDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String subjectId,  String status,  int? pageCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EbookDto() when $default != null:
return $default(_that.subjectId,_that.status,_that.pageCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String subjectId,  String status,  int? pageCount)  $default,) {final _that = this;
switch (_that) {
case _EbookDto():
return $default(_that.subjectId,_that.status,_that.pageCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String subjectId,  String status,  int? pageCount)?  $default,) {final _that = this;
switch (_that) {
case _EbookDto() when $default != null:
return $default(_that.subjectId,_that.status,_that.pageCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EbookDto extends EbookDto {
  const _EbookDto({required this.subjectId, required this.status, this.pageCount}): super._();
  factory _EbookDto.fromJson(Map<String, dynamic> json) => _$EbookDtoFromJson(json);

@override final  String subjectId;
@override final  String status;
@override final  int? pageCount;

/// Create a copy of EbookDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EbookDtoCopyWith<_EbookDto> get copyWith => __$EbookDtoCopyWithImpl<_EbookDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EbookDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EbookDto&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.status, status) || other.status == status)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subjectId,status,pageCount);

@override
String toString() {
  return 'EbookDto(subjectId: $subjectId, status: $status, pageCount: $pageCount)';
}


}

/// @nodoc
abstract mixin class _$EbookDtoCopyWith<$Res> implements $EbookDtoCopyWith<$Res> {
  factory _$EbookDtoCopyWith(_EbookDto value, $Res Function(_EbookDto) _then) = __$EbookDtoCopyWithImpl;
@override @useResult
$Res call({
 String subjectId, String status, int? pageCount
});




}
/// @nodoc
class __$EbookDtoCopyWithImpl<$Res>
    implements _$EbookDtoCopyWith<$Res> {
  __$EbookDtoCopyWithImpl(this._self, this._then);

  final _EbookDto _self;
  final $Res Function(_EbookDto) _then;

/// Create a copy of EbookDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subjectId = null,Object? status = null,Object? pageCount = freezed,}) {
  return _then(_EbookDto(
subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,pageCount: freezed == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
