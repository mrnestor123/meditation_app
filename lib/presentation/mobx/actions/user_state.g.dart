// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserState on _UserState, Store {
  final _$userAtom = Atom(name: '_UserState.user');

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

  final _$dataAtom = Atom(name: '_UserState.data');

  @override
  DataBase get data {
    _$dataAtom.reportRead();
    return super.data;
  }

  @override
  set data(DataBase value) {
    _$dataAtom.reportWrite(value, super.data, () {
      super.data = value;
    });
  }

  final _$nightmodeAtom = Atom(name: '_UserState.nightmode');

  @override
  bool get nightmode {
    _$nightmodeAtom.reportRead();
    return super.nightmode;
  }

  @override
  set nightmode(bool value) {
    _$nightmodeAtom.reportWrite(value, super.nightmode, () {
      super.nightmode = value;
    });
  }

  final _$loggedinAtom = Atom(name: '_UserState.loggedin');

  @override
  bool get loggedin {
    _$loggedinAtom.reportRead();
    return super.loggedin;
  }

  @override
  set loggedin(bool value) {
    _$loggedinAtom.reportWrite(value, super.loggedin, () {
      super.loggedin = value;
    });
  }

  final _$lessondataAtom = Atom(name: '_UserState.lessondata');

  @override
  Map<dynamic, dynamic> get lessondata {
    _$lessondataAtom.reportRead();
    return super.lessondata;
  }

  @override
  set lessondata(Map<dynamic, dynamic> value) {
    _$lessondataAtom.reportWrite(value, super.lessondata, () {
      super.lessondata = value;
    });
  }

  final _$userisLoggedAsyncAction = AsyncAction('_UserState.userisLogged');

  @override
  Future<dynamic> userisLogged() {
    return _$userisLoggedAsyncAction.run(() => super.userisLogged());
  }

  final _$takeLessonAsyncAction = AsyncAction('_UserState.takeLesson');

  @override
  Future<bool> takeLesson(LessonModel l) {
    return _$takeLessonAsyncAction.run(() => super.takeLesson(l));
  }

  final _$getDataAsyncAction = AsyncAction('_UserState.getData');

  @override
  Future<dynamic> getData() {
    return _$getDataAsyncAction.run(() => super.getData());
  }

  final _$followAsyncAction = AsyncAction('_UserState.follow');

  @override
  Future<dynamic> follow(User u, bool follow) {
    return _$followAsyncAction.run(() => super.follow(u, follow));
  }

  final _$changeNameAsyncAction = AsyncAction('_UserState.changeName');

  @override
  Future<dynamic> changeName(String username) {
    return _$changeNameAsyncAction.run(() => super.changeName(username));
  }

  final _$updateUserAsyncAction = AsyncAction('_UserState.updateUser');

  @override
  Future<dynamic> updateUser(dynamic variable, String type) {
    return _$updateUserAsyncAction.run(() => super.updateUser(variable, type));
  }

  final _$updateStageAsyncAction = AsyncAction('_UserState.updateStage');

  @override
  Future<dynamic> updateStage() {
    return _$updateStageAsyncAction.run(() => super.updateStage());
  }

  final _$_UserStateActionController = ActionController(name: '_UserState');

  @override
  void setUser(dynamic u) {
    final _$actionInfo =
        _$_UserStateActionController.startAction(name: '_UserState.setUser');
    try {
      return super.setUser(u);
    } finally {
      _$_UserStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
user: ${user},
data: ${data},
nightmode: ${nightmode},
loggedin: ${loggedin},
lessondata: ${lessondata}
    ''';
  }
}
