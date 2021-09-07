// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LoginState on _LoginState, Store {
  final _$logAtom = Atom(name: '_LoginState.log');

  @override
  Either<Failure, dynamic> get log {
    _$logAtom.reportRead();
    return super.log;
  }

  @override
  set log(Either<Failure, dynamic> value) {
    _$logAtom.reportWrite(value, super.log, () {
      super.log = value;
    });
  }

  final _$loggeduserAtom = Atom(name: '_LoginState.loggeduser');

  @override
  dynamic get loggeduser {
    _$loggeduserAtom.reportRead();
    return super.loggeduser;
  }

  @override
  set loggeduser(dynamic value) {
    _$loggeduserAtom.reportWrite(value, super.loggeduser, () {
      super.loggeduser = value;
    });
  }

  final _$_userFutureAtom = Atom(name: '_LoginState._userFuture');

  @override
  Future<Either<Failure, dynamic>> get _userFuture {
    _$_userFutureAtom.reportRead();
    return super._userFuture;
  }

  @override
  set _userFuture(Future<Either<Failure, dynamic>> value) {
    _$_userFutureAtom.reportWrite(value, super._userFuture, () {
      super._userFuture = value;
    });
  }

  final _$formKeyAtom = Atom(name: '_LoginState.formKey');

  @override
  GlobalKey<FormState> get formKey {
    _$formKeyAtom.reportRead();
    return super.formKey;
  }

  @override
  set formKey(GlobalKey<FormState> value) {
    _$formKeyAtom.reportWrite(value, super.formKey, () {
      super.formKey = value;
    });
  }

  final _$errorMessageAtom = Atom(name: '_LoginState.errorMessage');

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

  final _$startedgoogleloginAtom = Atom(name: '_LoginState.startedgooglelogin');

  @override
  bool get startedgooglelogin {
    _$startedgoogleloginAtom.reportRead();
    return super.startedgooglelogin;
  }

  @override
  set startedgooglelogin(bool value) {
    _$startedgoogleloginAtom.reportWrite(value, super.startedgooglelogin, () {
      super.startedgooglelogin = value;
    });
  }

  final _$startedfaceloginAtom = Atom(name: '_LoginState.startedfacelogin');

  @override
  bool get startedfacelogin {
    _$startedfaceloginAtom.reportRead();
    return super.startedfacelogin;
  }

  @override
  set startedfacelogin(bool value) {
    _$startedfaceloginAtom.reportWrite(value, super.startedfacelogin, () {
      super.startedfacelogin = value;
    });
  }

  final _$startedmailloginAtom = Atom(name: '_LoginState.startedmaillogin');

  @override
  bool get startedmaillogin {
    _$startedmailloginAtom.reportRead();
    return super.startedmaillogin;
  }

  @override
  set startedmaillogin(bool value) {
    _$startedmailloginAtom.reportWrite(value, super.startedmaillogin, () {
      super.startedmaillogin = value;
    });
  }

  final _$startloginAsyncAction = AsyncAction('_LoginState.startlogin');

  @override
  Future<dynamic> startlogin(dynamic context,
      {dynamic username,
      dynamic password,
      dynamic type,
      dynamic token,
      dynamic mail,
      dynamic isTablet = false,
      dynamic register = false}) {
    return _$startloginAsyncAction.run(() => super.startlogin(context,
        username: username,
        password: password,
        type: type,
        token: token,
        mail: mail,
        isTablet: isTablet,
        register: register));
  }

  final _$logoutAsyncAction = AsyncAction('_LoginState.logout');

  @override
  Future<dynamic> logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  @override
  String toString() {
    return '''
log: ${log},
loggeduser: ${loggeduser},
formKey: ${formKey},
errorMessage: ${errorMessage},
startedgooglelogin: ${startedgooglelogin},
startedfacelogin: ${startedfacelogin},
startedmaillogin: ${startedmaillogin}
    ''';
  }
}
