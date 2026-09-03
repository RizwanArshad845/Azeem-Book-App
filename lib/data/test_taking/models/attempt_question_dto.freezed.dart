// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attempt_question_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttemptQuestionDto {

 String get id; QuestionType get type; String get questionText; List<String>? get options; int get marks;
/// Create a copy of AttemptQuestionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttemptQuestionDtoCopyWith<AttemptQuestionDto> get copyWith => _$AttemptQuestionDtoCopyWithImpl<AttemptQuestionDto>(this as AttemptQuestionDto, _$identity);

  /// Serializes this AttemptQuestionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttemptQuestionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.questionText, questionText) || other.questionText == questionText)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.marks, marks) || other.marks == marks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,questionText,const DeepCollectionEquality().hash(options),marks);

@override
String toString() {
  return 'AttemptQuestionDto(id: $id, type: $type, questionText: $questionText, options: $options, marks: $marks)';
}


}

/// @nodoc
abstract mixin class $AttemptQuestionDtoCopyWith<$Res>  {
  factory $AttemptQuestionDtoCopyWith(AttemptQuestionDto value, $Res Function(AttemptQuestionDto) _then) = _$AttemptQuestionDtoCopyWithImpl;
@useResult
$Res call({
 String id, QuestionType type, String questionText, List<String>? options, int marks
});




}
/// @nodoc
class _$AttemptQuestionDtoCopyWithImpl<$Res>
    implements $AttemptQuestionDtoCopyWith<$Res> {
  _$AttemptQuestionDtoCopyWithImpl(this._self, this._then);

  final AttemptQuestionDto _self;
  final $Res Function(AttemptQuestionDto) _then;

/// Create a copy of AttemptQuestionDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? questionText = null,Object? options = freezed,Object? marks = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as QuestionType,questionText: null == questionText ? _self.questionText : questionText // ignore: cast_nullable_to_non_nullable
as String,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,marks: null == marks ? _self.marks : marks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AttemptQuestionDto].
extension AttemptQuestionDtoPatterns on AttemptQuestionDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttemptQuestionDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttemptQuestionDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttemptQuestionDto value)  $default,){
final _that = this;
switch (_that) {
case _AttemptQuestionDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttemptQuestionDto value)?  $default,){
final _that = this;
switch (_that) {
case _AttemptQuestionDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  QuestionType type,  String questionText,  List<String>? options,  int marks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttemptQuestionDto() when $default != null:
return $default(_that.id,_that.type,_that.questionText,_that.options,_that.marks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  QuestionType type,  String questionText,  List<String>? options,  int marks)  $default,) {final _that = this;
switch (_that) {
case _AttemptQuestionDto():
return $default(_that.id,_that.type,_that.questionText,_that.options,_that.marks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  QuestionType type,  String questionText,  List<String>? options,  int marks)?  $default,) {final _that = this;
switch (_that) {
case _AttemptQuestionDto() when $default != null:
return $default(_that.id,_that.type,_that.questionText,_that.options,_that.marks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttemptQuestionDto extends AttemptQuestionDto {
  const _AttemptQuestionDto({required this.id, required this.type, required this.questionText, this.options, this.marks = 1}): super._();
  factory _AttemptQuestionDto.fromJson(Map<String, dynamic> json) => _$AttemptQuestionDtoFromJson(json);

@override final  String id;
@override final  QuestionType type;
@override final  String questionText;
@override final  List<String>? options;
@override@JsonKey() final  int marks;

/// Create a copy of AttemptQuestionDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttemptQuestionDtoCopyWith<_AttemptQuestionDto> get copyWith => __$AttemptQuestionDtoCopyWithImpl<_AttemptQuestionDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttemptQuestionDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttemptQuestionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.questionText, questionText) || other.questionText == questionText)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.marks, marks) || other.marks == marks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,questionText,const DeepCollectionEquality().hash(options),marks);

@override
String toString() {
  return 'AttemptQuestionDto(id: $id, type: $type, questionText: $questionText, options: $options, marks: $marks)';
}


}

/// @nodoc
abstract mixin class _$AttemptQuestionDtoCopyWith<$Res> implements $AttemptQuestionDtoCopyWith<$Res> {
  factory _$AttemptQuestionDtoCopyWith(_AttemptQuestionDto value, $Res Function(_AttemptQuestionDto) _then) = __$AttemptQuestionDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, QuestionType type, String questionText, List<String>? options, int marks
});




}
/// @nodoc
class __$AttemptQuestionDtoCopyWithImpl<$Res>
    implements _$AttemptQuestionDtoCopyWith<$Res> {
  __$AttemptQuestionDtoCopyWithImpl(this._self, this._then);

  final _AttemptQuestionDto _self;
  final $Res Function(_AttemptQuestionDto) _then;

/// Create a copy of AttemptQuestionDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? questionText = null,Object? options = freezed,Object? marks = null,}) {
  return _then(_AttemptQuestionDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as QuestionType,questionText: null == questionText ? _self.questionText : questionText // ignore: cast_nullable_to_non_nullable
as String,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,marks: null == marks ? _self.marks : marks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
