// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LessonState on _LessonState, Store {
  final _$brainlessonsAtom = Atom(name: '_LessonState.brainlessons');

  @override
  List<LessonModel> get brainlessons {
    _$brainlessonsAtom.context.enforceReadPolicy(_$brainlessonsAtom);
    _$brainlessonsAtom.reportObserved();
    return super.brainlessons;
  }

  @override
  set brainlessons(List<LessonModel> value) {
    _$brainlessonsAtom.context.conditionallyRunInAction(() {
      super.brainlessons = value;
      _$brainlessonsAtom.reportChanged();
    }, _$brainlessonsAtom, name: '${_$brainlessonsAtom.name}_set');
  }

  final _$errorAtom = Atom(name: '_LessonState.error');

  @override
  String get error {
    _$errorAtom.context.enforceReadPolicy(_$errorAtom);
    _$errorAtom.reportObserved();
    return super.error;
  }

  @override
  set error(String value) {
    _$errorAtom.context.conditionallyRunInAction(() {
      super.error = value;
      _$errorAtom.reportChanged();
    }, _$errorAtom, name: '${_$errorAtom.name}_set');
  }

  final _$resultAtom = Atom(name: '_LessonState.result');

  @override
  Either<Failure, List<LessonModel>> get result {
    _$resultAtom.context.enforceReadPolicy(_$resultAtom);
    _$resultAtom.reportObserved();
    return super.result;
  }

  @override
  set result(Either<Failure, List<LessonModel>> value) {
    _$resultAtom.context.conditionallyRunInAction(() {
      super.result = value;
      _$resultAtom.reportChanged();
    }, _$resultAtom, name: '${_$resultAtom.name}_set');
  }

  final _$getBrainLessonsAsyncAction = AsyncAction('getBrainLessons');

  @override
  Future<dynamic> getBrainLessons({int stage}) {
    return _$getBrainLessonsAsyncAction
        .run(() => super.getBrainLessons(stage: stage));
  }

  @override
  String toString() {
    final string =
        'brainlessons: ${brainlessons.toString()},error: ${error.toString()},result: ${result.toString()}';
    return '{$string}';
  }
}
