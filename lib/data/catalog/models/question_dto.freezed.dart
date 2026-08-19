// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuestionDto {

 String get id; String get testId; String get chapterId; QuestionType get type; String get questionText; List<String>? get options; int? get correctOptionIndex; String? get expectedAnswer;
/// Create a copy of QuestionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionDtoCopyWith<QuestionDto> get copyWith => _$QuestionDtoCopyWithImpl<QuestionDto>(this as QuestionDto, _$identity);

  /// Serializes this QuestionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.testId, testId) || other.testId == testId)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.type, type) || other.type == type)&&(identical(other.questionText, questionText) || other.questionText == questionText)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.correctOptionIndex, correctOptionIndex) || other.correctOptionIndex == correctOptionIndex)&&(identical(other.expectedAnswer, expectedAnswer) || other.expectedAnswer == expectedAnswer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,testId,chapterId,type,questionText,const DeepCollectionEquality().hash(options),correctOptionIndex,expectedAnswer);

@override
String toString() {
  return 'QuestionDto(id: $id, testId: $testId, chapterId: $chapterId, type: $type, questionText: $questionText, options: $options, correctOptionIndex: $correctOptionIndex, expectedAnswer: $expectedAnswer)';
}


}

/// @nodoc
abstract mixin class $QuestionDtoCopyWith<$Res>  {
  factory $QuestionDtoCopyWith(QuestionDto value, $Res Function(QuestionDto) _then) = _$QuestionDtoCopyWithImpl;
@useResult
$Res call({
 String id, String testId, String chapterId, QuestionType type, String questionText, List<String>? options, int? correctOptionIndex, String? expectedAnswer
});




}
/// @nodoc
class _$QuestionDtoCopyWithImpl<$Res>
    implements $QuestionDtoCopyWith<$Res> {
  _$QuestionDtoCopyWithImpl(this._self, this._then);

  final QuestionDto _self;
  final $Res Function(QuestionDto) _then;

/// Create a copy of QuestionDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? testId = null,Object? chapterId = null,Object? type = null,Object? questionText = null,Object? options = freezed,Object? correctOptionIndex = freezed,Object? expectedAnswer = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,testId: null == testId ? _self.testId : testId // ignore: cast_nullable_to_non_nullable
as String,chapterId: null == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as QuestionType,questionText: null == questionText ? _self.questionText : questionText // ignore: cast_nullable_to_non_nullable
as String,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,correctOptionIndex: freezed == correctOptionIndex ? _self.correctOptionIndex : correctOptionIndex // ignore: cast_nullable_to_non_nullable
as int?,expectedAnswer: freezed == expectedAnswer ? _self.expectedAnswer : expectedAnswer // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestionDto].
extension QuestionDtoPatterns on QuestionDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionDto value)  $default,){
final _that = this;
switch (_that) {
case _QuestionDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionDto value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String testId,  String chapterId,  QuestionType type,  String questionText,  List<String>? options,  int? correctOptionIndex,  String? expectedAnswer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionDto() when $default != null:
return $default(_that.id,_that.testId,_that.chapterId,_that.type,_that.questionText,_that.options,_that.correctOptionIndex,_that.expectedAnswer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String testId,  String chapterId,  QuestionType type,  String questionText,  List<String>? options,  int? correctOptionIndex,  String? expectedAnswer)  $default,) {final _that = this;
switch (_that) {
case _QuestionDto():
return $default(_that.id,_that.testId,_that.chapterId,_that.type,_that.questionText,_that.options,_that.correctOptionIndex,_that.expectedAnswer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String testId,  String chapterId,  QuestionType type,  String questionText,  List<String>? options,  int? correctOptionIndex,  String? expectedAnswer)?  $default,) {final _that = this;
switch (_that) {
case _QuestionDto() when $default != null:
return $default(_that.id,_that.testId,_that.chapterId,_that.type,_that.questionText,_that.options,_that.correctOptionIndex,_that.expectedAnswer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuestionDto extends QuestionDto {
  const _QuestionDto({required this.id, required this.testId, required this.chapterId, required this.type, required this.questionText, this.options, this.correctOptionIndex, this.expectedAnswer}): super._();
  factory _QuestionDto.fromJson(Map<String, dynamic> json) => _$QuestionDtoFromJson(json);

@override final  String id;
@override final  String testId;
@override final  String chapterId;
@override final  QuestionType type;
@override final  String questionText;
@override final  List<String>? options;
@override final  int? correctOptionIndex;
@override final  String? expectedAnswer;

/// Create a copy of QuestionDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionDtoCopyWith<_QuestionDto> get copyWith => __$QuestionDtoCopyWithImpl<_QuestionDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.testId, testId) || other.testId == testId)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.type, type) || other.type == type)&&(identical(other.questionText, questionText) || other.questionText == questionText)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.correctOptionIndex, correctOptionIndex) || other.correctOptionIndex == correctOptionIndex)&&(identical(other.expectedAnswer, expectedAnswer) || other.expectedAnswer == expectedAnswer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,testId,chapterId,type,questionText,const DeepCollectionEquality().hash(options),correctOptionIndex,expectedAnswer);

@override
String toString() {
  return 'QuestionDto(id: $id, testId: $testId, chapterId: $chapterId, type: $type, questionText: $questionText, options: $options, correctOptionIndex: $correctOptionIndex, expectedAnswer: $expectedAnswer)';
}


}

/// @nodoc
abstract mixin class _$QuestionDtoCopyWith<$Res> implements $QuestionDtoCopyWith<$Res> {
  factory _$QuestionDtoCopyWith(_QuestionDto value, $Res Function(_QuestionDto) _then) = __$QuestionDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String testId, String chapterId, QuestionType type, String questionText, List<String>? options, int? correctOptionIndex, String? expectedAnswer
});




}
/// @nodoc
class __$QuestionDtoCopyWithImpl<$Res>
    implements _$QuestionDtoCopyWith<$Res> {
  __$QuestionDtoCopyWithImpl(this._self, this._then);

  final _QuestionDto _self;
  final $Res Function(_QuestionDto) _then;

/// Create a copy of QuestionDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? testId = null,Object? chapterId = null,Object? type = null,Object? questionText = null,Object? options = freezed,Object? correctOptionIndex = freezed,Object? expectedAnswer = freezed,}) {
  return _then(_QuestionDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,testId: null == testId ? _self.testId : testId // ignore: cast_nullable_to_non_nullable
as String,chapterId: null == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as QuestionType,questionText: null == questionText ? _self.questionText : questionText // ignore: cast_nullable_to_non_nullable
as String,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,correctOptionIndex: freezed == correctOptionIndex ? _self.correctOptionIndex : correctOptionIndex // ignore: cast_nullable_to_non_nullable
as int?,expectedAnswer: freezed == expectedAnswer ? _self.expectedAnswer : expectedAnswer // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
