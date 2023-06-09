import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/layout.dart';
import 'package:meditation_app/presentation/pages/main.dart';
import 'package:meditation_app/presentation/pages/welcome/carrousel_intro.dart';
import 'package:meditation_app/presentation/pages/welcome/set_user_data.dart';
import 'package:mobx/mobx.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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

  @action
  Future startlogin(context,{username, password, type, token, mail, isTablet = false, register = false}) async {
    startedlogin = true;
    FocusScopeNode currentFocus = FocusScope.of(context);
    String errormsg;
    var user;

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    } 

    //PASAR TODO ESTO AL SERVER !!!! :(
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
            accessToken: googleSignInAuthentication.accessToken
          );

          user = await auth.signInWithCredential(credential);
        }
      } else if(type=='apple'){
        AuthorizationCredentialAppleID appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          
        );

        final credential = OAuthProvider("apple.com").credential(
          idToken: appleCredential.identityToken,
          accessToken: appleCredential.authorizationCode,
        );

        user = await auth.signInWithCredential(credential);
     
      } else {
        startedfacelogin = true;
        final facebookAuthCred = FacebookAuthProvider.credential(token);
        user = await auth.signInWithCredential(facebookAuthCred);
      }

      if(user != null) {
        if(register){
          
          var register = await repository.registerUser(usuario: user.user);

          register.fold(
            (Failure failure) => errormsg = _mapFailureToMessage(failure), 
            // SOLO eN EL CASO DE QUE SE REGISTRE CON MAIL
            (dynamic u) {
              user.user.sendEmailVerification();
              loggeduser = u;
            }
          );
        }else {
          log = await repository.loginUser(usuario: user.user);

          log.fold(
            (Failure f) => errormsg = _mapFailureToMessage(f), 
            (dynamic u) => loggeduser = u
          );
        }
      }
    }on PlatformException catch (e) {
      print(e);
      errormsg = 'Could not connect to the server';
    }on FirebaseAuthException catch (e) {
      // simply passing error code as a message
      
      if(e.message != null) {
        errormsg = e.message;
      }else{
       errormsg = switchExceptions(e.code);
      }
    }on Exception catch (e){
      print(e.toString());

      errormsg ='Could not connect to the server';
    }

    startedlogin = false;
    startedfacelogin = false;
    startedgooglelogin = false;
    startedmaillogin = false;

    if (loggeduser != null && user != null) {
       if(loggeduser.nombre == null){
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SetUserData()),
          (Route<dynamic> route) => false
        );
      }else{
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Layout()),
          (Route<dynamic> route) => false,
        );
      }
    } else if(errormsg != null && errormsg != ''){
      if(type == 'google' && user != null){
        googleSignin.disconnect();
      }

      //habra que hacer la versión tablet de esto !!
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(

          
          duration: Duration(seconds: 5),
          behavior: isTablet ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
          content: Container(
            constraints: BoxConstraints(
              minHeight: 150,
            ),
            padding: EdgeInsets.all(Configuration.tinpadding),
            child: Row(
              children: [
                SizedBox(width: Configuration.verticalspacing),
                Icon(Icons.error_outline_rounded, color: Colors.red, size: Configuration.medicon),
                SizedBox(width: Configuration.verticalspacing),
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
      case 'network_error': return 'You are not connected to the internet';
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
    if(await googleSignin.isSignedIn()){
      googleSignin.disconnect();
    }
    if(auth.currentUser != null){
      auth.signOut();
    }
    await repository.logout();
  }

  @action
  Future<bool> forgotPassword(String email)async {
    try{
      await auth.sendPasswordResetEmail(email:email);

      return true;
    }on FirebaseAuthException catch (e) {
      print('EXCEPTION');
      return false;
    }

    return false;
  }


  @action
  Future<bool> confirmCode(String code,  String password){
    try{

    }on Exception catch(e){

    }
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
      case UserExistsFailure:
        return failure.error != null ? failure.error : 'User already exists';
      case ServerFailure:
        return failure.error != null ? failure.error :'Server failure';
      case CacheFailure:
        return failure.error != null ? failure.error : 'Cache failure';
      case LoginFailure: 
        return failure.error != null ? failure.error : 'User not found in the database';
      default:
        return 'Unexpected Error';
    }
  }
}
