// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meditation_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MeditationState on _MeditationState, Store {
  final _$userAtom = Atom(name: '_MeditationState.user');

  @override
  dynamic get user {
    _$userAtom.context.enforceReadPolicy(_$userAtom);
    _$userAtom.reportObserved();
    return super.user;
  }

  @override
  set user(dynamic value) {
    _$userAtom.context.conditionallyRunInAction(() {
      super.user = value;
      _$userAtom.reportChanged();
    }, _$userAtom, name: '${_$userAtom.name}_set');
  }

  final _$_meditationFutureAtom =
      Atom(name: '_MeditationState._meditationFuture');

  @override
  Future<Either<Failure, Meditation>> get _meditationFuture {
    _$_meditationFutureAtom.context.enforceReadPolicy(_$_meditationFutureAtom);
    _$_meditationFutureAtom.reportObserved();
    return super._meditationFuture;
  }

  @override
  set _meditationFuture(Future<Either<Failure, Meditation>> value) {
    _$_meditationFutureAtom.context.conditionallyRunInAction(() {
      super._meditationFuture = value;
      _$_meditationFutureAtom.reportChanged();
    }, _$_meditationFutureAtom, name: '${_$_meditationFutureAtom.name}_set');
  }

  final _$errorMessageAtom = Atom(name: '_MeditationState.errorMessage');

  @override
  String get errorMessage {
    _$errorMessageAtom.context.enforceReadPolicy(_$errorMessageAtom);
    _$errorMessageAtom.reportObserved();
    return super.errorMessage;
  }

  @override
  set errorMessage(String value) {
    _$errorMessageAtom.context.conditionallyRunInAction(() {
      super.errorMessage = value;
      _$errorMessageAtom.reportChanged();
    }, _$errorMessageAtom, name: '${_$errorMessageAtom.name}_set');
  }

  final _$durationAtom = Atom(name: '_MeditationState.duration');

  @override
  Duration get duration {
    _$durationAtom.context.enforceReadPolicy(_$durationAtom);
    _$durationAtom.reportObserved();
    return super.duration;
  }

  @override
  set duration(Duration value) {
    _$durationAtom.context.conditionallyRunInAction(() {
      super.duration = value;
      _$durationAtom.reportChanged();
    }, _$durationAtom, name: '${_$durationAtom.name}_set');
  }

  final _$startedmeditationAtom =
      Atom(name: '_MeditationState.startedmeditation');

  @override
  bool get startedmeditation {
    _$startedmeditationAtom.context.enforceReadPolicy(_$startedmeditationAtom);
    _$startedmeditationAtom.reportObserved();
    return super.startedmeditation;
  }

  @override
  set startedmeditation(bool value) {
    _$startedmeditationAtom.context.conditionallyRunInAction(() {
      super.startedmeditation = value;
      _$startedmeditationAtom.reportChanged();
    }, _$startedmeditationAtom, name: '${_$startedmeditationAtom.name}_set');
  }

  final _$meditationphaseAtom = Atom(name: '_MeditationState.meditationphase');

  @override
  String get meditationphase {
    _$meditationphaseAtom.context.enforceReadPolicy(_$meditationphaseAtom);
    _$meditationphaseAtom.reportObserved();
    return super.meditationphase;
  }

  @override
  set meditationphase(String value) {
    _$meditationphaseAtom.context.conditionallyRunInAction(() {
      super.meditationphase = value;
      _$meditationphaseAtom.reportChanged();
    }, _$meditationphaseAtom, name: '${_$meditationphaseAtom.name}_set');
  }

  final _$_MeditationStateActionController =
      ActionController(name: '_MeditationState');

  @override
  void startMeditation(Duration duration) {
    final _$actionInfo = _$_MeditationStateActionController.startAction();
    try {
      return super.startMeditation(duration);
    } finally {
      _$_MeditationStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void finishMeditation() {
    final _$actionInfo = _$_MeditationStateActionController.startAction();
    try {
      return super.finishMeditation();
    } finally {
      _$_MeditationStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'user: ${user.toString()},errorMessage: ${errorMessage.toString()},duration: ${duration.toString()},startedmeditation: ${startedmeditation.toString()},meditationphase: ${meditationphase.toString()}';
    return '{$string}';
  }
}
