// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ebook_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EbookPage {

 int get pageNumber; String get url;
/// Create a copy of EbookPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EbookPageCopyWith<EbookPage> get copyWith => _$EbookPageCopyWithImpl<EbookPage>(this as EbookPage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EbookPage&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,pageNumber,url);

@override
String toString() {
  return 'EbookPage(pageNumber: $pageNumber, url: $url)';
}


}

/// @nodoc
abstract mixin class $EbookPageCopyWith<$Res>  {
  factory $EbookPageCopyWith(EbookPage value, $Res Function(EbookPage) _then) = _$EbookPageCopyWithImpl;
@useResult
$Res call({
 int pageNumber, String url
});




}
/// @nodoc
class _$EbookPageCopyWithImpl<$Res>
    implements $EbookPageCopyWith<$Res> {
  _$EbookPageCopyWithImpl(this._self, this._then);

  final EbookPage _self;
  final $Res Function(EbookPage) _then;

/// Create a copy of EbookPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pageNumber = null,Object? url = null,}) {
  return _then(_self.copyWith(
pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EbookPage].
extension EbookPagePatterns on EbookPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EbookPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EbookPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EbookPage value)  $default,){
final _that = this;
switch (_that) {
case _EbookPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EbookPage value)?  $default,){
final _that = this;
switch (_that) {
case _EbookPage() when $default != null:
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
case _EbookPage() when $default != null:
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
case _EbookPage():
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
case _EbookPage() when $default != null:
return $default(_that.pageNumber,_that.url);case _:
  return null;

}
}

}

/// @nodoc


class _EbookPage implements EbookPage {
  const _EbookPage({required this.pageNumber, required this.url});
  

@override final  int pageNumber;
@override final  String url;

/// Create a copy of EbookPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EbookPageCopyWith<_EbookPage> get copyWith => __$EbookPageCopyWithImpl<_EbookPage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EbookPage&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,pageNumber,url);

@override
String toString() {
  return 'EbookPage(pageNumber: $pageNumber, url: $url)';
}


}

/// @nodoc
abstract mixin class _$EbookPageCopyWith<$Res> implements $EbookPageCopyWith<$Res> {
  factory _$EbookPageCopyWith(_EbookPage value, $Res Function(_EbookPage) _then) = __$EbookPageCopyWithImpl;
@override @useResult
$Res call({
 int pageNumber, String url
});




}
/// @nodoc
class __$EbookPageCopyWithImpl<$Res>
    implements _$EbookPageCopyWith<$Res> {
  __$EbookPageCopyWithImpl(this._self, this._then);

  final _EbookPage _self;
  final $Res Function(_EbookPage) _then;

/// Create a copy of EbookPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pageNumber = null,Object? url = null,}) {
  return _then(_EbookPage(
pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$EbookPageWindow {

 List<EbookPage> get pages; int get expiresInSeconds;
/// Create a copy of EbookPageWindow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EbookPageWindowCopyWith<EbookPageWindow> get copyWith => _$EbookPageWindowCopyWithImpl<EbookPageWindow>(this as EbookPageWindow, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EbookPageWindow&&const DeepCollectionEquality().equals(other.pages, pages)&&(identical(other.expiresInSeconds, expiresInSeconds) || other.expiresInSeconds == expiresInSeconds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(pages),expiresInSeconds);

@override
String toString() {
  return 'EbookPageWindow(pages: $pages, expiresInSeconds: $expiresInSeconds)';
}


}

/// @nodoc
abstract mixin class $EbookPageWindowCopyWith<$Res>  {
  factory $EbookPageWindowCopyWith(EbookPageWindow value, $Res Function(EbookPageWindow) _then) = _$EbookPageWindowCopyWithImpl;
@useResult
$Res call({
 List<EbookPage> pages, int expiresInSeconds
});




}
/// @nodoc
class _$EbookPageWindowCopyWithImpl<$Res>
    implements $EbookPageWindowCopyWith<$Res> {
  _$EbookPageWindowCopyWithImpl(this._self, this._then);

  final EbookPageWindow _self;
  final $Res Function(EbookPageWindow) _then;

/// Create a copy of EbookPageWindow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pages = null,Object? expiresInSeconds = null,}) {
  return _then(_self.copyWith(
pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as List<EbookPage>,expiresInSeconds: null == expiresInSeconds ? _self.expiresInSeconds : expiresInSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EbookPageWindow].
extension EbookPageWindowPatterns on EbookPageWindow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EbookPageWindow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EbookPageWindow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EbookPageWindow value)  $default,){
final _that = this;
switch (_that) {
case _EbookPageWindow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EbookPageWindow value)?  $default,){
final _that = this;
switch (_that) {
case _EbookPageWindow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<EbookPage> pages,  int expiresInSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EbookPageWindow() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<EbookPage> pages,  int expiresInSeconds)  $default,) {final _that = this;
switch (_that) {
case _EbookPageWindow():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<EbookPage> pages,  int expiresInSeconds)?  $default,) {final _that = this;
switch (_that) {
case _EbookPageWindow() when $default != null:
return $default(_that.pages,_that.expiresInSeconds);case _:
  return null;

}
}

}

/// @nodoc


class _EbookPageWindow implements EbookPageWindow {
  const _EbookPageWindow({required this.pages, required this.expiresInSeconds});
  

@override final  List<EbookPage> pages;
@override final  int expiresInSeconds;

/// Create a copy of EbookPageWindow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EbookPageWindowCopyWith<_EbookPageWindow> get copyWith => __$EbookPageWindowCopyWithImpl<_EbookPageWindow>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EbookPageWindow&&const DeepCollectionEquality().equals(other.pages, pages)&&(identical(other.expiresInSeconds, expiresInSeconds) || other.expiresInSeconds == expiresInSeconds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(pages),expiresInSeconds);

@override
String toString() {
  return 'EbookPageWindow(pages: $pages, expiresInSeconds: $expiresInSeconds)';
}


}

/// @nodoc
abstract mixin class _$EbookPageWindowCopyWith<$Res> implements $EbookPageWindowCopyWith<$Res> {
  factory _$EbookPageWindowCopyWith(_EbookPageWindow value, $Res Function(_EbookPageWindow) _then) = __$EbookPageWindowCopyWithImpl;
@override @useResult
$Res call({
 List<EbookPage> pages, int expiresInSeconds
});




}
/// @nodoc
class __$EbookPageWindowCopyWithImpl<$Res>
    implements _$EbookPageWindowCopyWith<$Res> {
  __$EbookPageWindowCopyWithImpl(this._self, this._then);

  final _EbookPageWindow _self;
  final $Res Function(_EbookPageWindow) _then;

/// Create a copy of EbookPageWindow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pages = null,Object? expiresInSeconds = null,}) {
  return _then(_EbookPageWindow(
pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as List<EbookPage>,expiresInSeconds: null == expiresInSeconds ? _self.expiresInSeconds : expiresInSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
