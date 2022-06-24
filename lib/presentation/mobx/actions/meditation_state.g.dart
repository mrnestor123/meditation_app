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

  final _$selmeditationAtom = Atom(name: '_MeditationState.selmeditation');

  @override
  Meditation get selmeditation {
    _$selmeditationAtom.reportRead();
    return super.selmeditation;
  }

  @override
  set selmeditation(Meditation value) {
    _$selmeditationAtom.reportWrite(value, super.selmeditation, () {
      super.selmeditation = value;
    });
  }

  final _$currentpageAtom = Atom(name: '_MeditationState.currentpage');

  @override
  int get currentpage {
    _$currentpageAtom.reportRead();
    return super.currentpage;
  }

  @override
  set currentpage(int value) {
    _$currentpageAtom.reportWrite(value, super.currentpage, () {
      super.currentpage = value;
    });
  }

  final _$currentsentenceAtom = Atom(name: '_MeditationState.currentsentence');

  @override
  Map<String, dynamic> get currentsentence {
    _$currentsentenceAtom.reportRead();
    return super.currentsentence;
  }

  @override
  set currentsentence(Map<String, dynamic> value) {
    _$currentsentenceAtom.reportWrite(value, super.currentsentence, () {
      super.currentsentence = value;
    });
  }

  final _$newsentenceAtom = Atom(name: '_MeditationState.newsentence');

  @override
  bool get newsentence {
    _$newsentenceAtom.reportRead();
    return super.newsentence;
  }

  @override
  set newsentence(bool value) {
    _$newsentenceAtom.reportWrite(value, super.newsentence, () {
      super.newsentence = value;
    });
  }

  final _$sentenceindexAtom = Atom(name: '_MeditationState.sentenceindex');

  @override
  int get sentenceindex {
    _$sentenceindexAtom.reportRead();
    return super.sentenceindex;
  }

  @override
  set sentenceindex(int value) {
    _$sentenceindexAtom.reportWrite(value, super.sentenceindex, () {
      super.sentenceindex = value;
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

  final _$totaldurationAtom = Atom(name: '_MeditationState.totalduration');

  @override
  Duration get totalduration {
    _$totaldurationAtom.reportRead();
    return super.totalduration;
  }

  @override
  set totalduration(Duration value) {
    _$totaldurationAtom.reportWrite(value, super.totalduration, () {
      super.totalduration = value;
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

  final _$warmuptimeAtom = Atom(name: '_MeditationState.warmuptime');

  @override
  double get warmuptime {
    _$warmuptimeAtom.reportRead();
    return super.warmuptime;
  }

  @override
  set warmuptime(double value) {
    _$warmuptimeAtom.reportWrite(value, super.warmuptime, () {
      super.warmuptime = value;
    });
  }

  final _$selectedIntervalBellAtom =
      Atom(name: '_MeditationState.selectedIntervalBell');

  @override
  String get selectedIntervalBell {
    _$selectedIntervalBellAtom.reportRead();
    return super.selectedIntervalBell;
  }

  @override
  set selectedIntervalBell(String value) {
    _$selectedIntervalBellAtom.reportWrite(value, super.selectedIntervalBell,
        () {
      super.selectedIntervalBell = value;
    });
  }

  final _$stateAtom = Atom(name: '_MeditationState.state');

  @override
  int get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(int value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  final _$videocontrollerAtom = Atom(name: '_MeditationState.videocontroller');

  @override
  VideoPlayerController get videocontroller {
    _$videocontrollerAtom.reportRead();
    return super.videocontroller;
  }

  @override
  set videocontroller(VideoPlayerController value) {
    _$videocontrollerAtom.reportWrite(value, super.videocontroller, () {
      super.videocontroller = value;
    });
  }

  final _$shadowAtom = Atom(name: '_MeditationState.shadow');

  @override
  bool get shadow {
    _$shadowAtom.reportRead();
    return super.shadow;
  }

  @override
  set shadow(bool value) {
    _$shadowAtom.reportWrite(value, super.shadow, () {
      super.shadow = value;
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
  void switchpage(int index, [dynamic avoidjump]) {
    final _$actionInfo = _$_MeditationStateActionController.startAction(
        name: '_MeditationState.switchpage');
    try {
      return super.switchpage(index, avoidjump);
    } finally {
      _$_MeditationStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectBell(String interval) {
    final _$actionInfo = _$_MeditationStateActionController.startAction(
        name: '_MeditationState.selectBell');
    try {
      return super.selectBell(interval);
    } finally {
      _$_MeditationStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void startMeditation(User u, DataBase d) {
    final _$actionInfo = _$_MeditationStateActionController.startAction(
        name: '_MeditationState.startMeditation');
    try {
      return super.startMeditation(u, d);
    } finally {
      _$_MeditationStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectMeditation(Meditation m) {
    final _$actionInfo = _$_MeditationStateActionController.startAction(
        name: '_MeditationState.selectMeditation');
    try {
      return super.selectMeditation(m);
    } finally {
      _$_MeditationStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDuration(int time) {
    final _$actionInfo = _$_MeditationStateActionController.startAction(
        name: '_MeditationState.setDuration');
    try {
      return super.setDuration(time);
    } finally {
      _$_MeditationStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void startWarmup() {
    final _$actionInfo = _$_MeditationStateActionController.startAction(
        name: '_MeditationState.startWarmup');
    try {
      return super.startWarmup();
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
  void selectPreset(MeditationPreset p) {
    final _$actionInfo = _$_MeditationStateActionController.startAction(
        name: '_MeditationState.selectPreset');
    try {
      return super.selectPreset(p);
    } finally {
      _$_MeditationStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void cancel({bool hasFinishedMeditation = false}) {
    final _$actionInfo = _$_MeditationStateActionController.startAction(
        name: '_MeditationState.cancel');
    try {
      return super.cancel(hasFinishedMeditation: hasFinishedMeditation);
    } finally {
      _$_MeditationStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void light() {
    final _$actionInfo = _$_MeditationStateActionController.startAction(
        name: '_MeditationState.light');
    try {
      return super.light();
    } finally {
      _$_MeditationStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
user: ${user},
selmeditation: ${selmeditation},
currentpage: ${currentpage},
currentsentence: ${currentsentence},
newsentence: ${newsentence},
sentenceindex: ${sentenceindex},
duration: ${duration},
totalduration: ${totalduration},
startedmeditation: ${startedmeditation},
warmuptime: ${warmuptime},
selectedIntervalBell: ${selectedIntervalBell},
state: ${state},
videocontroller: ${videocontroller},
shadow: ${shadow}
    ''';
  }
}
