// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mcq_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$McqDto {

 String get id; int get chapter; String get question; List<String> get options; int get correctIndex;
/// Create a copy of McqDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$McqDtoCopyWith<McqDto> get copyWith => _$McqDtoCopyWithImpl<McqDto>(this as McqDto, _$identity);

  /// Serializes this McqDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is McqDto&&(identical(other.id, id) || other.id == id)&&(identical(other.chapter, chapter) || other.chapter == chapter)&&(identical(other.question, question) || other.question == question)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.correctIndex, correctIndex) || other.correctIndex == correctIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,chapter,question,const DeepCollectionEquality().hash(options),correctIndex);

@override
String toString() {
  return 'McqDto(id: $id, chapter: $chapter, question: $question, options: $options, correctIndex: $correctIndex)';
}


}

/// @nodoc
abstract mixin class $McqDtoCopyWith<$Res>  {
  factory $McqDtoCopyWith(McqDto value, $Res Function(McqDto) _then) = _$McqDtoCopyWithImpl;
@useResult
$Res call({
 String id, int chapter, String question, List<String> options, int correctIndex
});




}
/// @nodoc
class _$McqDtoCopyWithImpl<$Res>
    implements $McqDtoCopyWith<$Res> {
  _$McqDtoCopyWithImpl(this._self, this._then);

  final McqDto _self;
  final $Res Function(McqDto) _then;

/// Create a copy of McqDto
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


/// Adds pattern-matching-related methods to [McqDto].
extension McqDtoPatterns on McqDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _McqDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _McqDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _McqDto value)  $default,){
final _that = this;
switch (_that) {
case _McqDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _McqDto value)?  $default,){
final _that = this;
switch (_that) {
case _McqDto() when $default != null:
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
case _McqDto() when $default != null:
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
case _McqDto():
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
case _McqDto() when $default != null:
return $default(_that.id,_that.chapter,_that.question,_that.options,_that.correctIndex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _McqDto implements McqDto {
  const _McqDto({required this.id, required this.chapter, required this.question, required this.options, required this.correctIndex});
  factory _McqDto.fromJson(Map<String, dynamic> json) => _$McqDtoFromJson(json);

@override final  String id;
@override final  int chapter;
@override final  String question;
@override final  List<String> options;
@override final  int correctIndex;

/// Create a copy of McqDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$McqDtoCopyWith<_McqDto> get copyWith => __$McqDtoCopyWithImpl<_McqDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$McqDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _McqDto&&(identical(other.id, id) || other.id == id)&&(identical(other.chapter, chapter) || other.chapter == chapter)&&(identical(other.question, question) || other.question == question)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.correctIndex, correctIndex) || other.correctIndex == correctIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,chapter,question,const DeepCollectionEquality().hash(options),correctIndex);

@override
String toString() {
  return 'McqDto(id: $id, chapter: $chapter, question: $question, options: $options, correctIndex: $correctIndex)';
}


}

/// @nodoc
abstract mixin class _$McqDtoCopyWith<$Res> implements $McqDtoCopyWith<$Res> {
  factory _$McqDtoCopyWith(_McqDto value, $Res Function(_McqDto) _then) = __$McqDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, int chapter, String question, List<String> options, int correctIndex
});




}
/// @nodoc
class __$McqDtoCopyWithImpl<$Res>
    implements _$McqDtoCopyWith<$Res> {
  __$McqDtoCopyWithImpl(this._self, this._then);

  final _McqDto _self;
  final $Res Function(_McqDto) _then;

/// Create a copy of McqDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? chapter = null,Object? question = null,Object? options = null,Object? correctIndex = null,}) {
  return _then(_McqDto(
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
