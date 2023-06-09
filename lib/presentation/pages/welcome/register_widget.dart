/*
*  signup_widget.dart
*  Spacebook
*
*  Created by Supernova.
*  Copyright © 2018 Supernova. All rights reserved.
    */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/mobx/login_register/login_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/circular_progress.dart';
import 'package:meditation_app/presentation/pages/commonWidget/login_register_buttons.dart';
import 'package:meditation_app/presentation/pages/commonWidget/web_view.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/welcome/login_widget.dart';
import 'package:provider/provider.dart';

import '../commonWidget/back_button.dart';
import '../contentWidgets/meditation_screens.dart';
import 'common_widgets.dart';

class RegisterWidget extends StatelessWidget {
  final TextEditingController _userController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _confirmController = new TextEditingController();
  bool started = false;

  String your_client_id = "445064026505232";
  String your_redirect_url = "https://www.facebook.com/connect/login_success.html";
  var _userstate;

  void pushNextPage(user, context) {
    if (user != null) {
      _userstate.user = user;
      Navigator.pushNamed(context, '/selectusername');
    }
  }

  @override
  Widget build(BuildContext context) {
    //Registerstate ya es login
    final _registerstate = Provider.of<LoginState>(context);
    _userstate = Provider.of<UserState>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            // Status bar color
            statusBarColor: Colors.transparent, 
            // Status bar brightness (optional)
            statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          backgroundColor: Colors.transparent,
          leading: ButtonBack(color: Colors.white),
          elevation: 0,
        ),
        body: loginLayout(
          child: Center(
              child: Column(
                children: <Widget>[
                  Image.asset('assets/logo.png', width: Configuration.height*0.2),
                  SizedBox(height: Configuration.verticalspacing),
                  Form(
                    key: _registerstate.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InputField(
                          controller: _userController,
                          labeltext: 'email',
                          icon: Icons.email,
                          validator: (value){
                            if(value == null  || value.isEmpty){
                              return 'Please enter the email';
                            }else if(!_registerstate.validateMail(value)){
                              return 'Please input a valid email';
                            } 
                            return null;
                          },
                        ),
                        SizedBox(height: Configuration.verticalspacing),
                        InputField(
                          controller: _passwordController,
                          labeltext: 'password',
                          isPassword: true,
                          icon: Icons.lock,
                          validator: (value){
                            if(value == null  || value.isEmpty){
                              return 'Please enter the password';
                            }else if(value.contains(' ')){
                              return 'Password must not contain spaces';
                            }
                            return null;
                          }
                        ),
                        SizedBox(height: Configuration.verticalspacing),
                        InputField(
                          controller: _confirmController,
                          labeltext: 'confirm password',
                          icon: Icons.lock,
                          isPassword: true,
                          validator: (value){
                              if(value == null  || value.isEmpty){
                                return 'Please enter the password';
                              }else if(_confirmController.text != _passwordController.text) {
                                return 'Passwords must be equal';
                              }
                              return null;
                          }
                        ),
                        SizedBox(height: Configuration.verticalspacing ),
                        LoginRegisterButton(
                          onPressed: () async{
                            if(!_registerstate.startedlogin){
                              await _registerstate.startlogin(
                                context,
                                register: true,
                                mail:_userController.text,
                                password: _passwordController.text,
                                type: 'mail');
                            }
                          },
                          content: Observer(builder: (context)  {
                          if(_registerstate.startedmaillogin){
                            return CircularProgressIndicator(color: Colors.white);
                          }else{
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    'Sign up with email',
                                    style: Configuration.text('subtitle', Colors.white),
                                  ),
                                ),
                                Icon(
                                  Icons.mail,
                                  size: Configuration.smicon,
                                )
                              ],
                            );
                          }
                          })
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  
                  Platform.isIOS ? 
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppleButton(state: _registerstate, register:true),
                      SizedBox(height: Configuration.verticalspacing),
                    ]
                  ) : Container(),
                  GoogleButton(registerstate: _registerstate, register:true),
                  /*
                  FacebookButton(your_client_id: your_client_id, your_redirect_url: your_redirect_url, registerstate: _registerstate, register:true),
                  SizedBox(height: 40)*/
                ],
              ),
            ),
          ),
        );
  }
}

class FacebookButton extends StatelessWidget {
  const FacebookButton({
    Key key,
    this.register,
    @required this.your_client_id,
    @required this.your_redirect_url,
    @required LoginState registerstate,
  }) : _registerstate = registerstate, super(key: key);

  final bool register;
  final String your_client_id;
  final String your_redirect_url;
  final LoginState _registerstate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width:Configuration.width*0.9,
      child: AspectRatio(
      aspectRatio: Configuration.buttonRatio,
      child: ElevatedButton(
          style: OutlinedButton.styleFrom(
            primary: Colors.white,
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Configuration.borderRadius)),
            padding: EdgeInsets.symmetric(horizontal:Configuration.bigpadding),
          ),
          child: Observer( builder: (context){
            if(_registerstate.startedfacelogin){
              return CircularProgress(color:Colors.white);
            }else{
             return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text((register ? 'SIGN UP' :'LOG IN') + ' WITH FACEBOOK',  style: Configuration.text('smallmedium', Colors.white)),
                  Icon(FontAwesomeIcons.facebookF, color: Colors.white, size: Configuration.smicon),
                ],
              ); 
            }
            }
          ),
          onPressed: () async {
            if(!_registerstate.startedlogin){
              String result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomWebView(
                          selectedUrl:'https://www.facebook.com/dialog/oauth?client_id=$your_client_id&redirect_uri=$your_redirect_url&response_type=token&scope=email,public_profile,',
                        ),
                    maintainState: true),
              );
              if (result != null) {
                await _registerstate.startlogin(context, type: 'facebook',register: register,token: result); 
              }
            }
          }),
    ));
  }
}




Widget loginLayout({Widget child}){

  return containerGradient(
    child: Container(
      padding: EdgeInsets.all(Configuration.smpadding),
      child: Container(
        margin: EdgeInsets.only(top: Configuration.height*0.05),
        padding: EdgeInsets.all(Configuration.smpadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Configuration.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          color: Color.fromRGBO(251, 248, 236, 1)
        ),
       child: child, 
      )
    )
  );
}