/*
*  login_widget.dart
* 
*/

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meditation_app/domain/entities/auth/email_address.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/mobx/login_register/login_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/TextField.dart';
import 'package:meditation_app/presentation/pages/commonWidget/login_register_buttons.dart';
import 'package:meditation_app/presentation/pages/commonWidget/web_view.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:provider/provider.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
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
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 15),
                Image.asset('assets/logo.png', width: Configuration.width*0.4),
                Form(
                  key: _loginstate.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
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
                        width: MediaQuery.of(context).size.width * 0.9,
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
                      SizedBox(height: 20),
                      LoginRegisterButton(
                        onPressed: () async {
                          _loginstate.startlogin(context, 
                          username: _loginstate.userController.text, 
                          password: _loginstate.passwordController.text,
                          type:'mail');
                        },
                        text: 'LOGIN'
                      )
                    ],
                  )
                ),
                SizedBox(height: 50),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  RawMaterialButton(
                    onPressed: () async {
                      _loginstate.startlogin(context,type:'google');
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
                          _loginstate.startlogin(context, type:'facebook', token: result);
                        }
                      })
                ])
              ],
            ),
          ),
        ));
  }
}


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
              Flexible(
                flex: 2,
                child: Column(children: [
                   WidgetTextField(
                  text: 'username',
                  icon: Icon(Icons.person),
                  controller: _userController),
              // spacer
                SizedBox(height: 12.0),
                WidgetTextField(
                    text: 'password',
                    icon: Icon(FontAwesomeIcons.key),
                    controller: _passwordController),
                SizedBox(height: 8.0),
                Observer(
                  builder: (context) => _loginstate.errorMessage == null
                      ? Container()
                      : Text(_loginstate.errorMessage)),
                ])
              ),
              Flexible(
                flex: 2,
                child: GestureDetector(
                  child: Container(
                    child: Center(
                        child: Text(
                      'LOGIN',
                      style: Configuration.tabletText('big', Colors.white)),
                    ),
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
                   _loginstate.startlogin(context, 
                          username: _loginstate.userController.text, 
                          password: _loginstate.passwordController.text,
                          type:'mail');
                  }),                
              ), 
              SizedBox(height: 25),            
              Flexible(
                flex: 2,
                child: Row(mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  RawMaterialButton(
                    onPressed: () async{
                      _loginstate.startlogin(context,type:'google');
                      _userstate.setUser(_loginstate.loggeduser);
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
                            await _loginstate.startlogin(context, type:'facebook', token: result);
                            _userstate.setUser(_loginstate.loggeduser);
                        }
                      })
                ]),
              )
            ],
          ),
        ));
  }
}