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
import 'package:meditation_app/presentation/mobx/login_register/register_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/TextField.dart';
import 'package:meditation_app/presentation/pages/commonWidget/button.dart';
import 'package:provider/provider.dart';

class RegisterWidget extends StatelessWidget {
  final TextEditingController _userController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _confirmController = new TextEditingController();
  final TextEditingController _mailController = new TextEditingController();



  @override
  Widget build(BuildContext context) {
    final _registerstate = Provider.of<RegisterState>(context);
    // TODO: implement build
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              WidgetTextField(text: 'username', icon: Icon(Icons.person),controller: _userController),
              // spacer
              SizedBox(height: 12.0),
              WidgetTextField(text: 'mail', icon: Icon(Icons.mail),controller: _mailController),
              SizedBox(height: 12.0),
              // [Password]
              WidgetTextField(text: 'password', icon: Icon(Icons.security),controller: _passwordController),
              SizedBox(height: 12.0),
              WidgetTextField(
                  text: 'confirm password', icon: Icon(Icons.security),controller: _confirmController),
              SizedBox(height: 12.0),
               Observer(
                 builder: (context) => _registerstate.errorMessage =="" ? Container() : Text(_registerstate.errorMessage,
                     style: Theme.of(context).textTheme.display1)),
               GestureDetector(
                  child: Container(
                    child: Center(
                        child: Text('REGISTER',
                            style: Theme.of(context).textTheme.button)),
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.08,
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: new BorderRadius.circular(5)),
                  ),
                  onTap: () {
                     _registerstate.register(
                        _userController.text, _passwordController.text,_confirmController.text,_mailController.text);
                  })
            ],
          ),
        ));
  }
}
