// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'self_assessment_ratings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SelfAssessmentRatings {

 Map<int, int> get ratingsByChapter;
/// Create a copy of SelfAssessmentRatings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelfAssessmentRatingsCopyWith<SelfAssessmentRatings> get copyWith => _$SelfAssessmentRatingsCopyWithImpl<SelfAssessmentRatings>(this as SelfAssessmentRatings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelfAssessmentRatings&&const DeepCollectionEquality().equals(other.ratingsByChapter, ratingsByChapter));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(ratingsByChapter));

@override
String toString() {
  return 'SelfAssessmentRatings(ratingsByChapter: $ratingsByChapter)';
}


}

/// @nodoc
abstract mixin class $SelfAssessmentRatingsCopyWith<$Res>  {
  factory $SelfAssessmentRatingsCopyWith(SelfAssessmentRatings value, $Res Function(SelfAssessmentRatings) _then) = _$SelfAssessmentRatingsCopyWithImpl;
@useResult
$Res call({
 Map<int, int> ratingsByChapter
});




}
/// @nodoc
class _$SelfAssessmentRatingsCopyWithImpl<$Res>
    implements $SelfAssessmentRatingsCopyWith<$Res> {
  _$SelfAssessmentRatingsCopyWithImpl(this._self, this._then);

  final SelfAssessmentRatings _self;
  final $Res Function(SelfAssessmentRatings) _then;

/// Create a copy of SelfAssessmentRatings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ratingsByChapter = null,}) {
  return _then(_self.copyWith(
ratingsByChapter: null == ratingsByChapter ? _self.ratingsByChapter : ratingsByChapter // ignore: cast_nullable_to_non_nullable
as Map<int, int>,
  ));
}

}


/// Adds pattern-matching-related methods to [SelfAssessmentRatings].
extension SelfAssessmentRatingsPatterns on SelfAssessmentRatings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SelfAssessmentRatings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SelfAssessmentRatings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SelfAssessmentRatings value)  $default,){
final _that = this;
switch (_that) {
case _SelfAssessmentRatings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SelfAssessmentRatings value)?  $default,){
final _that = this;
switch (_that) {
case _SelfAssessmentRatings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<int, int> ratingsByChapter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SelfAssessmentRatings() when $default != null:
return $default(_that.ratingsByChapter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<int, int> ratingsByChapter)  $default,) {final _that = this;
switch (_that) {
case _SelfAssessmentRatings():
return $default(_that.ratingsByChapter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<int, int> ratingsByChapter)?  $default,) {final _that = this;
switch (_that) {
case _SelfAssessmentRatings() when $default != null:
return $default(_that.ratingsByChapter);case _:
  return null;

}
}

}

/// @nodoc


class _SelfAssessmentRatings extends SelfAssessmentRatings {
  const _SelfAssessmentRatings({required this.ratingsByChapter}): super._();
  

@override final  Map<int, int> ratingsByChapter;

/// Create a copy of SelfAssessmentRatings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelfAssessmentRatingsCopyWith<_SelfAssessmentRatings> get copyWith => __$SelfAssessmentRatingsCopyWithImpl<_SelfAssessmentRatings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelfAssessmentRatings&&const DeepCollectionEquality().equals(other.ratingsByChapter, ratingsByChapter));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(ratingsByChapter));

@override
String toString() {
  return 'SelfAssessmentRatings(ratingsByChapter: $ratingsByChapter)';
}


}

/// @nodoc
abstract mixin class _$SelfAssessmentRatingsCopyWith<$Res> implements $SelfAssessmentRatingsCopyWith<$Res> {
  factory _$SelfAssessmentRatingsCopyWith(_SelfAssessmentRatings value, $Res Function(_SelfAssessmentRatings) _then) = __$SelfAssessmentRatingsCopyWithImpl;
@override @useResult
$Res call({
 Map<int, int> ratingsByChapter
});




}
/// @nodoc
class __$SelfAssessmentRatingsCopyWithImpl<$Res>
    implements _$SelfAssessmentRatingsCopyWith<$Res> {
  __$SelfAssessmentRatingsCopyWithImpl(this._self, this._then);

  final _SelfAssessmentRatings _self;
  final $Res Function(_SelfAssessmentRatings) _then;

/// Create a copy of SelfAssessmentRatings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ratingsByChapter = null,}) {
  return _then(_SelfAssessmentRatings(
ratingsByChapter: null == ratingsByChapter ? _self.ratingsByChapter : ratingsByChapter // ignore: cast_nullable_to_non_nullable
as Map<int, int>,
  ));
}


}

// dart format on
