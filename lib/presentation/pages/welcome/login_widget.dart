/*
*  login_widget.dart
* 
*/
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/mobx/login_register/login_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/back_button.dart';
import 'package:meditation_app/presentation/pages/commonWidget/circular_progress.dart';
import 'package:meditation_app/presentation/pages/commonWidget/error_dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/login_register_buttons.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/welcome/common_widgets.dart';
import 'package:meditation_app/presentation/pages/welcome/register_widget.dart';
import 'package:provider/provider.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  String your_client_id = "445064026505232";
  String your_redirect_url = "https://www.facebook.com/connect/login_success.html";

  String email = "";


  @override
  Widget build(BuildContext context) {
    final _loginstate = Provider.of<LoginState>(context);
    final _userstate = Provider.of<UserState>(context);
    
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        
        body: loginLayout(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset('assets/logo.png', width: Configuration.height*0.2),
                Form(
                key: _loginstate.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InputField(
                      controller: _loginstate.userController,
                      labeltext:'email',
                      icon: Icons.mail,
                      validator: (value){
                        if(value == null  || value.isEmpty){
                          return 'Please enter the email';
                        }else if(!_loginstate.validateMail(value)){
                          return 'Please input a valid email';
                        } 
                        return null;
                      },
                    ),
                    SizedBox(height: Configuration.verticalspacing),
                    InputField(
                      controller: _loginstate.passwordController,
                      labeltext: 'password',
                      isPassword: true,
                      icon: Icons.lock,
                      validator: (value) { 
                        if(value == null || value.isEmpty){
                          return 'Please enter the password';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: Configuration.verticalspacing),
                    LoginRegisterButton(
                      onPressed: () async {
                        if(!_loginstate.startedlogin){ 
                          _loginstate.startlogin(context, 
                          username: _loginstate.userController.text, 
                          password: _loginstate.passwordController.text,
                          type:'mail');
                        }
                      },
                      content: Observer(builder: (context)  {
                        if(_loginstate.startedmaillogin){
                          return CircularProgress(color:Colors.white);
                        }else{
                          return Row(
                            crossAxisAlignment:CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text('Log in with email',
                                  style: Configuration.text('subtitle', Colors.white,),
                                ),
                              ),
                              Icon(Icons.mail,size: Configuration.smicon)
                            ],
                          );
                        }
                      }),
                    ),
                    SizedBox(height: Configuration.verticalspacing*2),
                    TextButton(onPressed: ()=>{
                      // add borderRadius top to bottomSheet
                      showModalBottomSheet(
                        context: context, 
                        builder: (context){
                          return ForgotPassword( );
        
                        })
                    }, 
                    child: Text('Forgot password?', style: Configuration.text('smallmedium', Colors.black,  font: 'Helvetica'))
                    )
                  ],
                )
                ),
                Spacer(),
                
                //APPLE BUTTON  IN IOS PLATFORM
                
                

                Platform.isIOS ? 
                Container(
                  margin: EdgeInsets.only(bottom: Configuration.verticalspacing),
                  child: AppleButton(state: _loginstate, register: false),
                ): Container(),




                GoogleButton(registerstate: _loginstate,register: false),
                //SizedBox(height: Configuration.verticalspacing*3),
                /*
                FacebookButton(your_client_id: your_client_id, your_redirect_url: your_redirect_url, registerstate: _loginstate, register: false),
                SizedBox(height: 40
                ,)*/
              ],
            ),
          ),
        ));
  }
}

class ForgotPassword extends StatefulWidget {


  ForgotPassword({
    Key key,
  }) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController recoverymailcontroller = new TextEditingController();

  int asking_email = 0;

  int sent_mail = 1;
  int step = 0;

  final _formKey = GlobalKey<FormState>();

  bool sending = false;

  @override
  Widget build(BuildContext context) {
    final _loginstate  =  Provider.of<LoginState>(context);


    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        constraints: BoxConstraints(
          minHeight: Configuration.height*0.25,
        ),
        padding: EdgeInsets.all(Configuration.smpadding),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: 
              step == asking_email ?
              [
                Text('Enter your email to recover your password', style: Configuration.text('smallmedium', Colors.black,  font: 'Helvetica')),
                SizedBox(height: Configuration.verticalspacing*2),
                InputField(
                  controller: recoverymailcontroller,
                  labeltext:'email',
                  icon: Icons.mail,
                  validator: (value){
                    if(value == null  || value.isEmpty){
                      return 'Please enter the email';
                    }else if(!_loginstate.validateMail(value)){
                      return 'Please input a valid email';
                    } 
                    return null;
                  },
                ),
                SizedBox(height: Configuration.verticalspacing*2),
                BaseButton(
        
                  onPressed: () async{
                    if (_formKey.currentState.validate() && !sending) {
                      sending = true;
                      bool result = await _loginstate.forgotPassword(recoverymailcontroller.text);
            
                      if(result != null && result){
                        step = sent_mail;
                        setState((){});
                      }else{
                        sending = false;
                        showInfoDialog(
                          header: "Error",
                          description: "This email is not registered in the database"
                        );
                        
                      }
                    }
                  },
                  text: 'Send recovery email',
                ),
                SizedBox(height:Configuration.verticalspacing*2)
            ] : 
            [
              SizedBox(height: Configuration.verticalspacing),
              Icon(Icons.mail, size: Configuration.medicon, color: Colors.green),
              SizedBox(height: Configuration.verticalspacing*2),
              Text('A message for recovering your password has been sent to your email address', 
                textAlign: TextAlign.center,
                style: Configuration.text('smallmedium', Colors.black,  font: 'Helvetica')
              )
              /*
              InputField(
                controller: recoverymailcontroller,
                labeltext:'Code',
                icon: Icons.mail,
                validator: (value){
                  if(value == null  || value.isEmpty){
                    return 'Please enter the code';
                  } 
                  return null;
                },
              )*/
            ],
          ),
        ),
      ),
    );
  }
}

class InputField extends StatefulWidget {

  dynamic validator;
  bool isPassword;
  
  InputField({
    Key key,
    this.validator,
    this.labeltext,
    this.isPassword = false,
    this.icon,
    this.controller,
  }) : super(key: key);

  final String labeltext;
  final TextEditingController controller;
  final IconData icon;  

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool obscuretext;


  @override
  void initState() {
    super.initState();
    obscuretext = widget.isPassword;

    print({'OBSCURETEXT',obscuretext});
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: Configuration.width*0.9,
      child: TextFormField(
        onChanged: ((value) => setState((){})),
        maxLines:1,
        controller: widget.controller,
        style: Configuration.text('small', Colors.black),
        obscureText: obscuretext != null && obscuretext ? true: false,
        decoration: InputDecoration(
            isDense: true,
            focusColor: Configuration.maincolor,
            suffixIcon: widget.isPassword && widget.controller.text != '' ? 
              IconButton(
              icon: Icon(
                // Based on passwordVisible state choose the icon
                obscuretext ? Icons.visibility : Icons.visibility_off,
               color: Colors.lightBlue,
               size: Configuration.smicon,


              ),
              onPressed: () {
                setState(() {
                  obscuretext = !obscuretext;
                  print({'OBSCURETEXT', obscuretext});
                
                });
             },
            ): null,

           // focusedBorder: new OutlineInputBorder(borderSide: new BorderSide(color: Configuration.maincolor),borderRadius: BorderRadius.circular(Configuration.borderRadius)),
            errorStyle: Configuration.text('small', Colors.red),
            contentPadding: EdgeInsets.symmetric(
              vertical: Configuration.medpadding,
              horizontal:Configuration.bigpadding
            ),
            filled: true,
            labelStyle:  Configuration.text('small',Colors.grey),
            labelText: widget.labeltext,
            border: OutlineInputBorder(borderSide: new BorderSide(color: Configuration.maincolor),borderRadius: BorderRadius.circular(Configuration.borderRadius)),
            prefixIcon: Container(
              margin:EdgeInsets.symmetric(horizontal: Configuration.tinpadding), 
              child: Icon(widget.icon, size: Configuration.smicon)
            ),
        ),
        validator: widget.validator 
      ),
    );
  }
}







/*
class TabletLoginWidget extends StatelessWidget {
  //PASAR EL TEXTEDITINGCONTROLLER AL MOBX!!!
  final TextEditingController _userController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  String your_client_id = "445064026505232";
  String your_redirect_url = "https://www.facebook.com/connect/login_success.html";

  @override
  Widget build(BuildContext context) {
    final _loginstate = Provider.of<LoginState>(context);
    final _userstate = Provider.of<UserState>(context);
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          height: Configuration.height,
          width: Configuration.width,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 2,
                child:Image.asset('assets/logo.png')
              ),
              Form(
                key: _loginstate.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: TextFormField(
                        controller: _loginstate.userController,
                        decoration: InputDecoration(
                            filled: true,
                            labelText: 'Mail',
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.purpleAccent)),
                            prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) { 
                          if(value == null  || value.isEmpty){
                            return 'Please enter the username';
                          }else if(!_loginstate.validateMail(value)){
                            return 'Please input a valid mail';
                          } 
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: TextFormField(  
                        controller: _loginstate.passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.purpleAccent)),
                            prefixIcon: Icon(Icons.lock),
                        ),
                        validator: (value) { 
                          if(value == null || value.isEmpty){
                            return 'Please enter a password';
                          }
                          return null;
                        },
                      ),
                    ),
                ])
              ),
              SizedBox(height: 25),
              TabletStartButton(
                text: 'LOGIN', 
                onPressed:(){
                   _loginstate.startlogin(context, 
                        username: _loginstate.userController.text, 
                        password: _loginstate.passwordController.text,
                        type:'mail',
                        isTablet:true
                      );
                },
              ),
              SizedBox(height: 25),            
              Flexible(
                flex: 2,
                child: Row(mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  RawMaterialButton(
                    onPressed: () async{
                      _loginstate.startlogin(context,type:'google', isTablet:true);
                    },
                    elevation: 2.0,
                    fillColor: Configuration.maincolor,
                    child: Icon(
                      FontAwesomeIcons.google,
                      color: Colors.white,
                      size: 35.0,
                    ),
                    padding: EdgeInsets.all(15.0),
                    shape: CircleBorder(),
                  ),
                  RawMaterialButton(
                      child: Icon(FontAwesomeIcons.facebookF,
                        color: Colors.white, size: 35.0),
                      padding: EdgeInsets.all(15.0),
                      shape: CircleBorder(),
                      fillColor: Configuration.maincolor,
                      onPressed: () async {
                        String result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomWebView(
                                    selectedUrl:'https://www.facebook.com/dialog/oauth?client_id=$your_client_id&redirect_uri=$your_redirect_url&response_type=token&scope=email,public_profile,',
                                  ),
                              maintainState: true),
                        );
                        if (result != null) {
                            await _loginstate.startlogin(context, type:'facebook', token: result, isTablet:true);
                            _userstate.setUser(_loginstate.loggeduser);
                        }
                      })
                ]),
              )
            ],
          ),
        ));
  }
}*/