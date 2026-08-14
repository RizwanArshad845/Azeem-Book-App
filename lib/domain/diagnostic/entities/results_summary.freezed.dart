// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'results_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ResultsSummary {

 List<ChapterScoreResult> get chapterScores; double get overallReadinessPercent; double get selfAssessmentPercent; double get testScorePercent;
/// Create a copy of ResultsSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResultsSummaryCopyWith<ResultsSummary> get copyWith => _$ResultsSummaryCopyWithImpl<ResultsSummary>(this as ResultsSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResultsSummary&&const DeepCollectionEquality().equals(other.chapterScores, chapterScores)&&(identical(other.overallReadinessPercent, overallReadinessPercent) || other.overallReadinessPercent == overallReadinessPercent)&&(identical(other.selfAssessmentPercent, selfAssessmentPercent) || other.selfAssessmentPercent == selfAssessmentPercent)&&(identical(other.testScorePercent, testScorePercent) || other.testScorePercent == testScorePercent));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(chapterScores),overallReadinessPercent,selfAssessmentPercent,testScorePercent);

@override
String toString() {
  return 'ResultsSummary(chapterScores: $chapterScores, overallReadinessPercent: $overallReadinessPercent, selfAssessmentPercent: $selfAssessmentPercent, testScorePercent: $testScorePercent)';
}


}

/// @nodoc
abstract mixin class $ResultsSummaryCopyWith<$Res>  {
  factory $ResultsSummaryCopyWith(ResultsSummary value, $Res Function(ResultsSummary) _then) = _$ResultsSummaryCopyWithImpl;
@useResult
$Res call({
 List<ChapterScoreResult> chapterScores, double overallReadinessPercent, double selfAssessmentPercent, double testScorePercent
});




}
/// @nodoc
class _$ResultsSummaryCopyWithImpl<$Res>
    implements $ResultsSummaryCopyWith<$Res> {
  _$ResultsSummaryCopyWithImpl(this._self, this._then);

  final ResultsSummary _self;
  final $Res Function(ResultsSummary) _then;

/// Create a copy of ResultsSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chapterScores = null,Object? overallReadinessPercent = null,Object? selfAssessmentPercent = null,Object? testScorePercent = null,}) {
  return _then(_self.copyWith(
chapterScores: null == chapterScores ? _self.chapterScores : chapterScores // ignore: cast_nullable_to_non_nullable
as List<ChapterScoreResult>,overallReadinessPercent: null == overallReadinessPercent ? _self.overallReadinessPercent : overallReadinessPercent // ignore: cast_nullable_to_non_nullable
as double,selfAssessmentPercent: null == selfAssessmentPercent ? _self.selfAssessmentPercent : selfAssessmentPercent // ignore: cast_nullable_to_non_nullable
as double,testScorePercent: null == testScorePercent ? _self.testScorePercent : testScorePercent // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ResultsSummary].
extension ResultsSummaryPatterns on ResultsSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResultsSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResultsSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResultsSummary value)  $default,){
final _that = this;
switch (_that) {
case _ResultsSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResultsSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ResultsSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ChapterScoreResult> chapterScores,  double overallReadinessPercent,  double selfAssessmentPercent,  double testScorePercent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResultsSummary() when $default != null:
return $default(_that.chapterScores,_that.overallReadinessPercent,_that.selfAssessmentPercent,_that.testScorePercent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ChapterScoreResult> chapterScores,  double overallReadinessPercent,  double selfAssessmentPercent,  double testScorePercent)  $default,) {final _that = this;
switch (_that) {
case _ResultsSummary():
return $default(_that.chapterScores,_that.overallReadinessPercent,_that.selfAssessmentPercent,_that.testScorePercent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ChapterScoreResult> chapterScores,  double overallReadinessPercent,  double selfAssessmentPercent,  double testScorePercent)?  $default,) {final _that = this;
switch (_that) {
case _ResultsSummary() when $default != null:
return $default(_that.chapterScores,_that.overallReadinessPercent,_that.selfAssessmentPercent,_that.testScorePercent);case _:
  return null;

}
}

}

/// @nodoc


class _ResultsSummary implements ResultsSummary {
  const _ResultsSummary({required this.chapterScores, required this.overallReadinessPercent, required this.selfAssessmentPercent, required this.testScorePercent});
  

@override final  List<ChapterScoreResult> chapterScores;
@override final  double overallReadinessPercent;
@override final  double selfAssessmentPercent;
@override final  double testScorePercent;

/// Create a copy of ResultsSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResultsSummaryCopyWith<_ResultsSummary> get copyWith => __$ResultsSummaryCopyWithImpl<_ResultsSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResultsSummary&&const DeepCollectionEquality().equals(other.chapterScores, chapterScores)&&(identical(other.overallReadinessPercent, overallReadinessPercent) || other.overallReadinessPercent == overallReadinessPercent)&&(identical(other.selfAssessmentPercent, selfAssessmentPercent) || other.selfAssessmentPercent == selfAssessmentPercent)&&(identical(other.testScorePercent, testScorePercent) || other.testScorePercent == testScorePercent));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(chapterScores),overallReadinessPercent,selfAssessmentPercent,testScorePercent);

@override
String toString() {
  return 'ResultsSummary(chapterScores: $chapterScores, overallReadinessPercent: $overallReadinessPercent, selfAssessmentPercent: $selfAssessmentPercent, testScorePercent: $testScorePercent)';
}


}

/// @nodoc
abstract mixin class _$ResultsSummaryCopyWith<$Res> implements $ResultsSummaryCopyWith<$Res> {
  factory _$ResultsSummaryCopyWith(_ResultsSummary value, $Res Function(_ResultsSummary) _then) = __$ResultsSummaryCopyWithImpl;
@override @useResult
$Res call({
 List<ChapterScoreResult> chapterScores, double overallReadinessPercent, double selfAssessmentPercent, double testScorePercent
});




}
/// @nodoc
class __$ResultsSummaryCopyWithImpl<$Res>
    implements _$ResultsSummaryCopyWith<$Res> {
  __$ResultsSummaryCopyWithImpl(this._self, this._then);

  final _ResultsSummary _self;
  final $Res Function(_ResultsSummary) _then;

/// Create a copy of ResultsSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chapterScores = null,Object? overallReadinessPercent = null,Object? selfAssessmentPercent = null,Object? testScorePercent = null,}) {
  return _then(_ResultsSummary(
chapterScores: null == chapterScores ? _self.chapterScores : chapterScores // ignore: cast_nullable_to_non_nullable
as List<ChapterScoreResult>,overallReadinessPercent: null == overallReadinessPercent ? _self.overallReadinessPercent : overallReadinessPercent // ignore: cast_nullable_to_non_nullable
as double,selfAssessmentPercent: null == selfAssessmentPercent ? _self.selfAssessmentPercent : selfAssessmentPercent // ignore: cast_nullable_to_non_nullable
as double,testScorePercent: null == testScorePercent ? _self.testScorePercent : testScorePercent // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
