// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'short_question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ShortQuestion {

 String get id; int get chapter; String get question; String get modelAnswer;
/// Create a copy of ShortQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShortQuestionCopyWith<ShortQuestion> get copyWith => _$ShortQuestionCopyWithImpl<ShortQuestion>(this as ShortQuestion, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShortQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.chapter, chapter) || other.chapter == chapter)&&(identical(other.question, question) || other.question == question)&&(identical(other.modelAnswer, modelAnswer) || other.modelAnswer == modelAnswer));
}


@override
int get hashCode => Object.hash(runtimeType,id,chapter,question,modelAnswer);

@override
String toString() {
  return 'ShortQuestion(id: $id, chapter: $chapter, question: $question, modelAnswer: $modelAnswer)';
}


}

/// @nodoc
abstract mixin class $ShortQuestionCopyWith<$Res>  {
  factory $ShortQuestionCopyWith(ShortQuestion value, $Res Function(ShortQuestion) _then) = _$ShortQuestionCopyWithImpl;
@useResult
$Res call({
 String id, int chapter, String question, String modelAnswer
});




}
/// @nodoc
class _$ShortQuestionCopyWithImpl<$Res>
    implements $ShortQuestionCopyWith<$Res> {
  _$ShortQuestionCopyWithImpl(this._self, this._then);

  final ShortQuestion _self;
  final $Res Function(ShortQuestion) _then;

/// Create a copy of ShortQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? chapter = null,Object? question = null,Object? modelAnswer = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,chapter: null == chapter ? _self.chapter : chapter // ignore: cast_nullable_to_non_nullable
as int,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,modelAnswer: null == modelAnswer ? _self.modelAnswer : modelAnswer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ShortQuestion].
extension ShortQuestionPatterns on ShortQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShortQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShortQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShortQuestion value)  $default,){
final _that = this;
switch (_that) {
case _ShortQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShortQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _ShortQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int chapter,  String question,  String modelAnswer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShortQuestion() when $default != null:
return $default(_that.id,_that.chapter,_that.question,_that.modelAnswer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int chapter,  String question,  String modelAnswer)  $default,) {final _that = this;
switch (_that) {
case _ShortQuestion():
return $default(_that.id,_that.chapter,_that.question,_that.modelAnswer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int chapter,  String question,  String modelAnswer)?  $default,) {final _that = this;
switch (_that) {
case _ShortQuestion() when $default != null:
return $default(_that.id,_that.chapter,_that.question,_that.modelAnswer);case _:
  return null;

}
}

}

/// @nodoc


class _ShortQuestion implements ShortQuestion {
  const _ShortQuestion({required this.id, required this.chapter, required this.question, required this.modelAnswer});
  

@override final  String id;
@override final  int chapter;
@override final  String question;
@override final  String modelAnswer;

/// Create a copy of ShortQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShortQuestionCopyWith<_ShortQuestion> get copyWith => __$ShortQuestionCopyWithImpl<_ShortQuestion>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShortQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.chapter, chapter) || other.chapter == chapter)&&(identical(other.question, question) || other.question == question)&&(identical(other.modelAnswer, modelAnswer) || other.modelAnswer == modelAnswer));
}


@override
int get hashCode => Object.hash(runtimeType,id,chapter,question,modelAnswer);

@override
String toString() {
  return 'ShortQuestion(id: $id, chapter: $chapter, question: $question, modelAnswer: $modelAnswer)';
}


}

/// @nodoc
abstract mixin class _$ShortQuestionCopyWith<$Res> implements $ShortQuestionCopyWith<$Res> {
  factory _$ShortQuestionCopyWith(_ShortQuestion value, $Res Function(_ShortQuestion) _then) = __$ShortQuestionCopyWithImpl;
@override @useResult
$Res call({
 String id, int chapter, String question, String modelAnswer
});




}
/// @nodoc
class __$ShortQuestionCopyWithImpl<$Res>
    implements _$ShortQuestionCopyWith<$Res> {
  __$ShortQuestionCopyWithImpl(this._self, this._then);

  final _ShortQuestion _self;
  final $Res Function(_ShortQuestion) _then;

/// Create a copy of ShortQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? chapter = null,Object? question = null,Object? modelAnswer = null,}) {
  return _then(_ShortQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,chapter: null == chapter ? _self.chapter : chapter // ignore: cast_nullable_to_non_nullable
as int,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,modelAnswer: null == modelAnswer ? _self.modelAnswer : modelAnswer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
