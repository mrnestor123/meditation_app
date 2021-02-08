// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meditation_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MeditationState on _MeditationState, Store {
  final _$userAtom = Atom(name: '_MeditationState.user');

  @override
  User get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(User value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  final _$_meditationFutureAtom =
      Atom(name: '_MeditationState._meditationFuture');

  @override
  Future<Either<Failure, Meditation>> get _meditationFuture {
    _$_meditationFutureAtom.reportRead();
    return super._meditationFuture;
  }

  @override
  set _meditationFuture(Future<Either<Failure, Meditation>> value) {
    _$_meditationFutureAtom.reportWrite(value, super._meditationFuture, () {
      super._meditationFuture = value;
    });
  }

  final _$errorMessageAtom = Atom(name: '_MeditationState.errorMessage');

  @override
  String get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  final _$durationAtom = Atom(name: '_MeditationState.duration');

  @override
  Duration get duration {
    _$durationAtom.reportRead();
    return super.duration;
  }

  @override
  set duration(Duration value) {
    _$durationAtom.reportWrite(value, super.duration, () {
      super.duration = value;
    });
  }

  final _$startedmeditationAtom =
      Atom(name: '_MeditationState.startedmeditation');

  @override
  bool get startedmeditation {
    _$startedmeditationAtom.reportRead();
    return super.startedmeditation;
  }

  @override
  set startedmeditation(bool value) {
    _$startedmeditationAtom.reportWrite(value, super.startedmeditation, () {
      super.startedmeditation = value;
    });
  }

  final _$stateAtom = Atom(name: '_MeditationState.state');

  @override
  String get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(String value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  final _$finishMeditationAsyncAction =
      AsyncAction('_MeditationState.finishMeditation');

  @override
  Future<dynamic> finishMeditation() {
    return _$finishMeditationAsyncAction.run(() => super.finishMeditation());
  }

  final _$_MeditationStateActionController =
      ActionController(name: '_MeditationState');

  @override
  void startMeditation(Duration dur, User u, DataBase d) {
    final _$actionInfo = _$_MeditationStateActionController.startAction(
        name: '_MeditationState.startMeditation');
    try {
      return super.startMeditation(dur, u, d);
    } finally {
      _$_MeditationStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void startTimer() {
    final _$actionInfo = _$_MeditationStateActionController.startAction(
        name: '_MeditationState.startTimer');
    try {
      return super.startTimer();
    } finally {
      _$_MeditationStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void pause() {
    final _$actionInfo = _$_MeditationStateActionController.startAction(
        name: '_MeditationState.pause');
    try {
      return super.pause();
    } finally {
      _$_MeditationStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
user: ${user},
errorMessage: ${errorMessage},
duration: ${duration},
startedmeditation: ${startedmeditation},
state: ${state}
    ''';
  }
}
