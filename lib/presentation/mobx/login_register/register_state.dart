import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/auth/email_address.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
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

  FirebaseAuth auth = FirebaseAuth.instance;
  final googleSignin = GoogleSignIn();

  _RegisterState({@required RegisterUseCase register}) {
    _registerusecase = register;
  }

  String your_client_id = "445064026505232";
  String your_redirect_url =
      "https://www.facebook.com/connect/login_success.html";

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

  //Una vez registrados en firebase auth
  Future<UserModel> userRegistered(FirebaseUser firebaseuser) async {
    firebaseuser.sendEmailVerification();
    var register = await _registerusecase.call(UserParams(user: firebaseuser));

    register.fold((Failure failure) {
      errorMessage = _mapFailureToMessage(failure);
    }, (User u) {
      user = u;
      //user = u;
    });
  }

  //Hay que comprobar si el password es el mismo que confirmpassword. MIRAR ALGÚN VIDEO DE YOUTUBE
  @action
  Future register(
    String username,
    String password,
    String confirmpassword,
    String email,
  ) async {
    try {
      AuthResult result =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: confirmpassword,
      );
      FirebaseUser user = result.user;
      var userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = username;
      user.updateProfile(userUpdateInfo);
      await userRegistered(user);
    } catch (e) {
      if (e.code == 'weak-password') {
        errorMessage = "The password provided is too weak";
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "The account already exists for that email";
      }
      errorMessage = e.code;
      print(e.code);
    }
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

  Future registerWithFacebook(String token) async {
    final facebookAuthCred =
        FacebookAuthProvider.getCredential(accessToken: token);
    final user = await auth.signInWithCredential(facebookAuthCred);
    await userRegistered(user.user);
  }

  @action
  Future googleLogin() async {
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
        print('registered user');
        await userRegistered(user);
      }
    } catch (e) {
      print(e);
    }

    return null;
  }
}
