// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chapter_score_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChapterScoreResult {

 int get chapter; String get title; double get scorePercent; ScoreBand get band;
/// Create a copy of ChapterScoreResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChapterScoreResultCopyWith<ChapterScoreResult> get copyWith => _$ChapterScoreResultCopyWithImpl<ChapterScoreResult>(this as ChapterScoreResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChapterScoreResult&&(identical(other.chapter, chapter) || other.chapter == chapter)&&(identical(other.title, title) || other.title == title)&&(identical(other.scorePercent, scorePercent) || other.scorePercent == scorePercent)&&(identical(other.band, band) || other.band == band));
}


@override
int get hashCode => Object.hash(runtimeType,chapter,title,scorePercent,band);

@override
String toString() {
  return 'ChapterScoreResult(chapter: $chapter, title: $title, scorePercent: $scorePercent, band: $band)';
}


}

/// @nodoc
abstract mixin class $ChapterScoreResultCopyWith<$Res>  {
  factory $ChapterScoreResultCopyWith(ChapterScoreResult value, $Res Function(ChapterScoreResult) _then) = _$ChapterScoreResultCopyWithImpl;
@useResult
$Res call({
 int chapter, String title, double scorePercent, ScoreBand band
});




}
/// @nodoc
class _$ChapterScoreResultCopyWithImpl<$Res>
    implements $ChapterScoreResultCopyWith<$Res> {
  _$ChapterScoreResultCopyWithImpl(this._self, this._then);

  final ChapterScoreResult _self;
  final $Res Function(ChapterScoreResult) _then;

/// Create a copy of ChapterScoreResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chapter = null,Object? title = null,Object? scorePercent = null,Object? band = null,}) {
  return _then(_self.copyWith(
chapter: null == chapter ? _self.chapter : chapter // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,scorePercent: null == scorePercent ? _self.scorePercent : scorePercent // ignore: cast_nullable_to_non_nullable
as double,band: null == band ? _self.band : band // ignore: cast_nullable_to_non_nullable
as ScoreBand,
  ));
}

}


/// Adds pattern-matching-related methods to [ChapterScoreResult].
extension ChapterScoreResultPatterns on ChapterScoreResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChapterScoreResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChapterScoreResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChapterScoreResult value)  $default,){
final _that = this;
switch (_that) {
case _ChapterScoreResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChapterScoreResult value)?  $default,){
final _that = this;
switch (_that) {
case _ChapterScoreResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int chapter,  String title,  double scorePercent,  ScoreBand band)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChapterScoreResult() when $default != null:
return $default(_that.chapter,_that.title,_that.scorePercent,_that.band);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int chapter,  String title,  double scorePercent,  ScoreBand band)  $default,) {final _that = this;
switch (_that) {
case _ChapterScoreResult():
return $default(_that.chapter,_that.title,_that.scorePercent,_that.band);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int chapter,  String title,  double scorePercent,  ScoreBand band)?  $default,) {final _that = this;
switch (_that) {
case _ChapterScoreResult() when $default != null:
return $default(_that.chapter,_that.title,_that.scorePercent,_that.band);case _:
  return null;

}
}

}

/// @nodoc


class _ChapterScoreResult implements ChapterScoreResult {
  const _ChapterScoreResult({required this.chapter, required this.title, required this.scorePercent, required this.band});
  

@override final  int chapter;
@override final  String title;
@override final  double scorePercent;
@override final  ScoreBand band;

/// Create a copy of ChapterScoreResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChapterScoreResultCopyWith<_ChapterScoreResult> get copyWith => __$ChapterScoreResultCopyWithImpl<_ChapterScoreResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChapterScoreResult&&(identical(other.chapter, chapter) || other.chapter == chapter)&&(identical(other.title, title) || other.title == title)&&(identical(other.scorePercent, scorePercent) || other.scorePercent == scorePercent)&&(identical(other.band, band) || other.band == band));
}


@override
int get hashCode => Object.hash(runtimeType,chapter,title,scorePercent,band);

@override
String toString() {
  return 'ChapterScoreResult(chapter: $chapter, title: $title, scorePercent: $scorePercent, band: $band)';
}


}

/// @nodoc
abstract mixin class _$ChapterScoreResultCopyWith<$Res> implements $ChapterScoreResultCopyWith<$Res> {
  factory _$ChapterScoreResultCopyWith(_ChapterScoreResult value, $Res Function(_ChapterScoreResult) _then) = __$ChapterScoreResultCopyWithImpl;
@override @useResult
$Res call({
 int chapter, String title, double scorePercent, ScoreBand band
});




}
/// @nodoc
class __$ChapterScoreResultCopyWithImpl<$Res>
    implements _$ChapterScoreResultCopyWith<$Res> {
  __$ChapterScoreResultCopyWithImpl(this._self, this._then);

  final _ChapterScoreResult _self;
  final $Res Function(_ChapterScoreResult) _then;

/// Create a copy of ChapterScoreResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chapter = null,Object? title = null,Object? scorePercent = null,Object? band = null,}) {
  return _then(_ChapterScoreResult(
chapter: null == chapter ? _self.chapter : chapter // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,scorePercent: null == scorePercent ? _self.scorePercent : scorePercent // ignore: cast_nullable_to_non_nullable
as double,band: null == band ? _self.band : band // ignore: cast_nullable_to_non_nullable
as ScoreBand,
  ));
}


}

// dart format on
