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

 int get chapter; String get title; int get mcqCount; int get shortCount;
/// Create a copy of ChapterDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChapterDtoCopyWith<ChapterDto> get copyWith => _$ChapterDtoCopyWithImpl<ChapterDto>(this as ChapterDto, _$identity);

  /// Serializes this ChapterDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChapterDto&&(identical(other.chapter, chapter) || other.chapter == chapter)&&(identical(other.title, title) || other.title == title)&&(identical(other.mcqCount, mcqCount) || other.mcqCount == mcqCount)&&(identical(other.shortCount, shortCount) || other.shortCount == shortCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chapter,title,mcqCount,shortCount);

@override
String toString() {
  return 'ChapterDto(chapter: $chapter, title: $title, mcqCount: $mcqCount, shortCount: $shortCount)';
}


}

/// @nodoc
abstract mixin class $ChapterDtoCopyWith<$Res>  {
  factory $ChapterDtoCopyWith(ChapterDto value, $Res Function(ChapterDto) _then) = _$ChapterDtoCopyWithImpl;
@useResult
$Res call({
 int chapter, String title, int mcqCount, int shortCount
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
@pragma('vm:prefer-inline') @override $Res call({Object? chapter = null,Object? title = null,Object? mcqCount = null,Object? shortCount = null,}) {
  return _then(_self.copyWith(
chapter: null == chapter ? _self.chapter : chapter // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,mcqCount: null == mcqCount ? _self.mcqCount : mcqCount // ignore: cast_nullable_to_non_nullable
as int,shortCount: null == shortCount ? _self.shortCount : shortCount // ignore: cast_nullable_to_non_nullable
as int,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int chapter,  String title,  int mcqCount,  int shortCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChapterDto() when $default != null:
return $default(_that.chapter,_that.title,_that.mcqCount,_that.shortCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int chapter,  String title,  int mcqCount,  int shortCount)  $default,) {final _that = this;
switch (_that) {
case _ChapterDto():
return $default(_that.chapter,_that.title,_that.mcqCount,_that.shortCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int chapter,  String title,  int mcqCount,  int shortCount)?  $default,) {final _that = this;
switch (_that) {
case _ChapterDto() when $default != null:
return $default(_that.chapter,_that.title,_that.mcqCount,_that.shortCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChapterDto implements ChapterDto {
  const _ChapterDto({required this.chapter, required this.title, required this.mcqCount, required this.shortCount});
  factory _ChapterDto.fromJson(Map<String, dynamic> json) => _$ChapterDtoFromJson(json);

@override final  int chapter;
@override final  String title;
@override final  int mcqCount;
@override final  int shortCount;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChapterDto&&(identical(other.chapter, chapter) || other.chapter == chapter)&&(identical(other.title, title) || other.title == title)&&(identical(other.mcqCount, mcqCount) || other.mcqCount == mcqCount)&&(identical(other.shortCount, shortCount) || other.shortCount == shortCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chapter,title,mcqCount,shortCount);

@override
String toString() {
  return 'ChapterDto(chapter: $chapter, title: $title, mcqCount: $mcqCount, shortCount: $shortCount)';
}


}

/// @nodoc
abstract mixin class _$ChapterDtoCopyWith<$Res> implements $ChapterDtoCopyWith<$Res> {
  factory _$ChapterDtoCopyWith(_ChapterDto value, $Res Function(_ChapterDto) _then) = __$ChapterDtoCopyWithImpl;
@override @useResult
$Res call({
 int chapter, String title, int mcqCount, int shortCount
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
@override @pragma('vm:prefer-inline') $Res call({Object? chapter = null,Object? title = null,Object? mcqCount = null,Object? shortCount = null,}) {
  return _then(_ChapterDto(
chapter: null == chapter ? _self.chapter : chapter // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,mcqCount: null == mcqCount ? _self.mcqCount : mcqCount // ignore: cast_nullable_to_non_nullable
as int,shortCount: null == shortCount ? _self.shortCount : shortCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
