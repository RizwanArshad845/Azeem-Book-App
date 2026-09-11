// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ebook.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Ebook {

 String get subjectId; EbookStatus get status; int? get pageCount;
/// Create a copy of Ebook
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EbookCopyWith<Ebook> get copyWith => _$EbookCopyWithImpl<Ebook>(this as Ebook, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Ebook&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.status, status) || other.status == status)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount));
}


@override
int get hashCode => Object.hash(runtimeType,subjectId,status,pageCount);

@override
String toString() {
  return 'Ebook(subjectId: $subjectId, status: $status, pageCount: $pageCount)';
}


}

/// @nodoc
abstract mixin class $EbookCopyWith<$Res>  {
  factory $EbookCopyWith(Ebook value, $Res Function(Ebook) _then) = _$EbookCopyWithImpl;
@useResult
$Res call({
 String subjectId, EbookStatus status, int? pageCount
});




}
/// @nodoc
class _$EbookCopyWithImpl<$Res>
    implements $EbookCopyWith<$Res> {
  _$EbookCopyWithImpl(this._self, this._then);

  final Ebook _self;
  final $Res Function(Ebook) _then;

/// Create a copy of Ebook
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subjectId = null,Object? status = null,Object? pageCount = freezed,}) {
  return _then(_self.copyWith(
subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EbookStatus,pageCount: freezed == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Ebook].
extension EbookPatterns on Ebook {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Ebook value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Ebook() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Ebook value)  $default,){
final _that = this;
switch (_that) {
case _Ebook():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Ebook value)?  $default,){
final _that = this;
switch (_that) {
case _Ebook() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String subjectId,  EbookStatus status,  int? pageCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Ebook() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String subjectId,  EbookStatus status,  int? pageCount)  $default,) {final _that = this;
switch (_that) {
case _Ebook():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String subjectId,  EbookStatus status,  int? pageCount)?  $default,) {final _that = this;
switch (_that) {
case _Ebook() when $default != null:
return $default(_that.subjectId,_that.status,_that.pageCount);case _:
  return null;

}
}

}

/// @nodoc


class _Ebook implements Ebook {
  const _Ebook({required this.subjectId, required this.status, this.pageCount});
  

@override final  String subjectId;
@override final  EbookStatus status;
@override final  int? pageCount;

/// Create a copy of Ebook
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EbookCopyWith<_Ebook> get copyWith => __$EbookCopyWithImpl<_Ebook>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Ebook&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&(identical(other.status, status) || other.status == status)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount));
}


@override
int get hashCode => Object.hash(runtimeType,subjectId,status,pageCount);

@override
String toString() {
  return 'Ebook(subjectId: $subjectId, status: $status, pageCount: $pageCount)';
}


}

/// @nodoc
abstract mixin class _$EbookCopyWith<$Res> implements $EbookCopyWith<$Res> {
  factory _$EbookCopyWith(_Ebook value, $Res Function(_Ebook) _then) = __$EbookCopyWithImpl;
@override @useResult
$Res call({
 String subjectId, EbookStatus status, int? pageCount
});




}
/// @nodoc
class __$EbookCopyWithImpl<$Res>
    implements _$EbookCopyWith<$Res> {
  __$EbookCopyWithImpl(this._self, this._then);

  final _Ebook _self;
  final $Res Function(_Ebook) _then;

/// Create a copy of Ebook
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subjectId = null,Object? status = null,Object? pageCount = freezed,}) {
  return _then(_Ebook(
subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EbookStatus,pageCount: freezed == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
