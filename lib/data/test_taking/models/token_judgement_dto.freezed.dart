// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'token_judgement_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TokenJudgementDto {

 String get token;// Wire key is `usedMeaningfully`, not `used` — confirmed against the
// real backend payload (every `tokenJudgements` entry has
// `usedMeaningfully`, never a `used` key at all). Kept as `used` on the
// Dart side for a cleaner call-site name; only the JSON key differs.
@JsonKey(name: 'usedMeaningfully') bool get used;
/// Create a copy of TokenJudgementDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TokenJudgementDtoCopyWith<TokenJudgementDto> get copyWith => _$TokenJudgementDtoCopyWithImpl<TokenJudgementDto>(this as TokenJudgementDto, _$identity);

  /// Serializes this TokenJudgementDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TokenJudgementDto&&(identical(other.token, token) || other.token == token)&&(identical(other.used, used) || other.used == used));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,used);

@override
String toString() {
  return 'TokenJudgementDto(token: $token, used: $used)';
}


}

/// @nodoc
abstract mixin class $TokenJudgementDtoCopyWith<$Res>  {
  factory $TokenJudgementDtoCopyWith(TokenJudgementDto value, $Res Function(TokenJudgementDto) _then) = _$TokenJudgementDtoCopyWithImpl;
@useResult
$Res call({
 String token,@JsonKey(name: 'usedMeaningfully') bool used
});




}
/// @nodoc
class _$TokenJudgementDtoCopyWithImpl<$Res>
    implements $TokenJudgementDtoCopyWith<$Res> {
  _$TokenJudgementDtoCopyWithImpl(this._self, this._then);

  final TokenJudgementDto _self;
  final $Res Function(TokenJudgementDto) _then;

/// Create a copy of TokenJudgementDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,Object? used = null,}) {
  return _then(_self.copyWith(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TokenJudgementDto].
extension TokenJudgementDtoPatterns on TokenJudgementDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TokenJudgementDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TokenJudgementDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TokenJudgementDto value)  $default,){
final _that = this;
switch (_that) {
case _TokenJudgementDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TokenJudgementDto value)?  $default,){
final _that = this;
switch (_that) {
case _TokenJudgementDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token, @JsonKey(name: 'usedMeaningfully')  bool used)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TokenJudgementDto() when $default != null:
return $default(_that.token,_that.used);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token, @JsonKey(name: 'usedMeaningfully')  bool used)  $default,) {final _that = this;
switch (_that) {
case _TokenJudgementDto():
return $default(_that.token,_that.used);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token, @JsonKey(name: 'usedMeaningfully')  bool used)?  $default,) {final _that = this;
switch (_that) {
case _TokenJudgementDto() when $default != null:
return $default(_that.token,_that.used);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TokenJudgementDto extends TokenJudgementDto {
  const _TokenJudgementDto({required this.token, @JsonKey(name: 'usedMeaningfully') required this.used}): super._();
  factory _TokenJudgementDto.fromJson(Map<String, dynamic> json) => _$TokenJudgementDtoFromJson(json);

@override final  String token;
// Wire key is `usedMeaningfully`, not `used` — confirmed against the
// real backend payload (every `tokenJudgements` entry has
// `usedMeaningfully`, never a `used` key at all). Kept as `used` on the
// Dart side for a cleaner call-site name; only the JSON key differs.
@override@JsonKey(name: 'usedMeaningfully') final  bool used;

/// Create a copy of TokenJudgementDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TokenJudgementDtoCopyWith<_TokenJudgementDto> get copyWith => __$TokenJudgementDtoCopyWithImpl<_TokenJudgementDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TokenJudgementDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TokenJudgementDto&&(identical(other.token, token) || other.token == token)&&(identical(other.used, used) || other.used == used));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,used);

@override
String toString() {
  return 'TokenJudgementDto(token: $token, used: $used)';
}


}

/// @nodoc
abstract mixin class _$TokenJudgementDtoCopyWith<$Res> implements $TokenJudgementDtoCopyWith<$Res> {
  factory _$TokenJudgementDtoCopyWith(_TokenJudgementDto value, $Res Function(_TokenJudgementDto) _then) = __$TokenJudgementDtoCopyWithImpl;
@override @useResult
$Res call({
 String token,@JsonKey(name: 'usedMeaningfully') bool used
});




}
/// @nodoc
class __$TokenJudgementDtoCopyWithImpl<$Res>
    implements _$TokenJudgementDtoCopyWith<$Res> {
  __$TokenJudgementDtoCopyWithImpl(this._self, this._then);

  final _TokenJudgementDto _self;
  final $Res Function(_TokenJudgementDto) _then;

/// Create a copy of TokenJudgementDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,Object? used = null,}) {
  return _then(_TokenJudgementDto(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
