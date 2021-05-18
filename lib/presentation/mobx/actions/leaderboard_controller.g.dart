// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LeaderBoardController on _LeaderBoardController, Store {
  final _$isSearchingAtom = Atom(name: '_LeaderBoardController.isSearching');

  @override
  bool get isSearching {
    _$isSearchingAtom.reportRead();
    return super.isSearching;
  }

  @override
  set isSearching(bool value) {
    _$isSearchingAtom.reportWrite(value, super.isSearching, () {
      super.isSearching = value;
    });
  }

  final _$modeAtom = Atom(name: '_LeaderBoardController.mode');

  @override
  String get mode {
    _$modeAtom.reportRead();
    return super.mode;
  }

  @override
  set mode(String value) {
    _$modeAtom.reportWrite(value, super.mode, () {
      super.mode = value;
    });
  }

  final _$totalusersAtom = Atom(name: '_LeaderBoardController.totalusers');

  @override
  List<User> get totalusers {
    _$totalusersAtom.reportRead();
    return super.totalusers;
  }

  @override
  set totalusers(List<User> value) {
    _$totalusersAtom.reportWrite(value, super.totalusers, () {
      super.totalusers = value;
    });
  }

  final _$followedusersAtom =
      Atom(name: '_LeaderBoardController.followedusers');

  @override
  List<User> get followedusers {
    _$followedusersAtom.reportRead();
    return super.followedusers;
  }

  @override
  set followedusers(List<User> value) {
    _$followedusersAtom.reportWrite(value, super.followedusers, () {
      super.followedusers = value;
    });
  }

  final _$_LeaderBoardControllerActionController =
      ActionController(name: '_LeaderBoardController');

  @override
  void search() {
    final _$actionInfo = _$_LeaderBoardControllerActionController.startAction(
        name: '_LeaderBoardController.search');
    try {
      return super.search();
    } finally {
      _$_LeaderBoardControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void switchtab() {
    final _$actionInfo = _$_LeaderBoardControllerActionController.startAction(
        name: '_LeaderBoardController.switchtab');
    try {
      return super.switchtab();
    } finally {
      _$_LeaderBoardControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void startsearch(String user) {
    final _$actionInfo = _$_LeaderBoardControllerActionController.startAction(
        name: '_LeaderBoardController.startsearch');
    try {
      return super.startsearch(user);
    } finally {
      _$_LeaderBoardControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isSearching: ${isSearching},
mode: ${mode},
totalusers: ${totalusers},
followedusers: ${followedusers}
    ''';
  }
}
