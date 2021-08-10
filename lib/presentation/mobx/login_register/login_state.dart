import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/usecases/usecase.dart';
import 'package:meditation_app/domain/usecases/user/log_out.dart';
import 'package:meditation_app/domain/usecases/user/loginUser.dart';
import 'package:meditation_app/domain/usecases/user/registerUser.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:mobx/mobx.dart';

part 'login_state.g.dart';

class LoginState extends _LoginState with _$LoginState {
  LoginState({LoginUseCase loginUseCase, RegisterUseCase registerUseCase, LogOutUseCase logout}) : 
  super(login: loginUseCase, register: registerUseCase,logoutusecase: logout);
}

enum StoreState { initial, loading, loaded }

abstract class _LoginState with Store {
  LoginUseCase _loginusecase;
  LogOutUseCase logoutusecase;


  @observable
  Either<Failure, dynamic> log;

  RegisterUseCase _registerusecase;

  @observable
  dynamic loggeduser;

  @observable
  Future<Either<Failure, dynamic>> _userFuture;
  

  @observable 
  //valida el login y el register tanto en tablet como en móvil
  var formKey = GlobalKey<FormState>();

  final TextEditingController userController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  @observable
  String errorMessage = "";

  @observable
  bool startedlogin = false;

  FirebaseAuth auth = FirebaseAuth.instance;
  final googleSignin = GoogleSignIn();

  _LoginState({@required LoginUseCase login, RegisterUseCase register,this.logoutusecase}) {
    _loginusecase = login;
    _registerusecase = register;
  }

  Future startlogin(context,{username, password, type, token, isTablet = false}) async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    String errormsg;
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    try {
      var user;

      if(type == 'mail'){
          if(formKey.currentState.validate()){
          user = await auth.signInWithEmailAndPassword(email: username, password: password);
          }
      } else if(type =='google'){
          //hay que desconectar !!
          //googleSignin.disconnect();
          GoogleSignInAccount googleSignInAccount = await googleSignin.signIn();

        if (googleSignInAccount != null) {
          GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
          AuthCredential credential = GoogleAuthProvider.credential(
              idToken: googleSignInAuthentication.idToken,
              accessToken: googleSignInAuthentication.accessToken);
          user = await auth.signInWithCredential(credential);
        }
      } else {
          final facebookAuthCred = FacebookAuthProvider.credential(token);
          user = await auth.signInWithCredential(facebookAuthCred);
      }

      if(user != null) {
        _userFuture = _loginusecase(UserParams(usuario: user.user));
        log = await _userFuture;
        log.fold(
          (Failure f) => errormsg = _mapFailureToMessage(f), 
          (dynamic u) => loggeduser = u
        );
      }
    }on PlatformException catch (e) {
      print(e);
    }on FirebaseAuthException catch (e) {
      // simply passing error code as a message
      print(e.code);
      errormsg = switchExceptions(e.code);
    }

    if (loggeduser != null) {
      Navigator.pushReplacementNamed(context, '/main');
    } else if(errormsg != null && errormsg != ''){
      print(errormsg);
      //habra que hacer la versión tablet de esto !!
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: isTablet ? SnackBarBehavior.floating : SnackBarBehavior.floating,
          margin: isTablet ? EdgeInsets.all(20.0) : EdgeInsets.all(0.0),
          content: Container(
            padding: EdgeInsets.all(12.0),
            child: Row(
              children: [
                SizedBox(width: 10),
                Icon(Icons.error_outline_rounded, color: Colors.red, size: Configuration.medicon),
                SizedBox(width: 10),
                Expanded(
                  child:Text(errormsg, style: isTablet ? Configuration.tabletText('small', Colors.white) : Configuration.text('small', Colors.white))
                ),
              ],
            )
          ),
        ),
      );
    }
  }


  String switchExceptions(exception){
    //añadir mas excepciones !!
    switch(exception) {
      case 'user-not-found': return 'User not Found';
      case 'wrong-password': return 'Password is invalid';
      case 'account-exists-with-different-credential': return 'Account exists with different credential';
      case 'weak-password': return 'The password is too weak';
      case 'email-already-in-use': return 'The account already exists for that email';
      default: return 'An error has ocurred';
    }
  }

  bool validateMail(String input){
    const emailRegex = r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";
    
    if (RegExp(emailRegex).hasMatch(input)) {
      return true;
    }
    return false;
  }


  @action
  Future logout() async {
    googleSignin.disconnect();
    auth.signOut();
    await logoutusecase.call(NoParams());
  }


  Future startRegister(context, {username, password, mail, type, token}) async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    String errormsg;
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    try {
      var user;
      if(type == 'mail'){
        if(formKey.currentState.validate()){
            user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: mail,
              password: password,
            );        
        }
      }else if(type =='google'){
        GoogleSignInAccount googleSignInAccount = await googleSignin.signIn();

        if (googleSignInAccount != null) {
          GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
          AuthCredential credential = GoogleAuthProvider.credential(
              idToken: googleSignInAuthentication.idToken,
              accessToken: googleSignInAuthentication.accessToken);
          user = await auth.signInWithCredential(credential);
        }
      } else {
        final facebookAuthCred = FacebookAuthProvider.credential(token);
        user = await auth.signInWithCredential(facebookAuthCred);
      }

      if(user != null){
        errormsg = await userRegistered(user.user);
      }
    }on PlatformException catch (e) {
      print(e);
    }on FirebaseAuthException catch (e) {
      errormsg = switchExceptions(e.code);
    }

    if (loggeduser != null) {
      Navigator.pushReplacementNamed(context, '/setdata');
      Navigator.pushReplacementNamed(context, '/main');
    } else if(errormsg != null) {
      //habra que hacer la versión tablet de esto !!
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            padding: EdgeInsets.all(12.0),
            child: Row(
              children: [
                SizedBox(width: 10),
                Icon(Icons.error_outline_rounded, color: Colors.red, size: Configuration.medicon),
                SizedBox(width: 10),
                Expanded(
                  child:Text(errormsg, style: Configuration.text('small', Colors.white))
                ),
              ],
            )
          ),
        ),
      );
    }
  }

  //SE UTILIZA ??
  Future userRegistered(dynamic firebaseuser) async {
    firebaseuser.sendEmailVerification();
    var register = await _registerusecase.call(RegisterParams(user: firebaseuser));

    register.fold((Failure failure) {
      return _mapFailureToMessage(failure);
    }, (dynamic u) {
      loggeduser = u;
      //user = u;
    });
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
