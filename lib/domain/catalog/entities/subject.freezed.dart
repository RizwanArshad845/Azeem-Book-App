// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subject.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Subject {

 String get id; String get name; String get boardClassId; int get bundlePrice;/// Bundle price minus the 10% teacher-selection discount, when the
/// requesting student has a teacher assigned for this subject via a
/// `SubjectEnrollment` — null otherwise (including always-null for
/// teacher-role callers, per backend contract).
 int? get discountedPrice;
/// Create a copy of Subject
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubjectCopyWith<Subject> get copyWith => _$SubjectCopyWithImpl<Subject>(this as Subject, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Subject&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.boardClassId, boardClassId) || other.boardClassId == boardClassId)&&(identical(other.bundlePrice, bundlePrice) || other.bundlePrice == bundlePrice)&&(identical(other.discountedPrice, discountedPrice) || other.discountedPrice == discountedPrice));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,boardClassId,bundlePrice,discountedPrice);

@override
String toString() {
  return 'Subject(id: $id, name: $name, boardClassId: $boardClassId, bundlePrice: $bundlePrice, discountedPrice: $discountedPrice)';
}


}

/// @nodoc
abstract mixin class $SubjectCopyWith<$Res>  {
  factory $SubjectCopyWith(Subject value, $Res Function(Subject) _then) = _$SubjectCopyWithImpl;
@useResult
$Res call({
 String id, String name, String boardClassId, int bundlePrice, int? discountedPrice
});




}
/// @nodoc
class _$SubjectCopyWithImpl<$Res>
    implements $SubjectCopyWith<$Res> {
  _$SubjectCopyWithImpl(this._self, this._then);

  final Subject _self;
  final $Res Function(Subject) _then;

/// Create a copy of Subject
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? boardClassId = null,Object? bundlePrice = null,Object? discountedPrice = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,boardClassId: null == boardClassId ? _self.boardClassId : boardClassId // ignore: cast_nullable_to_non_nullable
as String,bundlePrice: null == bundlePrice ? _self.bundlePrice : bundlePrice // ignore: cast_nullable_to_non_nullable
as int,discountedPrice: freezed == discountedPrice ? _self.discountedPrice : discountedPrice // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Subject].
extension SubjectPatterns on Subject {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Subject value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Subject() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Subject value)  $default,){
final _that = this;
switch (_that) {
case _Subject():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Subject value)?  $default,){
final _that = this;
switch (_that) {
case _Subject() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String boardClassId,  int bundlePrice,  int? discountedPrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Subject() when $default != null:
return $default(_that.id,_that.name,_that.boardClassId,_that.bundlePrice,_that.discountedPrice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String boardClassId,  int bundlePrice,  int? discountedPrice)  $default,) {final _that = this;
switch (_that) {
case _Subject():
return $default(_that.id,_that.name,_that.boardClassId,_that.bundlePrice,_that.discountedPrice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String boardClassId,  int bundlePrice,  int? discountedPrice)?  $default,) {final _that = this;
switch (_that) {
case _Subject() when $default != null:
return $default(_that.id,_that.name,_that.boardClassId,_that.bundlePrice,_that.discountedPrice);case _:
  return null;

}
}

}

/// @nodoc


class _Subject implements Subject {
  const _Subject({required this.id, required this.name, required this.boardClassId, required this.bundlePrice, this.discountedPrice});
  

@override final  String id;
@override final  String name;
@override final  String boardClassId;
@override final  int bundlePrice;
/// Bundle price minus the 10% teacher-selection discount, when the
/// requesting student has a teacher assigned for this subject via a
/// `SubjectEnrollment` — null otherwise (including always-null for
/// teacher-role callers, per backend contract).
@override final  int? discountedPrice;

/// Create a copy of Subject
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubjectCopyWith<_Subject> get copyWith => __$SubjectCopyWithImpl<_Subject>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Subject&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.boardClassId, boardClassId) || other.boardClassId == boardClassId)&&(identical(other.bundlePrice, bundlePrice) || other.bundlePrice == bundlePrice)&&(identical(other.discountedPrice, discountedPrice) || other.discountedPrice == discountedPrice));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,boardClassId,bundlePrice,discountedPrice);

@override
String toString() {
  return 'Subject(id: $id, name: $name, boardClassId: $boardClassId, bundlePrice: $bundlePrice, discountedPrice: $discountedPrice)';
}


}

/// @nodoc
abstract mixin class _$SubjectCopyWith<$Res> implements $SubjectCopyWith<$Res> {
  factory _$SubjectCopyWith(_Subject value, $Res Function(_Subject) _then) = __$SubjectCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String boardClassId, int bundlePrice, int? discountedPrice
});




}
/// @nodoc
class __$SubjectCopyWithImpl<$Res>
    implements _$SubjectCopyWith<$Res> {
  __$SubjectCopyWithImpl(this._self, this._then);

  final _Subject _self;
  final $Res Function(_Subject) _then;

/// Create a copy of Subject
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? boardClassId = null,Object? bundlePrice = null,Object? discountedPrice = freezed,}) {
  return _then(_Subject(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,boardClassId: null == boardClassId ? _self.boardClassId : boardClassId // ignore: cast_nullable_to_non_nullable
as String,bundlePrice: null == bundlePrice ? _self.bundlePrice : bundlePrice // ignore: cast_nullable_to_non_nullable
as int,discountedPrice: freezed == discountedPrice ? _self.discountedPrice : discountedPrice // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
