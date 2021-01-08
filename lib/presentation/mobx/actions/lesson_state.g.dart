// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LessonState on _LessonState, Store {
  final _$brainlessonsAtom = Atom(name: '_LessonState.brainlessons');

  @override
  List<LessonModel> get brainlessons {
    _$brainlessonsAtom.reportRead();
    return super.brainlessons;
  }

  @override
  set brainlessons(List<LessonModel> value) {
    _$brainlessonsAtom.reportWrite(value, super.brainlessons, () {
      super.brainlessons = value;
    });
  }

  final _$errorAtom = Atom(name: '_LessonState.error');

  @override
  String get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  final _$resultAtom = Atom(name: '_LessonState.result');

  @override
  Either<Failure, List<LessonModel>> get result {
    _$resultAtom.reportRead();
    return super.result;
  }

  @override
  set result(Either<Failure, List<LessonModel>> value) {
    _$resultAtom.reportWrite(value, super.result, () {
      super.result = value;
    });
  }

  final _$getBrainLessonsAsyncAction =
      AsyncAction('_LessonState.getBrainLessons');

  @override
  Future<dynamic> getBrainLessons({int stage}) {
    return _$getBrainLessonsAsyncAction
        .run(() => super.getBrainLessons(stage: stage));
  }

  @override
  String toString() {
    return '''
brainlessons: ${brainlessons},
error: ${error},
result: ${result}
    ''';
  }
}
