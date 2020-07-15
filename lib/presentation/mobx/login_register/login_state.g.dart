// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$LoginState on _LoginState, Store {
  final _$logAtom = Atom(name: '_LoginState.log');

  @override
  Either<Failure, User> get log {
    _$logAtom.context.enforceReadPolicy(_$logAtom);
    _$logAtom.reportObserved();
    return super.log;
  }

  @override
  set log(Either<Failure, User> value) {
    _$logAtom.context.conditionallyRunInAction(() {
      super.log = value;
      _$logAtom.reportChanged();
    }, _$logAtom, name: '${_$logAtom.name}_set');
  }

  final _$loggeduserAtom = Atom(name: '_LoginState.loggeduser');

  @override
  User get loggeduser {
    _$loggeduserAtom.context.enforceReadPolicy(_$loggeduserAtom);
    _$loggeduserAtom.reportObserved();
    return super.loggeduser;
  }

  @override
  set loggeduser(User value) {
    _$loggeduserAtom.context.conditionallyRunInAction(() {
      super.loggeduser = value;
      _$loggeduserAtom.reportChanged();
    }, _$loggeduserAtom, name: '${_$loggeduserAtom.name}_set');
  }

  final _$_userFutureAtom = Atom(name: '_LoginState._userFuture');

  @override
  Future<Either<Failure, User>> get _userFuture {
    _$_userFutureAtom.context.enforceReadPolicy(_$_userFutureAtom);
    _$_userFutureAtom.reportObserved();
    return super._userFuture;
  }

  @override
  set _userFuture(Future<Either<Failure, User>> value) {
    _$_userFutureAtom.context.conditionallyRunInAction(() {
      super._userFuture = value;
      _$_userFutureAtom.reportChanged();
    }, _$_userFutureAtom, name: '${_$_userFutureAtom.name}_set');
  }

  final _$errorMessageAtom = Atom(name: '_LoginState.errorMessage');

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

  final _$startedloginAtom = Atom(name: '_LoginState.startedlogin');

  @override
  bool get startedlogin {
    _$startedloginAtom.context.enforceReadPolicy(_$startedloginAtom);
    _$startedloginAtom.reportObserved();
    return super.startedlogin;
  }

  @override
  set startedlogin(bool value) {
    _$startedloginAtom.context.conditionallyRunInAction(() {
      super.startedlogin = value;
      _$startedloginAtom.reportChanged();
    }, _$startedloginAtom, name: '${_$startedloginAtom.name}_set');
  }

  final _$loginAsyncAction = AsyncAction('login');

  @override
  Future<dynamic> login(String username, String password) {
    return _$loginAsyncAction.run(() => super.login(username, password));
  }

  @override
  String toString() {
    final string =
        'log: ${log.toString()},loggeduser: ${loggeduser.toString()},errorMessage: ${errorMessage.toString()},startedlogin: ${startedlogin.toString()}';
    return '{$string}';
  }
}
