// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question_bank.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuestionBank {

 String get subject; List<Chapter> get chapters; List<McqQuestion> get mcqs; List<ShortQuestion> get shortQuestions;
/// Create a copy of QuestionBank
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionBankCopyWith<QuestionBank> get copyWith => _$QuestionBankCopyWithImpl<QuestionBank>(this as QuestionBank, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionBank&&(identical(other.subject, subject) || other.subject == subject)&&const DeepCollectionEquality().equals(other.chapters, chapters)&&const DeepCollectionEquality().equals(other.mcqs, mcqs)&&const DeepCollectionEquality().equals(other.shortQuestions, shortQuestions));
}


@override
int get hashCode => Object.hash(runtimeType,subject,const DeepCollectionEquality().hash(chapters),const DeepCollectionEquality().hash(mcqs),const DeepCollectionEquality().hash(shortQuestions));

@override
String toString() {
  return 'QuestionBank(subject: $subject, chapters: $chapters, mcqs: $mcqs, shortQuestions: $shortQuestions)';
}


}

/// @nodoc
abstract mixin class $QuestionBankCopyWith<$Res>  {
  factory $QuestionBankCopyWith(QuestionBank value, $Res Function(QuestionBank) _then) = _$QuestionBankCopyWithImpl;
@useResult
$Res call({
 String subject, List<Chapter> chapters, List<McqQuestion> mcqs, List<ShortQuestion> shortQuestions
});




}
/// @nodoc
class _$QuestionBankCopyWithImpl<$Res>
    implements $QuestionBankCopyWith<$Res> {
  _$QuestionBankCopyWithImpl(this._self, this._then);

  final QuestionBank _self;
  final $Res Function(QuestionBank) _then;

/// Create a copy of QuestionBank
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subject = null,Object? chapters = null,Object? mcqs = null,Object? shortQuestions = null,}) {
  return _then(_self.copyWith(
subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,chapters: null == chapters ? _self.chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<Chapter>,mcqs: null == mcqs ? _self.mcqs : mcqs // ignore: cast_nullable_to_non_nullable
as List<McqQuestion>,shortQuestions: null == shortQuestions ? _self.shortQuestions : shortQuestions // ignore: cast_nullable_to_non_nullable
as List<ShortQuestion>,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestionBank].
extension QuestionBankPatterns on QuestionBank {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionBank value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionBank() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionBank value)  $default,){
final _that = this;
switch (_that) {
case _QuestionBank():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionBank value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionBank() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String subject,  List<Chapter> chapters,  List<McqQuestion> mcqs,  List<ShortQuestion> shortQuestions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionBank() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String subject,  List<Chapter> chapters,  List<McqQuestion> mcqs,  List<ShortQuestion> shortQuestions)  $default,) {final _that = this;
switch (_that) {
case _QuestionBank():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String subject,  List<Chapter> chapters,  List<McqQuestion> mcqs,  List<ShortQuestion> shortQuestions)?  $default,) {final _that = this;
switch (_that) {
case _QuestionBank() when $default != null:
return $default(_that.subject,_that.chapters,_that.mcqs,_that.shortQuestions);case _:
  return null;

}
}

}

/// @nodoc


class _QuestionBank implements QuestionBank {
  const _QuestionBank({required this.subject, required this.chapters, required this.mcqs, required this.shortQuestions});
  

@override final  String subject;
@override final  List<Chapter> chapters;
@override final  List<McqQuestion> mcqs;
@override final  List<ShortQuestion> shortQuestions;

/// Create a copy of QuestionBank
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionBankCopyWith<_QuestionBank> get copyWith => __$QuestionBankCopyWithImpl<_QuestionBank>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionBank&&(identical(other.subject, subject) || other.subject == subject)&&const DeepCollectionEquality().equals(other.chapters, chapters)&&const DeepCollectionEquality().equals(other.mcqs, mcqs)&&const DeepCollectionEquality().equals(other.shortQuestions, shortQuestions));
}


@override
int get hashCode => Object.hash(runtimeType,subject,const DeepCollectionEquality().hash(chapters),const DeepCollectionEquality().hash(mcqs),const DeepCollectionEquality().hash(shortQuestions));

@override
String toString() {
  return 'QuestionBank(subject: $subject, chapters: $chapters, mcqs: $mcqs, shortQuestions: $shortQuestions)';
}


}

/// @nodoc
abstract mixin class _$QuestionBankCopyWith<$Res> implements $QuestionBankCopyWith<$Res> {
  factory _$QuestionBankCopyWith(_QuestionBank value, $Res Function(_QuestionBank) _then) = __$QuestionBankCopyWithImpl;
@override @useResult
$Res call({
 String subject, List<Chapter> chapters, List<McqQuestion> mcqs, List<ShortQuestion> shortQuestions
});




}
/// @nodoc
class __$QuestionBankCopyWithImpl<$Res>
    implements _$QuestionBankCopyWith<$Res> {
  __$QuestionBankCopyWithImpl(this._self, this._then);

  final _QuestionBank _self;
  final $Res Function(_QuestionBank) _then;

/// Create a copy of QuestionBank
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subject = null,Object? chapters = null,Object? mcqs = null,Object? shortQuestions = null,}) {
  return _then(_QuestionBank(
subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,chapters: null == chapters ? _self.chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<Chapter>,mcqs: null == mcqs ? _self.mcqs : mcqs // ignore: cast_nullable_to_non_nullable
as List<McqQuestion>,shortQuestions: null == shortQuestions ? _self.shortQuestions : shortQuestions // ignore: cast_nullable_to_non_nullable
as List<ShortQuestion>,
  ));
}


}

// dart format on
