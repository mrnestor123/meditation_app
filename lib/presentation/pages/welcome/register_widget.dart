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
      resizeToAvoidBottomInset: false,
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
          height: Configuration.height,
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 30),
                Image.asset('assets/logo.png', width: Configuration.height*0.2),
                SizedBox(height: 15),
                Form(
                  key: _registerstate.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //HHACER COMPONENTES DE ESTO!!
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextFormField(
                          controller: _userController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(4.0),
                              filled: true,
                              labelText: 'Mail',
                              border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.purpleAccent)),
                              prefixIcon: Icon(Icons.email, size: Configuration.smicon),
                          ),
                          validator: (value) { 
                            if(value == null  || value.isEmpty){
                              return 'Please enter a mail';
                            }else if(!_registerstate.validateMail(value)){
                              return 'Please input a valid mail';
                            } 
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextFormField(
                          obscureText: true,
                          controller: _passwordController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(4.0),
                              filled: true,
                              labelText: 'password',
                              border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.purpleAccent)),
                              prefixIcon: Icon(Icons.lock, size: Configuration.smicon),
                          ),
                          validator: (value) { 
                            if(value == null  || value.isEmpty){
                              return 'Please enter a password';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextFormField(
                          obscureText: true,
                          controller: _confirmController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(4.0),
                              filled: true,
                              labelText: 'password',
                              border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.purpleAccent)),
                              prefixIcon: Icon(Icons.lock,  size: Configuration.smicon),
                          ),
                          validator: (value) { 
                            if(value == null  || value.isEmpty){
                              return 'Please enter a password';
                            }else if(_confirmController.text != _passwordController.text) {
                              return 'Passwords must be equal';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 20),
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
                          return  Text(
                            'REGISTER',
                            style: Configuration.text('small', Colors.white),
                            );
                        }
                        })
                      ),
                    ],
                  ),
                ),
                Spacer(),
                GoogleButton(registerstate: _registerstate, register:true),
                SizedBox(height: 15),
                FacebookButton(your_client_id: your_client_id, your_redirect_url: your_redirect_url, registerstate: _registerstate, register:true),
                SizedBox(height: 40)
              ],
            ),
          ),
        ));
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
      width:Configuration.width > 500 ? Configuration.width * 0.4 : Configuration.width*0.9,
      child: AspectRatio(
      aspectRatio: 6/1,
      child: ElevatedButton(
          child: Observer( builder: (context){
            if(_registerstate.startedfacelogin){
              return CircularProgressIndicator(color: Colors.white);
            }else{
             return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text((register ? 'REGISTER' :'LOGIN') + ' WITH FACEBOOK',  style: Configuration.text('small', Colors.white)),
                  Icon(FontAwesomeIcons.facebookF,
                      color: Colors.white, size: Configuration.smicon),
                ],
              ); 
            }
            }
          ),
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
              await _registerstate.startlogin(context, type: 'facebook',register: register); 
            }
          }),
    ));
  }
}

class GoogleButton extends StatelessWidget {
  const GoogleButton({
    this.register,
    Key key,
    @required LoginState registerstate,
  }) : _registerstate = registerstate, super(key: key);

  final bool register;
  final LoginState _registerstate;

  @override
  Widget build(BuildContext context) {

    return Container(
      width:Configuration.width > 500 ? Configuration.width * 0.4 : Configuration.width*0.9,
      child: AspectRatio(
      aspectRatio: 6/1,
      child: ElevatedButton(
        onPressed: () async{
            await _registerstate.startlogin(context, type: 'google', register:register);
        },
        style: OutlinedButton.styleFrom(
          primary: Colors.white,
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          padding: EdgeInsets.all(12.0),
        ),
        child: Observer(builder: (context){
          if(_registerstate.startedgooglelogin){
            return CircularProgressIndicator(color: Colors.white);
          } 
          else{
            return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text((register ? 'REGISTER' :'LOGIN') + ' WITH GOOGLE', style: Configuration.text('small', Colors.white)),
              Icon(FontAwesomeIcons.google,
              color: Colors.white,
              size: Configuration.smicon,
              )
            ]);
          }
        })
        ),
      ),
    );
  }
}
