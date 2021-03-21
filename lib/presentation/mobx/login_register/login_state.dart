import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meditation_app/core/error/failures.dart';
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
  Either<Failure, dynamic> log;

  @observable
  dynamic loggeduser;

  @observable
  Future<Either<Failure, dynamic>> _userFuture;

  @observable
  String errorMessage = "";

  @observable
  bool startedlogin = false;

  FirebaseAuth auth = FirebaseAuth.instance;
  final googleSignin = GoogleSignIn();

  _LoginState({@required LoginUseCase login}) {
    _loginusecase = login;
  }

  @action
  Future login(var user) async {
    startedlogin = true;
    // Reset the possible previous error message.
    try {
      errorMessage = "";
      _userFuture = _loginusecase(UserParams(usuario: user));
      log = await _userFuture;
      log.fold(
          (Failure f) => errorMessage = f.error, (dynamic u) => loggeduser = u);
    } on Failure {
      errorMessage = 'Could not log user';
    }
  }

  // instead of returning true or false
// returning user to directly access UserID
  Future signin(String email, String password) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(email: email, password: email);
      var user = result.user;
      
      await login(user);

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
  Future googleLogin() async {
    try {
      GoogleSignInAccount googleSignInAccount = await googleSignin.signIn();

      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        UserCredential result = await auth.signInWithCredential(credential);

        var user = auth.currentUser;

        await login(user);

        return Future.value(true);
      }
    } catch (e) {
      print(e);
    }

    return Future.value(false);
  }

  Future loginWithFacebook(String token) async {
    final facebookAuthCred = FacebookAuthProvider.credential(token);
    final user = await auth.signInWithCredential(facebookAuthCred);
    await login(user.user);
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
