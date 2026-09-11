// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ebook_page_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EbookPageDto {

 int get pageNumber; String get url;
/// Create a copy of EbookPageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EbookPageDtoCopyWith<EbookPageDto> get copyWith => _$EbookPageDtoCopyWithImpl<EbookPageDto>(this as EbookPageDto, _$identity);

  /// Serializes this EbookPageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EbookPageDto&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pageNumber,url);

@override
String toString() {
  return 'EbookPageDto(pageNumber: $pageNumber, url: $url)';
}


}

/// @nodoc
abstract mixin class $EbookPageDtoCopyWith<$Res>  {
  factory $EbookPageDtoCopyWith(EbookPageDto value, $Res Function(EbookPageDto) _then) = _$EbookPageDtoCopyWithImpl;
@useResult
$Res call({
 int pageNumber, String url
});




}
/// @nodoc
class _$EbookPageDtoCopyWithImpl<$Res>
    implements $EbookPageDtoCopyWith<$Res> {
  _$EbookPageDtoCopyWithImpl(this._self, this._then);

  final EbookPageDto _self;
  final $Res Function(EbookPageDto) _then;

/// Create a copy of EbookPageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pageNumber = null,Object? url = null,}) {
  return _then(_self.copyWith(
pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EbookPageDto].
extension EbookPageDtoPatterns on EbookPageDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EbookPageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EbookPageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EbookPageDto value)  $default,){
final _that = this;
switch (_that) {
case _EbookPageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EbookPageDto value)?  $default,){
final _that = this;
switch (_that) {
case _EbookPageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int pageNumber,  String url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EbookPageDto() when $default != null:
return $default(_that.pageNumber,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int pageNumber,  String url)  $default,) {final _that = this;
switch (_that) {
case _EbookPageDto():
return $default(_that.pageNumber,_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int pageNumber,  String url)?  $default,) {final _that = this;
switch (_that) {
case _EbookPageDto() when $default != null:
return $default(_that.pageNumber,_that.url);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EbookPageDto extends EbookPageDto {
  const _EbookPageDto({required this.pageNumber, required this.url}): super._();
  factory _EbookPageDto.fromJson(Map<String, dynamic> json) => _$EbookPageDtoFromJson(json);

@override final  int pageNumber;
@override final  String url;

/// Create a copy of EbookPageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EbookPageDtoCopyWith<_EbookPageDto> get copyWith => __$EbookPageDtoCopyWithImpl<_EbookPageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EbookPageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EbookPageDto&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pageNumber,url);

@override
String toString() {
  return 'EbookPageDto(pageNumber: $pageNumber, url: $url)';
}


}

/// @nodoc
abstract mixin class _$EbookPageDtoCopyWith<$Res> implements $EbookPageDtoCopyWith<$Res> {
  factory _$EbookPageDtoCopyWith(_EbookPageDto value, $Res Function(_EbookPageDto) _then) = __$EbookPageDtoCopyWithImpl;
@override @useResult
$Res call({
 int pageNumber, String url
});




}
/// @nodoc
class __$EbookPageDtoCopyWithImpl<$Res>
    implements _$EbookPageDtoCopyWith<$Res> {
  __$EbookPageDtoCopyWithImpl(this._self, this._then);

  final _EbookPageDto _self;
  final $Res Function(_EbookPageDto) _then;

/// Create a copy of EbookPageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pageNumber = null,Object? url = null,}) {
  return _then(_EbookPageDto(
pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$EbookPagesResponseDto {

 List<EbookPageDto> get pages; int get expiresInSeconds;
/// Create a copy of EbookPagesResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EbookPagesResponseDtoCopyWith<EbookPagesResponseDto> get copyWith => _$EbookPagesResponseDtoCopyWithImpl<EbookPagesResponseDto>(this as EbookPagesResponseDto, _$identity);

  /// Serializes this EbookPagesResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EbookPagesResponseDto&&const DeepCollectionEquality().equals(other.pages, pages)&&(identical(other.expiresInSeconds, expiresInSeconds) || other.expiresInSeconds == expiresInSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(pages),expiresInSeconds);

@override
String toString() {
  return 'EbookPagesResponseDto(pages: $pages, expiresInSeconds: $expiresInSeconds)';
}


}

/// @nodoc
abstract mixin class $EbookPagesResponseDtoCopyWith<$Res>  {
  factory $EbookPagesResponseDtoCopyWith(EbookPagesResponseDto value, $Res Function(EbookPagesResponseDto) _then) = _$EbookPagesResponseDtoCopyWithImpl;
@useResult
$Res call({
 List<EbookPageDto> pages, int expiresInSeconds
});




}
/// @nodoc
class _$EbookPagesResponseDtoCopyWithImpl<$Res>
    implements $EbookPagesResponseDtoCopyWith<$Res> {
  _$EbookPagesResponseDtoCopyWithImpl(this._self, this._then);

  final EbookPagesResponseDto _self;
  final $Res Function(EbookPagesResponseDto) _then;

/// Create a copy of EbookPagesResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pages = null,Object? expiresInSeconds = null,}) {
  return _then(_self.copyWith(
pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as List<EbookPageDto>,expiresInSeconds: null == expiresInSeconds ? _self.expiresInSeconds : expiresInSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EbookPagesResponseDto].
extension EbookPagesResponseDtoPatterns on EbookPagesResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EbookPagesResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EbookPagesResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EbookPagesResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _EbookPagesResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EbookPagesResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _EbookPagesResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<EbookPageDto> pages,  int expiresInSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EbookPagesResponseDto() when $default != null:
return $default(_that.pages,_that.expiresInSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<EbookPageDto> pages,  int expiresInSeconds)  $default,) {final _that = this;
switch (_that) {
case _EbookPagesResponseDto():
return $default(_that.pages,_that.expiresInSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<EbookPageDto> pages,  int expiresInSeconds)?  $default,) {final _that = this;
switch (_that) {
case _EbookPagesResponseDto() when $default != null:
return $default(_that.pages,_that.expiresInSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EbookPagesResponseDto extends EbookPagesResponseDto {
  const _EbookPagesResponseDto({required this.pages, required this.expiresInSeconds}): super._();
  factory _EbookPagesResponseDto.fromJson(Map<String, dynamic> json) => _$EbookPagesResponseDtoFromJson(json);

@override final  List<EbookPageDto> pages;
@override final  int expiresInSeconds;

/// Create a copy of EbookPagesResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EbookPagesResponseDtoCopyWith<_EbookPagesResponseDto> get copyWith => __$EbookPagesResponseDtoCopyWithImpl<_EbookPagesResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EbookPagesResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EbookPagesResponseDto&&const DeepCollectionEquality().equals(other.pages, pages)&&(identical(other.expiresInSeconds, expiresInSeconds) || other.expiresInSeconds == expiresInSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(pages),expiresInSeconds);

@override
String toString() {
  return 'EbookPagesResponseDto(pages: $pages, expiresInSeconds: $expiresInSeconds)';
}


}

/// @nodoc
abstract mixin class _$EbookPagesResponseDtoCopyWith<$Res> implements $EbookPagesResponseDtoCopyWith<$Res> {
  factory _$EbookPagesResponseDtoCopyWith(_EbookPagesResponseDto value, $Res Function(_EbookPagesResponseDto) _then) = __$EbookPagesResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 List<EbookPageDto> pages, int expiresInSeconds
});




}
/// @nodoc
class __$EbookPagesResponseDtoCopyWithImpl<$Res>
    implements _$EbookPagesResponseDtoCopyWith<$Res> {
  __$EbookPagesResponseDtoCopyWithImpl(this._self, this._then);

  final _EbookPagesResponseDto _self;
  final $Res Function(_EbookPagesResponseDto) _then;

/// Create a copy of EbookPagesResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pages = null,Object? expiresInSeconds = null,}) {
  return _then(_EbookPagesResponseDto(
pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as List<EbookPageDto>,expiresInSeconds: null == expiresInSeconds ? _self.expiresInSeconds : expiresInSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
