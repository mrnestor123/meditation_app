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
import 'package:google_fonts/google_fonts.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/mobx/login_register/register_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/TextField.dart';
import 'package:meditation_app/presentation/pages/commonWidget/web_view.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/oldwidgets/button.dart';
import 'package:provider/provider.dart';

class RegisterWidget extends StatelessWidget {
  final TextEditingController _userController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _confirmController = new TextEditingController();
  final TextEditingController _mailController = new TextEditingController();
  String your_client_id = "445064026505232";
  String your_redirect_url =
      "https://www.facebook.com/connect/login_success.html";
  var _userstate;

  void pushNextPage(user, context) {
    print(user);
    print('REGISTERING');
    if (user != null) {
      _userstate.user = user;
      if (user.user.displayName != null) {
        print(user);
        _userstate.user = user;
        Navigator.pushNamed(context, '/main');
      } else {
        Navigator.pushNamed(context, '/main');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _registerstate = Provider.of<RegisterState>(context);
    _userstate = Provider.of<UserState>(context);
    return Scaffold(
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
                Image.asset('assets/logo.jpg', fit: BoxFit.cover),
                SizedBox(height: 20.0),
                WidgetTextField(
                    text: 'username',
                    icon: Icon(Icons.person),
                    controller: _userController),
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
                Observer(
                    builder: (context) => _registerstate.errorMessage == ""
                        ? Container()
                        : Text(_registerstate.errorMessage)),
                GestureDetector(
                    child: Container(
                      child: Center(
                          child: Text(
                        'REGISTER',
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    Configuration.blockSizeHorizontal * 5)),
                      )),
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.08,
                      decoration: BoxDecoration(
                          color: Configuration.maincolor,
                          borderRadius: new BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                offset: Offset(2, 3),
                                spreadRadius: 1,
                                blurRadius: 3)
                          ]),
                    ),
                    onTap: () async {
                      var user = await _registerstate.register(
                          _userController.text,
                          _passwordController.text,
                          _confirmController.text,
                          _mailController.text);
                      if (user != null) {
                        pushNextPage(user, context);
                      }
                    }),
                SizedBox(height: 30),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  RawMaterialButton(
                    onPressed: () async{
                      await _registerstate.googleLogin();
                      if (_registerstate.user != null) {
                        pushNextPage(_registerstate.user, context);
                      }
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
                          UserModel user =
                              await _registerstate.registerWithFacebook(result);
                          if (user != null) {
                            pushNextPage(user, context);
                          }
                        }
                      })
                ])
              ],
            ),
          ),
        ));
  }
}
