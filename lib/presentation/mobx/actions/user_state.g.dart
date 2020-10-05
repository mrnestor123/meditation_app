// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserState on _UserState, Store {
  Computed<int> _$menuindexComputed;

  @override
  int get menuindex =>
      (_$menuindexComputed ??= Computed<int>(() => super.menuindex)).value;

  final _$userAtom = Atom(name: '_UserState.user');

  @override
  User get user {
    _$userAtom.context.enforceReadPolicy(_$userAtom);
    _$userAtom.reportObserved();
    return super.user;
  }

  @override
  set user(User value) {
    _$userAtom.context.conditionallyRunInAction(() {
      super.user = value;
      _$userAtom.reportChanged();
    }, _$userAtom, name: '${_$userAtom.name}_set');
  }

  final _$nightmodeAtom = Atom(name: '_UserState.nightmode');

  @override
  bool get nightmode {
    _$nightmodeAtom.context.enforceReadPolicy(_$nightmodeAtom);
    _$nightmodeAtom.reportObserved();
    return super.nightmode;
  }

  @override
  set nightmode(bool value) {
    _$nightmodeAtom.context.conditionallyRunInAction(() {
      super.nightmode = value;
      _$nightmodeAtom.reportChanged();
    }, _$nightmodeAtom, name: '${_$nightmodeAtom.name}_set');
  }

  final _$loggedinAtom = Atom(name: '_UserState.loggedin');

  @override
  bool get loggedin {
    _$loggedinAtom.context.enforceReadPolicy(_$loggedinAtom);
    _$loggedinAtom.reportObserved();
    return super.loggedin;
  }

  @override
  set loggedin(bool value) {
    _$loggedinAtom.context.conditionallyRunInAction(() {
      super.loggedin = value;
      _$loggedinAtom.reportChanged();
    }, _$loggedinAtom, name: '${_$loggedinAtom.name}_set');
  }

  final _$lessondataAtom = Atom(name: '_UserState.lessondata');

  @override
  Map<dynamic, dynamic> get lessondata {
    _$lessondataAtom.context.enforceReadPolicy(_$lessondataAtom);
    _$lessondataAtom.reportObserved();
    return super.lessondata;
  }

  @override
  set lessondata(Map<dynamic, dynamic> value) {
    _$lessondataAtom.context.conditionallyRunInAction(() {
      super.lessondata = value;
      _$lessondataAtom.reportChanged();
    }, _$lessondataAtom, name: '${_$lessondataAtom.name}_set');
  }

  final _$_menuindexAtom = Atom(name: '_UserState._menuindex');

  @override
  int get _menuindex {
    _$_menuindexAtom.context.enforceReadPolicy(_$_menuindexAtom);
    _$_menuindexAtom.reportObserved();
    return super._menuindex;
  }

  @override
  set _menuindex(int value) {
    _$_menuindexAtom.context.conditionallyRunInAction(() {
      super._menuindex = value;
      _$_menuindexAtom.reportChanged();
    }, _$_menuindexAtom, name: '${_$_menuindexAtom.name}_set');
  }

  final _$userisLoggedAsyncAction = AsyncAction('userisLogged');

  @override
  Future<dynamic> userisLogged() {
    return _$userisLoggedAsyncAction.run(() => super.userisLogged());
  }

  final _$takeMeditationAsyncAction = AsyncAction('takeMeditation');

  @override
  Future<List<Mission>> takeMeditation(Duration d) {
    return _$takeMeditationAsyncAction.run(() => super.takeMeditation(d));
  }

  final _$takeLessonAsyncAction = AsyncAction('takeLesson');

  @override
  Future<List<Mission>> takeLesson(LessonModel l) {
    return _$takeLessonAsyncAction.run(() => super.takeLesson(l));
  }

  final _$getDataAsyncAction = AsyncAction('getData');

  @override
  Future<dynamic> getData() {
    return _$getDataAsyncAction.run(() => super.getData());
  }

  final _$logoutAsyncAction = AsyncAction('logout');

  @override
  Future<dynamic> logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  final _$_UserStateActionController = ActionController(name: '_UserState');

  @override
  void setUser(dynamic u) {
    final _$actionInfo = _$_UserStateActionController.startAction();
    try {
      return super.setUser(u);
    } finally {
      _$_UserStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeBottomMenu(int stage) {
    final _$actionInfo = _$_UserStateActionController.startAction();
    try {
      return super.changeBottomMenu(stage);
    } finally {
      _$_UserStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string =
        'user: ${user.toString()},nightmode: ${nightmode.toString()},loggedin: ${loggedin.toString()},lessondata: ${lessondata.toString()},menuindex: ${menuindex.toString()}';
    return '{$string}';
  }
}
