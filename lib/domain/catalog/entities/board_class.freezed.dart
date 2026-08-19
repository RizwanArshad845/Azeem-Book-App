// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'board_class.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BoardClass {

 String get id; String get name; String get classLevelId; bool get isEnabled;
/// Create a copy of BoardClass
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BoardClassCopyWith<BoardClass> get copyWith => _$BoardClassCopyWithImpl<BoardClass>(this as BoardClass, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BoardClass&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.classLevelId, classLevelId) || other.classLevelId == classLevelId)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,classLevelId,isEnabled);

@override
String toString() {
  return 'BoardClass(id: $id, name: $name, classLevelId: $classLevelId, isEnabled: $isEnabled)';
}


}

/// @nodoc
abstract mixin class $BoardClassCopyWith<$Res>  {
  factory $BoardClassCopyWith(BoardClass value, $Res Function(BoardClass) _then) = _$BoardClassCopyWithImpl;
@useResult
$Res call({
 String id, String name, String classLevelId, bool isEnabled
});




}
/// @nodoc
class _$BoardClassCopyWithImpl<$Res>
    implements $BoardClassCopyWith<$Res> {
  _$BoardClassCopyWithImpl(this._self, this._then);

  final BoardClass _self;
  final $Res Function(BoardClass) _then;

/// Create a copy of BoardClass
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? classLevelId = null,Object? isEnabled = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,classLevelId: null == classLevelId ? _self.classLevelId : classLevelId // ignore: cast_nullable_to_non_nullable
as String,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BoardClass].
extension BoardClassPatterns on BoardClass {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BoardClass value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BoardClass() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BoardClass value)  $default,){
final _that = this;
switch (_that) {
case _BoardClass():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BoardClass value)?  $default,){
final _that = this;
switch (_that) {
case _BoardClass() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String classLevelId,  bool isEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BoardClass() when $default != null:
return $default(_that.id,_that.name,_that.classLevelId,_that.isEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String classLevelId,  bool isEnabled)  $default,) {final _that = this;
switch (_that) {
case _BoardClass():
return $default(_that.id,_that.name,_that.classLevelId,_that.isEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String classLevelId,  bool isEnabled)?  $default,) {final _that = this;
switch (_that) {
case _BoardClass() when $default != null:
return $default(_that.id,_that.name,_that.classLevelId,_that.isEnabled);case _:
  return null;

}
}

}

/// @nodoc


class _BoardClass implements BoardClass {
  const _BoardClass({required this.id, required this.name, required this.classLevelId, this.isEnabled = false});
  

@override final  String id;
@override final  String name;
@override final  String classLevelId;
@override@JsonKey() final  bool isEnabled;

/// Create a copy of BoardClass
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BoardClassCopyWith<_BoardClass> get copyWith => __$BoardClassCopyWithImpl<_BoardClass>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BoardClass&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.classLevelId, classLevelId) || other.classLevelId == classLevelId)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,classLevelId,isEnabled);

@override
String toString() {
  return 'BoardClass(id: $id, name: $name, classLevelId: $classLevelId, isEnabled: $isEnabled)';
}


}

/// @nodoc
abstract mixin class _$BoardClassCopyWith<$Res> implements $BoardClassCopyWith<$Res> {
  factory _$BoardClassCopyWith(_BoardClass value, $Res Function(_BoardClass) _then) = __$BoardClassCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String classLevelId, bool isEnabled
});




}
/// @nodoc
class __$BoardClassCopyWithImpl<$Res>
    implements _$BoardClassCopyWith<$Res> {
  __$BoardClassCopyWithImpl(this._self, this._then);

  final _BoardClass _self;
  final $Res Function(_BoardClass) _then;

/// Create a copy of BoardClass
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? classLevelId = null,Object? isEnabled = null,}) {
  return _then(_BoardClass(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,classLevelId: null == classLevelId ? _self.classLevelId : classLevelId // ignore: cast_nullable_to_non_nullable
as String,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
