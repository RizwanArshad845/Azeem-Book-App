// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chapter_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChapterDto {

 String get id; String get subjectId; String get title; int get order; bool get isFreeSample; String? get youtubeUrl;
/// Create a copy of ChapterDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChapterDtoCopyWith<ChapterDto> get copyWith => _$ChapterDtoCopyWithImpl<ChapterDto>(this as ChapterDto, _$identity);

  /// Serializes this ChapterDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChapterDto&&(identical(other.id, id) || other.id == id)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.title, title) || other.title == title)&&(identical(other.order, order) || other.order == order)&&(identical(other.isFreeSample, isFreeSample) || other.isFreeSample == isFreeSample)&&(identical(other.youtubeUrl, youtubeUrl) || other.youtubeUrl == youtubeUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,subjectId,title,order,isFreeSample,youtubeUrl);

@override
String toString() {
  return 'ChapterDto(id: $id, subjectId: $subjectId, title: $title, order: $order, isFreeSample: $isFreeSample, youtubeUrl: $youtubeUrl)';
}


}

/// @nodoc
abstract mixin class $ChapterDtoCopyWith<$Res>  {
  factory $ChapterDtoCopyWith(ChapterDto value, $Res Function(ChapterDto) _then) = _$ChapterDtoCopyWithImpl;
@useResult
$Res call({
 String id, String subjectId, String title, int order, bool isFreeSample, String? youtubeUrl
});




}
/// @nodoc
class _$ChapterDtoCopyWithImpl<$Res>
    implements $ChapterDtoCopyWith<$Res> {
  _$ChapterDtoCopyWithImpl(this._self, this._then);

  final ChapterDto _self;
  final $Res Function(ChapterDto) _then;

/// Create a copy of ChapterDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? subjectId = null,Object? title = null,Object? order = null,Object? isFreeSample = null,Object? youtubeUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,isFreeSample: null == isFreeSample ? _self.isFreeSample : isFreeSample // ignore: cast_nullable_to_non_nullable
as bool,youtubeUrl: freezed == youtubeUrl ? _self.youtubeUrl : youtubeUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChapterDto].
extension ChapterDtoPatterns on ChapterDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChapterDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChapterDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChapterDto value)  $default,){
final _that = this;
switch (_that) {
case _ChapterDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChapterDto value)?  $default,){
final _that = this;
switch (_that) {
case _ChapterDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String subjectId,  String title,  int order,  bool isFreeSample,  String? youtubeUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChapterDto() when $default != null:
return $default(_that.id,_that.subjectId,_that.title,_that.order,_that.isFreeSample,_that.youtubeUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String subjectId,  String title,  int order,  bool isFreeSample,  String? youtubeUrl)  $default,) {final _that = this;
switch (_that) {
case _ChapterDto():
return $default(_that.id,_that.subjectId,_that.title,_that.order,_that.isFreeSample,_that.youtubeUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String subjectId,  String title,  int order,  bool isFreeSample,  String? youtubeUrl)?  $default,) {final _that = this;
switch (_that) {
case _ChapterDto() when $default != null:
return $default(_that.id,_that.subjectId,_that.title,_that.order,_that.isFreeSample,_that.youtubeUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChapterDto extends ChapterDto {
  const _ChapterDto({required this.id, required this.subjectId, required this.title, required this.order, this.isFreeSample = false, this.youtubeUrl}): super._();
  factory _ChapterDto.fromJson(Map<String, dynamic> json) => _$ChapterDtoFromJson(json);

@override final  String id;
@override final  String subjectId;
@override final  String title;
@override final  int order;
@override@JsonKey() final  bool isFreeSample;
@override final  String? youtubeUrl;

/// Create a copy of ChapterDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChapterDtoCopyWith<_ChapterDto> get copyWith => __$ChapterDtoCopyWithImpl<_ChapterDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChapterDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChapterDto&&(identical(other.id, id) || other.id == id)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.title, title) || other.title == title)&&(identical(other.order, order) || other.order == order)&&(identical(other.isFreeSample, isFreeSample) || other.isFreeSample == isFreeSample)&&(identical(other.youtubeUrl, youtubeUrl) || other.youtubeUrl == youtubeUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,subjectId,title,order,isFreeSample,youtubeUrl);

@override
String toString() {
  return 'ChapterDto(id: $id, subjectId: $subjectId, title: $title, order: $order, isFreeSample: $isFreeSample, youtubeUrl: $youtubeUrl)';
}


}

/// @nodoc
abstract mixin class _$ChapterDtoCopyWith<$Res> implements $ChapterDtoCopyWith<$Res> {
  factory _$ChapterDtoCopyWith(_ChapterDto value, $Res Function(_ChapterDto) _then) = __$ChapterDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String subjectId, String title, int order, bool isFreeSample, String? youtubeUrl
});




}
/// @nodoc
class __$ChapterDtoCopyWithImpl<$Res>
    implements _$ChapterDtoCopyWith<$Res> {
  __$ChapterDtoCopyWithImpl(this._self, this._then);

  final _ChapterDto _self;
  final $Res Function(_ChapterDto) _then;

/// Create a copy of ChapterDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? subjectId = null,Object? title = null,Object? order = null,Object? isFreeSample = null,Object? youtubeUrl = freezed,}) {
  return _then(_ChapterDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,isFreeSample: null == isFreeSample ? _self.isFreeSample : isFreeSample // ignore: cast_nullable_to_non_nullable
as bool,youtubeUrl: freezed == youtubeUrl ? _self.youtubeUrl : youtubeUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
