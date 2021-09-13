import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/usecases/usecase.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';
import 'package:meditation_app/domain/usecases/user/log_out.dart';
import 'package:meditation_app/domain/usecases/user/loginUser.dart';
import 'package:meditation_app/domain/usecases/user/registerUser.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:mobx/mobx.dart';

part 'login_state.g.dart';

class LoginState extends _LoginState with _$LoginState {
  LoginState({ UserRepository repository}) : 
  super(repository: repository);
}

//ESTO QUE ES ??
enum StoreState { initial, loading, loaded }

abstract class _LoginState with Store {

  UserRepository repository;

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

  bool startedlogin = false;

  @observable
  bool startedgooglelogin= false;
  @observable 
  bool  startedfacelogin = false;
  @observable 
  bool startedmaillogin = false;


  FirebaseAuth auth = FirebaseAuth.instance;
  final googleSignin = GoogleSignIn();

  _LoginState({this.repository});


  /*
  JUNTAR STARTLOGIN Y STARTREGISTER EN LA MISMA !!!!!
  */
  @action
  Future startlogin(context,{username, password, type, token, mail, isTablet = false, register = false}) async {
    startedlogin = true;
    FocusScopeNode currentFocus = FocusScope.of(context);
    String errormsg;
    var user;

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    try {
      if(type == 'mail'){
          startedmaillogin = true;
          if(formKey.currentState.validate()){
            if(register){
              user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: mail,
              password: password,
            );    
            }else{
            user = await auth.signInWithEmailAndPassword(email: username, password: password);
            }
          }
      } else if(type =='google'){
          startedgooglelogin = true;
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
          startedfacelogin = true;
          final facebookAuthCred = FacebookAuthProvider.credential(token);
          user = await auth.signInWithCredential(facebookAuthCred);
      }

      if(user != null) {
        if(register){
            user.user.sendEmailVerification();
            var register = await repository.registerUser(usuario: user.user);

            register.fold(
              (Failure failure) => errormsg = _mapFailureToMessage(failure), 
              (dynamic u) => loggeduser = u
              );
        }else{
          log = await repository.loginUser(usuario: user.user);
          log.fold(
            (Failure f) => errormsg = _mapFailureToMessage(f), 
            (dynamic u) => loggeduser = u
          );
        }
      }
    }on PlatformException catch (e) {
      print(e);
      errormsg = 'An unexpected error has ocurred';
    }on FirebaseAuthException catch (e) {
      // simply passing error code as a message
      print(e.code);
      if(e.message != null) {
        errormsg = e.message;
      }else{
       errormsg = switchExceptions(e.code);
      }
    }on Exception catch (e){
      errormsg ='An unexpected error has ocurred';
    }

    startedlogin = false;
    startedfacelogin = false;
    startedgooglelogin = false;
    startedmaillogin = false;

    if (loggeduser != null && user != null) {
      if(loggeduser.nombre == null){
        Navigator.pushReplacementNamed(context, '/setdata');
      }else{
        Navigator.pushReplacementNamed(context, '/main');
      }
    } else if(errormsg != null && errormsg != ''){
      if(type == 'google' && user != null){
        googleSignin.disconnect();
      }
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
    loggeduser = null;
    googleSignin.disconnect();
    auth.signOut();
    await repository.logout();
  }

  /*
  @action
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
            startedlogin = true;
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
        startedlogin = true;
      } else {
        final facebookAuthCred = FacebookAuthProvider.credential(token);
        user = await auth.signInWithCredential(facebookAuthCred);
        startedlogin = true;
      }

      if(user != null){
        errormsg = await userRegistered(user.user);
      }
    }on PlatformException catch (e) {
      print(e);
    }on FirebaseAuthException catch (e) {
      errormsg = switchExceptions(e.code);
    }

    
    startedlogin = false;
    if (loggeduser != null) {
      Navigator.pushReplacementNamed(context, '/setdata');
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
  }*/



  String _mapFailureToMessage(Failure failure) {
    // Instead of a regular 'if (failure is ServerFailure)...'
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server failure';
      case CacheFailure:
        return 'Cache failure';
      case LoginFailure: 
        return failure.error != null ? failure.error : 'User not found in the database';
      default:
        return 'Unexpected Error';
    }
  }
}
