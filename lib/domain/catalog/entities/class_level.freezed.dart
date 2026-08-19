// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'class_level.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClassLevel {

 String get id; String get name; bool get isEnabled;
/// Create a copy of ClassLevel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClassLevelCopyWith<ClassLevel> get copyWith => _$ClassLevelCopyWithImpl<ClassLevel>(this as ClassLevel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClassLevel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,isEnabled);

@override
String toString() {
  return 'ClassLevel(id: $id, name: $name, isEnabled: $isEnabled)';
}


}

/// @nodoc
abstract mixin class $ClassLevelCopyWith<$Res>  {
  factory $ClassLevelCopyWith(ClassLevel value, $Res Function(ClassLevel) _then) = _$ClassLevelCopyWithImpl;
@useResult
$Res call({
 String id, String name, bool isEnabled
});




}
/// @nodoc
class _$ClassLevelCopyWithImpl<$Res>
    implements $ClassLevelCopyWith<$Res> {
  _$ClassLevelCopyWithImpl(this._self, this._then);

  final ClassLevel _self;
  final $Res Function(ClassLevel) _then;

/// Create a copy of ClassLevel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? isEnabled = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ClassLevel].
extension ClassLevelPatterns on ClassLevel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClassLevel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClassLevel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClassLevel value)  $default,){
final _that = this;
switch (_that) {
case _ClassLevel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClassLevel value)?  $default,){
final _that = this;
switch (_that) {
case _ClassLevel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  bool isEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClassLevel() when $default != null:
return $default(_that.id,_that.name,_that.isEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  bool isEnabled)  $default,) {final _that = this;
switch (_that) {
case _ClassLevel():
return $default(_that.id,_that.name,_that.isEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  bool isEnabled)?  $default,) {final _that = this;
switch (_that) {
case _ClassLevel() when $default != null:
return $default(_that.id,_that.name,_that.isEnabled);case _:
  return null;

}
}

}

/// @nodoc


class _ClassLevel implements ClassLevel {
  const _ClassLevel({required this.id, required this.name, this.isEnabled = false});
  

@override final  String id;
@override final  String name;
@override@JsonKey() final  bool isEnabled;

/// Create a copy of ClassLevel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClassLevelCopyWith<_ClassLevel> get copyWith => __$ClassLevelCopyWithImpl<_ClassLevel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClassLevel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,isEnabled);

@override
String toString() {
  return 'ClassLevel(id: $id, name: $name, isEnabled: $isEnabled)';
}


}

/// @nodoc
abstract mixin class _$ClassLevelCopyWith<$Res> implements $ClassLevelCopyWith<$Res> {
  factory _$ClassLevelCopyWith(_ClassLevel value, $Res Function(_ClassLevel) _then) = __$ClassLevelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, bool isEnabled
});




}
/// @nodoc
class __$ClassLevelCopyWithImpl<$Res>
    implements _$ClassLevelCopyWith<$Res> {
  __$ClassLevelCopyWithImpl(this._self, this._then);

  final _ClassLevel _self;
  final $Res Function(_ClassLevel) _then;

/// Create a copy of ClassLevel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? isEnabled = null,}) {
  return _then(_ClassLevel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
