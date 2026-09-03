// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_taking_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TestTakingState {

 TestTakingStatus get status; Test? get test; String? get attemptId; List<AttemptQuestion> get questions; int get currentIndex; Map<String, SubmissionAnswer> get answers; int get secondsRemaining; TestAttempt? get result;
/// Create a copy of TestTakingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TestTakingStateCopyWith<TestTakingState> get copyWith => _$TestTakingStateCopyWithImpl<TestTakingState>(this as TestTakingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TestTakingState&&(identical(other.status, status) || other.status == status)&&(identical(other.test, test) || other.test == test)&&(identical(other.attemptId, attemptId) || other.attemptId == attemptId)&&const DeepCollectionEquality().equals(other.questions, questions)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&const DeepCollectionEquality().equals(other.answers, answers)&&(identical(other.secondsRemaining, secondsRemaining) || other.secondsRemaining == secondsRemaining)&&(identical(other.result, result) || other.result == result));
}


@override
int get hashCode => Object.hash(runtimeType,status,test,attemptId,const DeepCollectionEquality().hash(questions),currentIndex,const DeepCollectionEquality().hash(answers),secondsRemaining,result);

@override
String toString() {
  return 'TestTakingState(status: $status, test: $test, attemptId: $attemptId, questions: $questions, currentIndex: $currentIndex, answers: $answers, secondsRemaining: $secondsRemaining, result: $result)';
}


}

/// @nodoc
abstract mixin class $TestTakingStateCopyWith<$Res>  {
  factory $TestTakingStateCopyWith(TestTakingState value, $Res Function(TestTakingState) _then) = _$TestTakingStateCopyWithImpl;
@useResult
$Res call({
 TestTakingStatus status, Test? test, String? attemptId, List<AttemptQuestion> questions, int currentIndex, Map<String, SubmissionAnswer> answers, int secondsRemaining, TestAttempt? result
});


$TestCopyWith<$Res>? get test;$TestAttemptCopyWith<$Res>? get result;

}
/// @nodoc
class _$TestTakingStateCopyWithImpl<$Res>
    implements $TestTakingStateCopyWith<$Res> {
  _$TestTakingStateCopyWithImpl(this._self, this._then);

  final TestTakingState _self;
  final $Res Function(TestTakingState) _then;

/// Create a copy of TestTakingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? test = freezed,Object? attemptId = freezed,Object? questions = null,Object? currentIndex = null,Object? answers = null,Object? secondsRemaining = null,Object? result = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TestTakingStatus,test: freezed == test ? _self.test : test // ignore: cast_nullable_to_non_nullable
as Test?,attemptId: freezed == attemptId ? _self.attemptId : attemptId // ignore: cast_nullable_to_non_nullable
as String?,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<AttemptQuestion>,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as Map<String, SubmissionAnswer>,secondsRemaining: null == secondsRemaining ? _self.secondsRemaining : secondsRemaining // ignore: cast_nullable_to_non_nullable
as int,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as TestAttempt?,
  ));
}
/// Create a copy of TestTakingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TestCopyWith<$Res>? get test {
    if (_self.test == null) {
    return null;
  }

  return $TestCopyWith<$Res>(_self.test!, (value) {
    return _then(_self.copyWith(test: value));
  });
}/// Create a copy of TestTakingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TestAttemptCopyWith<$Res>? get result {
    if (_self.result == null) {
    return null;
  }

  return $TestAttemptCopyWith<$Res>(_self.result!, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}


/// Adds pattern-matching-related methods to [TestTakingState].
extension TestTakingStatePatterns on TestTakingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TestTakingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TestTakingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TestTakingState value)  $default,){
final _that = this;
switch (_that) {
case _TestTakingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TestTakingState value)?  $default,){
final _that = this;
switch (_that) {
case _TestTakingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TestTakingStatus status,  Test? test,  String? attemptId,  List<AttemptQuestion> questions,  int currentIndex,  Map<String, SubmissionAnswer> answers,  int secondsRemaining,  TestAttempt? result)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TestTakingState() when $default != null:
return $default(_that.status,_that.test,_that.attemptId,_that.questions,_that.currentIndex,_that.answers,_that.secondsRemaining,_that.result);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TestTakingStatus status,  Test? test,  String? attemptId,  List<AttemptQuestion> questions,  int currentIndex,  Map<String, SubmissionAnswer> answers,  int secondsRemaining,  TestAttempt? result)  $default,) {final _that = this;
switch (_that) {
case _TestTakingState():
return $default(_that.status,_that.test,_that.attemptId,_that.questions,_that.currentIndex,_that.answers,_that.secondsRemaining,_that.result);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TestTakingStatus status,  Test? test,  String? attemptId,  List<AttemptQuestion> questions,  int currentIndex,  Map<String, SubmissionAnswer> answers,  int secondsRemaining,  TestAttempt? result)?  $default,) {final _that = this;
switch (_that) {
case _TestTakingState() when $default != null:
return $default(_that.status,_that.test,_that.attemptId,_that.questions,_that.currentIndex,_that.answers,_that.secondsRemaining,_that.result);case _:
  return null;

}
}

}

/// @nodoc


class _TestTakingState extends TestTakingState {
  const _TestTakingState({required this.status, this.test, this.attemptId, this.questions = const <AttemptQuestion>[], this.currentIndex = 0, this.answers = const <String, SubmissionAnswer>{}, this.secondsRemaining = 0, this.result}): super._();
  

@override final  TestTakingStatus status;
@override final  Test? test;
@override final  String? attemptId;
@override@JsonKey() final  List<AttemptQuestion> questions;
@override@JsonKey() final  int currentIndex;
@override@JsonKey() final  Map<String, SubmissionAnswer> answers;
@override@JsonKey() final  int secondsRemaining;
@override final  TestAttempt? result;

/// Create a copy of TestTakingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TestTakingStateCopyWith<_TestTakingState> get copyWith => __$TestTakingStateCopyWithImpl<_TestTakingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TestTakingState&&(identical(other.status, status) || other.status == status)&&(identical(other.test, test) || other.test == test)&&(identical(other.attemptId, attemptId) || other.attemptId == attemptId)&&const DeepCollectionEquality().equals(other.questions, questions)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&const DeepCollectionEquality().equals(other.answers, answers)&&(identical(other.secondsRemaining, secondsRemaining) || other.secondsRemaining == secondsRemaining)&&(identical(other.result, result) || other.result == result));
}


@override
int get hashCode => Object.hash(runtimeType,status,test,attemptId,const DeepCollectionEquality().hash(questions),currentIndex,const DeepCollectionEquality().hash(answers),secondsRemaining,result);

@override
String toString() {
  return 'TestTakingState(status: $status, test: $test, attemptId: $attemptId, questions: $questions, currentIndex: $currentIndex, answers: $answers, secondsRemaining: $secondsRemaining, result: $result)';
}


}

/// @nodoc
abstract mixin class _$TestTakingStateCopyWith<$Res> implements $TestTakingStateCopyWith<$Res> {
  factory _$TestTakingStateCopyWith(_TestTakingState value, $Res Function(_TestTakingState) _then) = __$TestTakingStateCopyWithImpl;
@override @useResult
$Res call({
 TestTakingStatus status, Test? test, String? attemptId, List<AttemptQuestion> questions, int currentIndex, Map<String, SubmissionAnswer> answers, int secondsRemaining, TestAttempt? result
});


@override $TestCopyWith<$Res>? get test;@override $TestAttemptCopyWith<$Res>? get result;

}
/// @nodoc
class __$TestTakingStateCopyWithImpl<$Res>
    implements _$TestTakingStateCopyWith<$Res> {
  __$TestTakingStateCopyWithImpl(this._self, this._then);

  final _TestTakingState _self;
  final $Res Function(_TestTakingState) _then;

/// Create a copy of TestTakingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? test = freezed,Object? attemptId = freezed,Object? questions = null,Object? currentIndex = null,Object? answers = null,Object? secondsRemaining = null,Object? result = freezed,}) {
  return _then(_TestTakingState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TestTakingStatus,test: freezed == test ? _self.test : test // ignore: cast_nullable_to_non_nullable
as Test?,attemptId: freezed == attemptId ? _self.attemptId : attemptId // ignore: cast_nullable_to_non_nullable
as String?,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<AttemptQuestion>,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as Map<String, SubmissionAnswer>,secondsRemaining: null == secondsRemaining ? _self.secondsRemaining : secondsRemaining // ignore: cast_nullable_to_non_nullable
as int,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as TestAttempt?,
  ));
}

/// Create a copy of TestTakingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TestCopyWith<$Res>? get test {
    if (_self.test == null) {
    return null;
  }

  return $TestCopyWith<$Res>(_self.test!, (value) {
    return _then(_self.copyWith(test: value));
  });
}/// Create a copy of TestTakingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TestAttemptCopyWith<$Res>? get result {
    if (_self.result == null) {
    return null;
  }

  return $TestAttemptCopyWith<$Res>(_self.result!, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}

// dart format on
