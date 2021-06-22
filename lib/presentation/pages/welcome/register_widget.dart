/*
*  signup_widget.dart
*  Spacebook
*
*  Created by Supernova.
*  Copyright © 2018 Supernova. All rights reserved.
    */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/mobx/login_register/login_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/TextField.dart';
import 'package:meditation_app/presentation/pages/commonWidget/login_register_buttons.dart';
import 'package:meditation_app/presentation/pages/commonWidget/web_view.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:provider/provider.dart';

class RegisterWidget extends StatelessWidget {
  final TextEditingController _userController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _confirmController = new TextEditingController();
  final TextEditingController _mailController = new TextEditingController();
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
    final _registerstate = Provider.of<LoginState>(context);
    _userstate = Provider.of<UserState>(context);
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0,
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          padding: EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset('assets/logo.png', width: Configuration.width*0.4,),
                // spacer
                SizedBox(height: 12.0),
                WidgetTextField(
                    text: 'mail',
                    icon: Icon(Icons.mail),
                    controller: _mailController),
                SizedBox(height: 12.0),
                // [Password]
                WidgetTextField(
                    text: 'password',
                    icon: Icon(FontAwesomeIcons.key),
                    controller: _passwordController),
                SizedBox(height: 12.0),
                WidgetTextField(
                    text: 'confirm password',
                    icon: Icon(FontAwesomeIcons.key),
                    controller: _confirmController),
                SizedBox(height: 12.0),
                LoginRegisterButton(
                  onPressed: () async{
                    await _registerstate.startRegister(
                          context,
                          username:_userController.text,
                          password: _passwordController.text,
                          mail:_mailController.text, 
                          type: 'mail');
                  },
                  text: 'REGISTER',
                ),
                SizedBox(height: 30),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  RawMaterialButton(
                    onPressed: () async{
                      await _registerstate.startRegister(context, type: 'google');
                     
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
                          await _registerstate.startRegister(context, type: 'facebook');

                          /*if (_registerstate.user != null) {
                            pushNextPage(_registerstate.user, context);
                          }*/
                        }
                      })
                ])
              ],
            ),
          ),
        ));
  }
}
