// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TestQuestion {

 Object get question;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TestQuestion&&const DeepCollectionEquality().equals(other.question, question));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(question));

@override
String toString() {
  return 'TestQuestion(question: $question)';
}


}

/// @nodoc
class $TestQuestionCopyWith<$Res>  {
$TestQuestionCopyWith(TestQuestion _, $Res Function(TestQuestion) __);
}


/// Adds pattern-matching-related methods to [TestQuestion].
extension TestQuestionPatterns on TestQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TestQuestionMcq value)?  mcq,TResult Function( TestQuestionShort value)?  short,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TestQuestionMcq() when mcq != null:
return mcq(_that);case TestQuestionShort() when short != null:
return short(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TestQuestionMcq value)  mcq,required TResult Function( TestQuestionShort value)  short,}){
final _that = this;
switch (_that) {
case TestQuestionMcq():
return mcq(_that);case TestQuestionShort():
return short(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TestQuestionMcq value)?  mcq,TResult? Function( TestQuestionShort value)?  short,}){
final _that = this;
switch (_that) {
case TestQuestionMcq() when mcq != null:
return mcq(_that);case TestQuestionShort() when short != null:
return short(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( McqQuestion question)?  mcq,TResult Function( ShortQuestion question)?  short,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TestQuestionMcq() when mcq != null:
return mcq(_that.question);case TestQuestionShort() when short != null:
return short(_that.question);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( McqQuestion question)  mcq,required TResult Function( ShortQuestion question)  short,}) {final _that = this;
switch (_that) {
case TestQuestionMcq():
return mcq(_that.question);case TestQuestionShort():
return short(_that.question);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( McqQuestion question)?  mcq,TResult? Function( ShortQuestion question)?  short,}) {final _that = this;
switch (_that) {
case TestQuestionMcq() when mcq != null:
return mcq(_that.question);case TestQuestionShort() when short != null:
return short(_that.question);case _:
  return null;

}
}

}

/// @nodoc


class TestQuestionMcq extends TestQuestion {
  const TestQuestionMcq(this.question): super._();
  

@override final  McqQuestion question;

/// Create a copy of TestQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TestQuestionMcqCopyWith<TestQuestionMcq> get copyWith => _$TestQuestionMcqCopyWithImpl<TestQuestionMcq>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TestQuestionMcq&&(identical(other.question, question) || other.question == question));
}


@override
int get hashCode => Object.hash(runtimeType,question);

@override
String toString() {
  return 'TestQuestion.mcq(question: $question)';
}


}

/// @nodoc
abstract mixin class $TestQuestionMcqCopyWith<$Res> implements $TestQuestionCopyWith<$Res> {
  factory $TestQuestionMcqCopyWith(TestQuestionMcq value, $Res Function(TestQuestionMcq) _then) = _$TestQuestionMcqCopyWithImpl;
@useResult
$Res call({
 McqQuestion question
});


$McqQuestionCopyWith<$Res> get question;

}
/// @nodoc
class _$TestQuestionMcqCopyWithImpl<$Res>
    implements $TestQuestionMcqCopyWith<$Res> {
  _$TestQuestionMcqCopyWithImpl(this._self, this._then);

  final TestQuestionMcq _self;
  final $Res Function(TestQuestionMcq) _then;

/// Create a copy of TestQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? question = null,}) {
  return _then(TestQuestionMcq(
null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as McqQuestion,
  ));
}

/// Create a copy of TestQuestion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$McqQuestionCopyWith<$Res> get question {
  
  return $McqQuestionCopyWith<$Res>(_self.question, (value) {
    return _then(_self.copyWith(question: value));
  });
}
}

/// @nodoc


class TestQuestionShort extends TestQuestion {
  const TestQuestionShort(this.question): super._();
  

@override final  ShortQuestion question;

/// Create a copy of TestQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TestQuestionShortCopyWith<TestQuestionShort> get copyWith => _$TestQuestionShortCopyWithImpl<TestQuestionShort>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TestQuestionShort&&(identical(other.question, question) || other.question == question));
}


@override
int get hashCode => Object.hash(runtimeType,question);

@override
String toString() {
  return 'TestQuestion.short(question: $question)';
}


}

/// @nodoc
abstract mixin class $TestQuestionShortCopyWith<$Res> implements $TestQuestionCopyWith<$Res> {
  factory $TestQuestionShortCopyWith(TestQuestionShort value, $Res Function(TestQuestionShort) _then) = _$TestQuestionShortCopyWithImpl;
@useResult
$Res call({
 ShortQuestion question
});


$ShortQuestionCopyWith<$Res> get question;

}
/// @nodoc
class _$TestQuestionShortCopyWithImpl<$Res>
    implements $TestQuestionShortCopyWith<$Res> {
  _$TestQuestionShortCopyWithImpl(this._self, this._then);

  final TestQuestionShort _self;
  final $Res Function(TestQuestionShort) _then;

/// Create a copy of TestQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? question = null,}) {
  return _then(TestQuestionShort(
null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as ShortQuestion,
  ));
}

/// Create a copy of TestQuestion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShortQuestionCopyWith<$Res> get question {
  
  return $ShortQuestionCopyWith<$Res>(_self.question, (value) {
    return _then(_self.copyWith(question: value));
  });
}
}

// dart format on
