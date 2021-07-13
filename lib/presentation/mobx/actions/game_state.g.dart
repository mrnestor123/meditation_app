// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$GameState on _GameState, Store {
  final _$selectedgameAtom = Atom(name: '_GameState.selectedgame');

  @override
  Game get selectedgame {
    _$selectedgameAtom.reportRead();
    return super.selectedgame;
  }

  @override
  set selectedgame(Game value) {
    _$selectedgameAtom.reportWrite(value, super.selectedgame, () {
      super.selectedgame = value;
    });
  }

  final _$successAtom = Atom(name: '_GameState.success');

  @override
  bool get success {
    _$successAtom.reportRead();
    return super.success;
  }

  @override
  set success(bool value) {
    _$successAtom.reportWrite(value, super.success, () {
      super.success = value;
    });
  }

  final _$stateAtom = Atom(name: '_GameState.state');

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

  final _$userAtom = Atom(name: '_GameState.user');

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

  final _$startedAtom = Atom(name: '_GameState.started');

  @override
  bool get started {
    _$startedAtom.reportRead();
    return super.started;
  }

  @override
  set started(bool value) {
    _$startedAtom.reportWrite(value, super.started, () {
      super.started = value;
    });
  }

  final _$selectedanswerAtom = Atom(name: '_GameState.selectedanswer');

  @override
  int get selectedanswer {
    _$selectedanswerAtom.reportRead();
    return super.selectedanswer;
  }

  @override
  set selectedanswer(int value) {
    _$selectedanswerAtom.reportWrite(value, super.selectedanswer, () {
      super.selectedanswer = value;
    });
  }

  final _$controllerAtom = Atom(name: '_GameState.controller');

  @override
  VideoPlayerController get controller {
    _$controllerAtom.reportRead();
    return super.controller;
  }

  @override
  set controller(VideoPlayerController value) {
    _$controllerAtom.reportWrite(value, super.controller, () {
      super.controller = value;
    });
  }

  final _$beforecontrollerAtom = Atom(name: '_GameState.beforecontroller');

  @override
  VideoPlayerController get beforecontroller {
    _$beforecontrollerAtom.reportRead();
    return super.beforecontroller;
  }

  @override
  set beforecontroller(VideoPlayerController value) {
    _$beforecontrollerAtom.reportWrite(value, super.beforecontroller, () {
      super.beforecontroller = value;
    });
  }

  final _$_GameStateActionController = ActionController(name: '_GameState');

  @override
  void selectgame(Game g) {
    final _$actionInfo =
        _$_GameStateActionController.startAction(name: '_GameState.selectgame');
    try {
      return super.selectgame(g);
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void startgame() {
    final _$actionInfo =
        _$_GameStateActionController.startAction(name: '_GameState.startgame');
    try {
      return super.startgame();
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void getRandomquestion() {
    final _$actionInfo = _$_GameStateActionController.startAction(
        name: '_GameState.getRandomquestion');
    try {
      return super.getRandomquestion();
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void userAnswer(int answer, User u) {
    final _$actionInfo =
        _$_GameStateActionController.startAction(name: '_GameState.userAnswer');
    try {
      return super.userAnswer(answer, u);
    } finally {
      _$_GameStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedgame: ${selectedgame},
success: ${success},
state: ${state},
user: ${user},
started: ${started},
selectedanswer: ${selectedanswer},
controller: ${controller},
beforecontroller: ${beforecontroller}
    ''';
  }
}
