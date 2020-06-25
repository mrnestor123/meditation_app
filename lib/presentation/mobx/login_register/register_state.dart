import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/auth/email_address.dart';
import 'package:meditation_app/domain/usecases/user/registerUser.dart';
import 'package:mobx/mobx.dart';

part 'register_state.g.dart';

class RegisterState extends _RegisterState with _$RegisterState {
  RegisterState({RegisterUseCase registerUseCase})
      : super(register: registerUseCase);
}

enum StoreState { initial, loading, loaded }

abstract class _RegisterState with Store {
  RegisterUseCase _registerusecase;

  @observable
  var user;

  @observable
  Future<Either<Failure, UserModel>> _userFuture;

  @observable
  String errorMessage = "";

  @observable
  bool startedlogin = false;

  _RegisterState({@required RegisterUseCase register}) {
    _registerusecase = register;
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
  Future register(
    String username,
    String password,
    String confirmpassword,
    String email,
  ) async {
    var user = await _registerusecase.call(UserParams(
        password: password,
        confirmpassword: confirmpassword,
        mail: email,
        stagenumber: 1,
        usuario: username));

    user.fold((failure) {
      errorMessage = _mapFailureToMessage(failure);
    }, (user) {
      print('user has been registered correctly');
    });
  }

  String _mapFailureToMessage(Failure failure) {
    // Instead of a regular 'if (failure is ServerFailure)...'
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server failure';
      case CacheFailure:
        return 'Cache failure';
      case RegisterFailure:
        return failure.error;
      default:
        return 'Unexpected Error';
    }
  }
}
