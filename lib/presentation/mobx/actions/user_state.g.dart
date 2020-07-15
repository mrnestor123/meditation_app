// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserState on _UserState, Store {
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

  final _$_isUserCachedAtom = Atom(name: '_UserState._isUserCached');

  @override
  Either<Failure, User> get _isUserCached {
    _$_isUserCachedAtom.context.enforceReadPolicy(_$_isUserCachedAtom);
    _$_isUserCachedAtom.reportObserved();
    return super._isUserCached;
  }

  @override
  set _isUserCached(Either<Failure, User> value) {
    _$_isUserCachedAtom.context.conditionallyRunInAction(() {
      super._isUserCached = value;
      _$_isUserCachedAtom.reportChanged();
    }, _$_isUserCachedAtom, name: '${_$_isUserCachedAtom.name}_set');
  }

  final _$userisLoggedAsyncAction = AsyncAction('userisLogged');

  @override
  Future<dynamic> userisLogged() {
    return _$userisLoggedAsyncAction.run(() => super.userisLogged());
  }

  final _$takeMeditationAsyncAction = AsyncAction('takeMeditation');

  @override
  Future<dynamic> takeMeditation(Duration d) {
    return _$takeMeditationAsyncAction.run(() => super.takeMeditation(d));
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
  String toString() {
    final string = 'user: ${user.toString()},loggedin: ${loggedin.toString()}';
    return '{$string}';
  }
}
