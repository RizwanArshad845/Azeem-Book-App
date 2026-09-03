// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'token_judgement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TokenJudgement {

 String get token; bool get used;
/// Create a copy of TokenJudgement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TokenJudgementCopyWith<TokenJudgement> get copyWith => _$TokenJudgementCopyWithImpl<TokenJudgement>(this as TokenJudgement, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TokenJudgement&&(identical(other.token, token) || other.token == token)&&(identical(other.used, used) || other.used == used));
}


@override
int get hashCode => Object.hash(runtimeType,token,used);

@override
String toString() {
  return 'TokenJudgement(token: $token, used: $used)';
}


}

/// @nodoc
abstract mixin class $TokenJudgementCopyWith<$Res>  {
  factory $TokenJudgementCopyWith(TokenJudgement value, $Res Function(TokenJudgement) _then) = _$TokenJudgementCopyWithImpl;
@useResult
$Res call({
 String token, bool used
});




}
/// @nodoc
class _$TokenJudgementCopyWithImpl<$Res>
    implements $TokenJudgementCopyWith<$Res> {
  _$TokenJudgementCopyWithImpl(this._self, this._then);

  final TokenJudgement _self;
  final $Res Function(TokenJudgement) _then;

/// Create a copy of TokenJudgement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,Object? used = null,}) {
  return _then(_self.copyWith(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TokenJudgement].
extension TokenJudgementPatterns on TokenJudgement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TokenJudgement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TokenJudgement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TokenJudgement value)  $default,){
final _that = this;
switch (_that) {
case _TokenJudgement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TokenJudgement value)?  $default,){
final _that = this;
switch (_that) {
case _TokenJudgement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token,  bool used)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TokenJudgement() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token,  bool used)  $default,) {final _that = this;
switch (_that) {
case _TokenJudgement():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token,  bool used)?  $default,) {final _that = this;
switch (_that) {
case _TokenJudgement() when $default != null:
return $default(_that.token,_that.used);case _:
  return null;

}
}

}

/// @nodoc


class _TokenJudgement implements TokenJudgement {
  const _TokenJudgement({required this.token, required this.used});
  

@override final  String token;
@override final  bool used;

/// Create a copy of TokenJudgement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TokenJudgementCopyWith<_TokenJudgement> get copyWith => __$TokenJudgementCopyWithImpl<_TokenJudgement>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TokenJudgement&&(identical(other.token, token) || other.token == token)&&(identical(other.used, used) || other.used == used));
}


@override
int get hashCode => Object.hash(runtimeType,token,used);

@override
String toString() {
  return 'TokenJudgement(token: $token, used: $used)';
}


}

/// @nodoc
abstract mixin class _$TokenJudgementCopyWith<$Res> implements $TokenJudgementCopyWith<$Res> {
  factory _$TokenJudgementCopyWith(_TokenJudgement value, $Res Function(_TokenJudgement) _then) = __$TokenJudgementCopyWithImpl;
@override @useResult
$Res call({
 String token, bool used
});




}
/// @nodoc
class __$TokenJudgementCopyWithImpl<$Res>
    implements _$TokenJudgementCopyWith<$Res> {
  __$TokenJudgementCopyWithImpl(this._self, this._then);

  final _TokenJudgement _self;
  final $Res Function(_TokenJudgement) _then;

/// Create a copy of TokenJudgement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,Object? used = null,}) {
  return _then(_TokenJudgement(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
