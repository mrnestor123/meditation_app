// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$RegisterState on _RegisterState, Store {
  final _$userAtom = Atom(name: '_RegisterState.user');

  @override
  dynamic get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(dynamic value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  final _$_userFutureAtom = Atom(name: '_RegisterState._userFuture');

  @override
  Future<Either<Failure, UserModel>> get _userFuture {
    _$_userFutureAtom.reportRead();
    return super._userFuture;
  }

  @override
  set _userFuture(Future<Either<Failure, UserModel>> value) {
    _$_userFutureAtom.reportWrite(value, super._userFuture, () {
      super._userFuture = value;
    });
  }

  final _$errorMessageAtom = Atom(name: '_RegisterState.errorMessage');

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

  final _$startedloginAtom = Atom(name: '_RegisterState.startedlogin');

  @override
  bool get startedlogin {
    _$startedloginAtom.reportRead();
    return super.startedlogin;
  }

  @override
  set startedlogin(bool value) {
    _$startedloginAtom.reportWrite(value, super.startedlogin, () {
      super.startedlogin = value;
    });
  }

  final _$registerAsyncAction = AsyncAction('_RegisterState.register');

  @override
  Future<dynamic> register(
      String username, String password, String confirmpassword, String email) {
    return _$registerAsyncAction
        .run(() => super.register(username, password, confirmpassword, email));
  }

  final _$googleLoginAsyncAction = AsyncAction('_RegisterState.googleLogin');

  @override
  Future<dynamic> googleLogin() {
    return _$googleLoginAsyncAction.run(() => super.googleLogin());
  }

  @override
  String toString() {
    return '''
user: ${user},
errorMessage: ${errorMessage},
startedlogin: ${startedlogin}
    ''';
  }
}
