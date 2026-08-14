// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mcq_question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$McqQuestion {

 String get id; int get chapter; String get question; List<String> get options; int get correctIndex;
/// Create a copy of McqQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$McqQuestionCopyWith<McqQuestion> get copyWith => _$McqQuestionCopyWithImpl<McqQuestion>(this as McqQuestion, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is McqQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.chapter, chapter) || other.chapter == chapter)&&(identical(other.question, question) || other.question == question)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.correctIndex, correctIndex) || other.correctIndex == correctIndex));
}


@override
int get hashCode => Object.hash(runtimeType,id,chapter,question,const DeepCollectionEquality().hash(options),correctIndex);

@override
String toString() {
  return 'McqQuestion(id: $id, chapter: $chapter, question: $question, options: $options, correctIndex: $correctIndex)';
}


}

/// @nodoc
abstract mixin class $McqQuestionCopyWith<$Res>  {
  factory $McqQuestionCopyWith(McqQuestion value, $Res Function(McqQuestion) _then) = _$McqQuestionCopyWithImpl;
@useResult
$Res call({
 String id, int chapter, String question, List<String> options, int correctIndex
});




}
/// @nodoc
class _$McqQuestionCopyWithImpl<$Res>
    implements $McqQuestionCopyWith<$Res> {
  _$McqQuestionCopyWithImpl(this._self, this._then);

  final McqQuestion _self;
  final $Res Function(McqQuestion) _then;

/// Create a copy of McqQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? chapter = null,Object? question = null,Object? options = null,Object? correctIndex = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,chapter: null == chapter ? _self.chapter : chapter // ignore: cast_nullable_to_non_nullable
as int,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,correctIndex: null == correctIndex ? _self.correctIndex : correctIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [McqQuestion].
extension McqQuestionPatterns on McqQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _McqQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _McqQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _McqQuestion value)  $default,){
final _that = this;
switch (_that) {
case _McqQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _McqQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _McqQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int chapter,  String question,  List<String> options,  int correctIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _McqQuestion() when $default != null:
return $default(_that.id,_that.chapter,_that.question,_that.options,_that.correctIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int chapter,  String question,  List<String> options,  int correctIndex)  $default,) {final _that = this;
switch (_that) {
case _McqQuestion():
return $default(_that.id,_that.chapter,_that.question,_that.options,_that.correctIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int chapter,  String question,  List<String> options,  int correctIndex)?  $default,) {final _that = this;
switch (_that) {
case _McqQuestion() when $default != null:
return $default(_that.id,_that.chapter,_that.question,_that.options,_that.correctIndex);case _:
  return null;

}
}

}

/// @nodoc


class _McqQuestion implements McqQuestion {
  const _McqQuestion({required this.id, required this.chapter, required this.question, required this.options, required this.correctIndex});
  

@override final  String id;
@override final  int chapter;
@override final  String question;
@override final  List<String> options;
@override final  int correctIndex;

/// Create a copy of McqQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$McqQuestionCopyWith<_McqQuestion> get copyWith => __$McqQuestionCopyWithImpl<_McqQuestion>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _McqQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.chapter, chapter) || other.chapter == chapter)&&(identical(other.question, question) || other.question == question)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.correctIndex, correctIndex) || other.correctIndex == correctIndex));
}


@override
int get hashCode => Object.hash(runtimeType,id,chapter,question,const DeepCollectionEquality().hash(options),correctIndex);

@override
String toString() {
  return 'McqQuestion(id: $id, chapter: $chapter, question: $question, options: $options, correctIndex: $correctIndex)';
}


}

/// @nodoc
abstract mixin class _$McqQuestionCopyWith<$Res> implements $McqQuestionCopyWith<$Res> {
  factory _$McqQuestionCopyWith(_McqQuestion value, $Res Function(_McqQuestion) _then) = __$McqQuestionCopyWithImpl;
@override @useResult
$Res call({
 String id, int chapter, String question, List<String> options, int correctIndex
});




}
/// @nodoc
class __$McqQuestionCopyWithImpl<$Res>
    implements _$McqQuestionCopyWith<$Res> {
  __$McqQuestionCopyWithImpl(this._self, this._then);

  final _McqQuestion _self;
  final $Res Function(_McqQuestion) _then;

/// Create a copy of McqQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? chapter = null,Object? question = null,Object? options = null,Object? correctIndex = null,}) {
  return _then(_McqQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,chapter: null == chapter ? _self.chapter : chapter // ignore: cast_nullable_to_non_nullable
as int,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,correctIndex: null == correctIndex ? _self.correctIndex : correctIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
