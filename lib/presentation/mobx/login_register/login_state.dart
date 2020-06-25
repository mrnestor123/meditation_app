import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/usecases/user/loginUser.dart';
import 'package:mobx/mobx.dart';

part 'login_state.g.dart';

class LoginState extends _LoginState with _$LoginState {
  LoginState({LoginUseCase loginUseCase}) : super(login: loginUseCase);
}

enum StoreState { initial, loading, loaded }

abstract class _LoginState with Store {
  LoginUseCase _loginusecase;

  @observable
  var user;

  @observable
  Future<Either<Failure, User>> _userFuture;

  @observable
  String errorMessage = "";

  @observable
  bool startedlogin = false;

  _LoginState({@required LoginUseCase login}) {
    _loginusecase = login;
  }

  // @computed
  // StoreState get state {
    // If the user has not yet searched for a weather forecast or there has been an error
    // if (_userFuture == null && !startedlogin) {
      // return StoreState.initial;
    // } else if (startedlogin && _userFuture == null) {
      // return StoreState.loading;
    // } else {
      // return StoreState.loaded;
    // }
    // Pending Future means "loading"
    // Fulfilled Future means "loaded"
    //  } return //_userFuture.status == FutureStatus.pending
    //? StoreState.loading
    //: StoreState.loaded;
  // }

  @action
  Future login(String username, String password) async {
    if (username != "" && password != "") {
      startedlogin = true;
      // Reset the possible previous error message.
      try {
        errorMessage = "";
        _userFuture =
            _loginusecase(UserParams(usuario: username, password: password));
        user = await _userFuture;
        print(user);
      } on Failure {
        errorMessage = ' Could not log user';
      }
    }else{
      errorMessage= 'Please fill user and password fields';
    }
  }

  String _mapFailureToMessage(Failure failure) {
    // Instead of a regular 'if (failure is ServerFailure)...'
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server failure';
      case CacheFailure:
        return 'Cache failure';
      default:
        return 'Unexpected Error';
    }
  }
}
