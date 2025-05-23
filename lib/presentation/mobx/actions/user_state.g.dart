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

  final _$errorMessageAtom = Atom(name: '_UserState.errorMessage');

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

  final _$usersAtom = Atom(name: '_UserState.users');

  @override
  List<User> get users {
    _$usersAtom.reportRead();
    return super.users;
  }

  @override
  set users(List<User> value) {
    _$usersAtom.reportWrite(value, super.users, () {
      super.users = value;
    });
  }

  final _$filteredusersAtom = Atom(name: '_UserState.filteredusers');

  @override
  List<User> get filteredusers {
    _$filteredusersAtom.reportRead();
    return super.filteredusers;
  }

  @override
  set filteredusers(List<User> value) {
    _$filteredusersAtom.reportWrite(value, super.filteredusers, () {
      super.filteredusers = value;
    });
  }

  final _$loadingAtom = Atom(name: '_UserState.loading');

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  final _$dynamicusersAtom = Atom(name: '_UserState.dynamicusers');

  @override
  List<User> get dynamicusers {
    _$dynamicusersAtom.reportRead();
    return super.dynamicusers;
  }

  @override
  set dynamicusers(List<User> value) {
    _$dynamicusersAtom.reportWrite(value, super.dynamicusers, () {
      super.dynamicusers = value;
    });
  }

  final _$teachersAtom = Atom(name: '_UserState.teachers');

  @override
  List<User> get teachers {
    _$teachersAtom.reportRead();
    return super.teachers;
  }

  @override
  set teachers(List<User> value) {
    _$teachersAtom.reportWrite(value, super.teachers, () {
      super.teachers = value;
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

  final _$getTeachersAsyncAction = AsyncAction('_UserState.getTeachers');

  @override
  Future<dynamic> getTeachers() {
    return _$getTeachersAsyncAction.run(() => super.getTeachers());
  }

  final _$userisLoggedAsyncAction = AsyncAction('_UserState.userisLogged');

  @override
  Future<dynamic> userisLogged() {
    return _$userisLoggedAsyncAction.run(() => super.userisLogged());
  }

  final _$takeLessonAsyncAction = AsyncAction('_UserState.takeLesson');

  @override
  Future<bool> takeLesson(Content l) {
    return _$takeLessonAsyncAction.run(() => super.takeLesson(l));
  }

  final _$getDataAsyncAction = AsyncAction('_UserState.getData');

  @override
  Future<dynamic> getData() {
    return _$getDataAsyncAction.run(() => super.getData());
  }

  final _$followAsyncAction = AsyncAction('_UserState.follow');


  final _$changeNameAsyncAction = AsyncAction('_UserState.changeName');

  @override
  Future<dynamic> changeName(String username) {
    return _$changeNameAsyncAction.run(() => super.changeName(username));
  }

  final _$updateUserAsyncAction = AsyncAction('_UserState.updateUser');

  @override
  Future<dynamic> updateUser({User u}) {
    return _$updateUserAsyncAction.run(() => super.updateUser(u: u));
  }

  final _$changeImageAsyncAction = AsyncAction('_UserState.changeImage');

  @override
  Future<dynamic> changeImage(dynamic image) {
    return _$changeImageAsyncAction.run(() => super.changeImage(image));
  }

  final _$uploadFileAsyncAction = AsyncAction('_UserState.uploadFile');

  @override
  Future<String> uploadFile(
      {dynamic image, FilePickerResult audio, XFile video}) {
    return _$uploadFileAsyncAction
        .run(() => super.uploadFile(image: image, audio: audio, video: video));
  }

  final _$connectAsyncAction = AsyncAction('_UserState.connect');

  @override
  Future<dynamic> connect() {
    return _$connectAsyncAction.run(() => super.connect());
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
  Future<dynamic> closeStageUpdate() {
    final _$actionInfo = _$_UserStateActionController.startAction(
        name: '_UserState.closeStageUpdate');
    try {
      return super.closeStageUpdate();
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
errorMessage: ${errorMessage},
users: ${users},
filteredusers: ${filteredusers},
loading: ${loading},
dynamicusers: ${dynamicusers},
teachers: ${teachers},
lessondata: ${lessondata}
    ''';
  }
}
