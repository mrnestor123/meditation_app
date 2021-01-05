import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  Either<Failure, User> log;

  @observable
  User loggeduser;

  @observable
  Future<Either<Failure, User>> _userFuture;

  @observable
  String errorMessage = "";

  @observable
  bool startedlogin = false;

  FirebaseAuth auth = FirebaseAuth.instance;
  final googleSignin = GoogleSignIn();

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
        _userFuture = _loginusecase(
            UserParams(usuario: username.trim(), password: password.trim()));
        log = await _userFuture;
        log.fold(
            (Failure f) => errorMessage = f.error, (User u) => loggeduser = u);
      } on Failure {
        errorMessage = 'Could not log user';
      }
    } else {
      errorMessage = 'Please fill user and password fields';
    }
  }

  // instead of returning true or false
// returning user to directly access UserID
  Future<FirebaseUser> signin(
      String email, String password, BuildContext context) async {
    try {
      AuthResult result =
          await auth.signInWithEmailAndPassword(email: email, password: email);
      FirebaseUser user = result.user;
      // return Future.value(true);
      return Future.value(user);
    } catch (e) {
      // simply passing error code as a message
      print(e.code);
      switch (e.code) {
        case 'ERROR_INVALID_EMAIL':
          //showErrDialog(context, e.code);
          break;
        case 'ERROR_WRONG_PASSWORD':
          //   showErrDialog(context, e.code);
          break;
        case 'ERROR_USER_NOT_FOUND':
          // showErrDialog(context, e.code);
          break;
        case 'ERROR_USER_DISABLED':
          // showErrDialog(context, e.code);
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
          //  showErrDialog(context, e.code);
          break;
        case 'ERROR_OPERATION_NOT_ALLOWED':
          //showErrDialog(context, e.code);
          break;
      }
      // since we are not actually continuing after displaying errors
      // the false value will not be returned
      // hence we don't have to check the valur returned in from the signin function
      // whenever we call it anywhere
      return Future.value(null);
    }
  }

  @action
  Future<bool> googleLogin() async {
    try {
      GoogleSignInAccount googleSignInAccount = await googleSignin.signIn();

      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.getCredential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        AuthResult result = await auth.signInWithCredential(credential);

        FirebaseUser user = await auth.currentUser();
        print(user);
        print(user.uid);

        return Future.value(true);
      }
    } catch (e) {
      print(e);
    }

    return Future.value(false);
  }

  loginWithFacebook(String token) async {
    final facebookAuthCred =
        FacebookAuthProvider.getCredential(accessToken: token);
    final user = await auth.signInWithCredential(facebookAuthCred);
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
