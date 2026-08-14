// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question_bank_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuestionBankDto {

 String get subject; List<ChapterDto> get chapters; List<McqDto> get mcqs; List<ShortQuestionDto> get shortQuestions;
/// Create a copy of QuestionBankDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionBankDtoCopyWith<QuestionBankDto> get copyWith => _$QuestionBankDtoCopyWithImpl<QuestionBankDto>(this as QuestionBankDto, _$identity);

  /// Serializes this QuestionBankDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionBankDto&&(identical(other.subject, subject) || other.subject == subject)&&const DeepCollectionEquality().equals(other.chapters, chapters)&&const DeepCollectionEquality().equals(other.mcqs, mcqs)&&const DeepCollectionEquality().equals(other.shortQuestions, shortQuestions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subject,const DeepCollectionEquality().hash(chapters),const DeepCollectionEquality().hash(mcqs),const DeepCollectionEquality().hash(shortQuestions));

@override
String toString() {
  return 'QuestionBankDto(subject: $subject, chapters: $chapters, mcqs: $mcqs, shortQuestions: $shortQuestions)';
}


}

/// @nodoc
abstract mixin class $QuestionBankDtoCopyWith<$Res>  {
  factory $QuestionBankDtoCopyWith(QuestionBankDto value, $Res Function(QuestionBankDto) _then) = _$QuestionBankDtoCopyWithImpl;
@useResult
$Res call({
 String subject, List<ChapterDto> chapters, List<McqDto> mcqs, List<ShortQuestionDto> shortQuestions
});




}
/// @nodoc
class _$QuestionBankDtoCopyWithImpl<$Res>
    implements $QuestionBankDtoCopyWith<$Res> {
  _$QuestionBankDtoCopyWithImpl(this._self, this._then);

  final QuestionBankDto _self;
  final $Res Function(QuestionBankDto) _then;

/// Create a copy of QuestionBankDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subject = null,Object? chapters = null,Object? mcqs = null,Object? shortQuestions = null,}) {
  return _then(_self.copyWith(
subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,chapters: null == chapters ? _self.chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<ChapterDto>,mcqs: null == mcqs ? _self.mcqs : mcqs // ignore: cast_nullable_to_non_nullable
as List<McqDto>,shortQuestions: null == shortQuestions ? _self.shortQuestions : shortQuestions // ignore: cast_nullable_to_non_nullable
as List<ShortQuestionDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestionBankDto].
extension QuestionBankDtoPatterns on QuestionBankDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionBankDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionBankDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionBankDto value)  $default,){
final _that = this;
switch (_that) {
case _QuestionBankDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionBankDto value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionBankDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String subject,  List<ChapterDto> chapters,  List<McqDto> mcqs,  List<ShortQuestionDto> shortQuestions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionBankDto() when $default != null:
return $default(_that.subject,_that.chapters,_that.mcqs,_that.shortQuestions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String subject,  List<ChapterDto> chapters,  List<McqDto> mcqs,  List<ShortQuestionDto> shortQuestions)  $default,) {final _that = this;
switch (_that) {
case _QuestionBankDto():
return $default(_that.subject,_that.chapters,_that.mcqs,_that.shortQuestions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String subject,  List<ChapterDto> chapters,  List<McqDto> mcqs,  List<ShortQuestionDto> shortQuestions)?  $default,) {final _that = this;
switch (_that) {
case _QuestionBankDto() when $default != null:
return $default(_that.subject,_that.chapters,_that.mcqs,_that.shortQuestions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuestionBankDto implements QuestionBankDto {
  const _QuestionBankDto({required this.subject, required this.chapters, required this.mcqs, required this.shortQuestions});
  factory _QuestionBankDto.fromJson(Map<String, dynamic> json) => _$QuestionBankDtoFromJson(json);

@override final  String subject;
@override final  List<ChapterDto> chapters;
@override final  List<McqDto> mcqs;
@override final  List<ShortQuestionDto> shortQuestions;

/// Create a copy of QuestionBankDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionBankDtoCopyWith<_QuestionBankDto> get copyWith => __$QuestionBankDtoCopyWithImpl<_QuestionBankDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionBankDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionBankDto&&(identical(other.subject, subject) || other.subject == subject)&&const DeepCollectionEquality().equals(other.chapters, chapters)&&const DeepCollectionEquality().equals(other.mcqs, mcqs)&&const DeepCollectionEquality().equals(other.shortQuestions, shortQuestions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subject,const DeepCollectionEquality().hash(chapters),const DeepCollectionEquality().hash(mcqs),const DeepCollectionEquality().hash(shortQuestions));

@override
String toString() {
  return 'QuestionBankDto(subject: $subject, chapters: $chapters, mcqs: $mcqs, shortQuestions: $shortQuestions)';
}


}

/// @nodoc
abstract mixin class _$QuestionBankDtoCopyWith<$Res> implements $QuestionBankDtoCopyWith<$Res> {
  factory _$QuestionBankDtoCopyWith(_QuestionBankDto value, $Res Function(_QuestionBankDto) _then) = __$QuestionBankDtoCopyWithImpl;
@override @useResult
$Res call({
 String subject, List<ChapterDto> chapters, List<McqDto> mcqs, List<ShortQuestionDto> shortQuestions
});




}
/// @nodoc
class __$QuestionBankDtoCopyWithImpl<$Res>
    implements _$QuestionBankDtoCopyWith<$Res> {
  __$QuestionBankDtoCopyWithImpl(this._self, this._then);

  final _QuestionBankDto _self;
  final $Res Function(_QuestionBankDto) _then;

/// Create a copy of QuestionBankDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subject = null,Object? chapters = null,Object? mcqs = null,Object? shortQuestions = null,}) {
  return _then(_QuestionBankDto(
subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,chapters: null == chapters ? _self.chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<ChapterDto>,mcqs: null == mcqs ? _self.mcqs : mcqs // ignore: cast_nullable_to_non_nullable
as List<McqDto>,shortQuestions: null == shortQuestions ? _self.shortQuestions : shortQuestions // ignore: cast_nullable_to_non_nullable
as List<ShortQuestionDto>,
  ));
}


}

// dart format on
