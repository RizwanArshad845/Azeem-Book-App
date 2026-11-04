// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'offline_ebook.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OfflineEbook {

 String get subjectId;/// Subject name captured at download time, so saved books can be listed
/// with no network.
 String get title; int get pageCount; DateTime get downloadedAt;
/// Create a copy of OfflineEbook
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfflineEbookCopyWith<OfflineEbook> get copyWith => _$OfflineEbookCopyWithImpl<OfflineEbook>(this as OfflineEbook, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfflineEbook&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.title, title) || other.title == title)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.downloadedAt, downloadedAt) || other.downloadedAt == downloadedAt));
}


@override
int get hashCode => Object.hash(runtimeType,subjectId,title,pageCount,downloadedAt);

@override
String toString() {
  return 'OfflineEbook(subjectId: $subjectId, title: $title, pageCount: $pageCount, downloadedAt: $downloadedAt)';
}


}

/// @nodoc
abstract mixin class $OfflineEbookCopyWith<$Res>  {
  factory $OfflineEbookCopyWith(OfflineEbook value, $Res Function(OfflineEbook) _then) = _$OfflineEbookCopyWithImpl;
@useResult
$Res call({
 String subjectId, String title, int pageCount, DateTime downloadedAt
});




}
/// @nodoc
class _$OfflineEbookCopyWithImpl<$Res>
    implements $OfflineEbookCopyWith<$Res> {
  _$OfflineEbookCopyWithImpl(this._self, this._then);

  final OfflineEbook _self;
  final $Res Function(OfflineEbook) _then;

/// Create a copy of OfflineEbook
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subjectId = null,Object? title = null,Object? pageCount = null,Object? downloadedAt = null,}) {
  return _then(_self.copyWith(
subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,downloadedAt: null == downloadedAt ? _self.downloadedAt : downloadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [OfflineEbook].
extension OfflineEbookPatterns on OfflineEbook {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OfflineEbook value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OfflineEbook() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OfflineEbook value)  $default,){
final _that = this;
switch (_that) {
case _OfflineEbook():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OfflineEbook value)?  $default,){
final _that = this;
switch (_that) {
case _OfflineEbook() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String subjectId,  String title,  int pageCount,  DateTime downloadedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OfflineEbook() when $default != null:
return $default(_that.subjectId,_that.title,_that.pageCount,_that.downloadedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String subjectId,  String title,  int pageCount,  DateTime downloadedAt)  $default,) {final _that = this;
switch (_that) {
case _OfflineEbook():
return $default(_that.subjectId,_that.title,_that.pageCount,_that.downloadedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String subjectId,  String title,  int pageCount,  DateTime downloadedAt)?  $default,) {final _that = this;
switch (_that) {
case _OfflineEbook() when $default != null:
return $default(_that.subjectId,_that.title,_that.pageCount,_that.downloadedAt);case _:
  return null;

}
}

}

/// @nodoc


class _OfflineEbook implements OfflineEbook {
  const _OfflineEbook({required this.subjectId, this.title = '', required this.pageCount, required this.downloadedAt});
  

@override final  String subjectId;
/// Subject name captured at download time, so saved books can be listed
/// with no network.
@override@JsonKey() final  String title;
@override final  int pageCount;
@override final  DateTime downloadedAt;

/// Create a copy of OfflineEbook
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OfflineEbookCopyWith<_OfflineEbook> get copyWith => __$OfflineEbookCopyWithImpl<_OfflineEbook>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OfflineEbook&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.title, title) || other.title == title)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.downloadedAt, downloadedAt) || other.downloadedAt == downloadedAt));
}


@override
int get hashCode => Object.hash(runtimeType,subjectId,title,pageCount,downloadedAt);

@override
String toString() {
  return 'OfflineEbook(subjectId: $subjectId, title: $title, pageCount: $pageCount, downloadedAt: $downloadedAt)';
}


}

/// @nodoc
abstract mixin class _$OfflineEbookCopyWith<$Res> implements $OfflineEbookCopyWith<$Res> {
  factory _$OfflineEbookCopyWith(_OfflineEbook value, $Res Function(_OfflineEbook) _then) = __$OfflineEbookCopyWithImpl;
@override @useResult
$Res call({
 String subjectId, String title, int pageCount, DateTime downloadedAt
});




}
/// @nodoc
class __$OfflineEbookCopyWithImpl<$Res>
    implements _$OfflineEbookCopyWith<$Res> {
  __$OfflineEbookCopyWithImpl(this._self, this._then);

  final _OfflineEbook _self;
  final $Res Function(_OfflineEbook) _then;

/// Create a copy of OfflineEbook
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subjectId = null,Object? title = null,Object? pageCount = null,Object? downloadedAt = null,}) {
  return _then(_OfflineEbook(
subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,downloadedAt: null == downloadedAt ? _self.downloadedAt : downloadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
