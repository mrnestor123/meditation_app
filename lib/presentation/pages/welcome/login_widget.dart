/*
*  login_widget.dart
* 
*/
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/mobx/login_register/login_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/circular_progress.dart';
import 'package:meditation_app/presentation/pages/commonWidget/login_register_buttons.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/commonWidget/web_view.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/main_screen.dart';
import 'package:meditation_app/presentation/pages/requests_screen.dart';
import 'package:meditation_app/presentation/pages/welcome/register_widget.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';

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
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: ButtonBack()
        ),
        body: Center(
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
                    labeltext:'Mail',
                    icon: Icons.mail,
                    validator: (value){
                      if(value == null  || value.isEmpty){
                        return 'Please enter the mail';
                      }else if(!_loginstate.validateMail(value)){
                        return 'Please input a valid mail';
                      } 
                      return null;
                    },
                  ),
                  SizedBox(height: Configuration.verticalspacing),
                  InputField(
                    controller: _loginstate.passwordController,
                    labeltext: 'Password',
                    icon: Icons.lock,
                    obscuretext: true,
                    validator: (value) { 
                      if(value == null || value.isEmpty){
                        return 'Please enter the password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: Configuration.verticalspacing*2),
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
                            Text('LOGIN WITH MAIL',
                              style: Configuration.text('smallmedium', Colors.white),
                            ),
                            Icon(Icons.mail,size: Configuration.smicon)
                          ],
                        );
                      }
                    }),
                  )
                ],
              )
              ),
              Spacer(),
              SizedBox(height: 30),
              GoogleButton(registerstate: _loginstate,register: false),
              SizedBox(height: 15),
              FacebookButton(your_client_id: your_client_id, your_redirect_url: your_redirect_url, registerstate: _loginstate, register: false),
              SizedBox(height: 40
              ,)
            ],
          ),
        ));
  }
}

class InputField extends StatelessWidget {

  dynamic validator;
  bool obscuretext;
  
  InputField({
    Key key,
    this.validator,
    this.labeltext,
    this.obscuretext,
    this.icon,
    this.controller,
  }) : super(key: key);

  final String labeltext;
  final dynamic controller;
  final IconData icon;  

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Configuration.width*0.9,
      child: TextFormField(
        maxLines:1,
        controller: controller,
        style: Configuration.text('small', Colors.black),
        obscureText: obscuretext != null ? true: false,
        decoration: InputDecoration(
            focusColor: Configuration.maincolor,
           // focusedBorder: new OutlineInputBorder(borderSide: new BorderSide(color: Configuration.maincolor),borderRadius: BorderRadius.circular(Configuration.borderRadius)),
            errorStyle: Configuration.text('small', Colors.red),
            contentPadding: EdgeInsets.symmetric(vertical: Configuration.smpadding,horizontal:Configuration.bigpadding),
            filled: true,
            labelStyle:  Configuration.text('small',Colors.grey),
            labelText: labeltext,
            border: OutlineInputBorder(borderSide: new BorderSide(color: Configuration.maincolor),borderRadius: BorderRadius.circular(Configuration.borderRadius)),
            prefixIcon: Container(
              margin:EdgeInsets.symmetric(horizontal: Configuration.tinpadding), 
              child: Icon(icon, size: Configuration.smicon)
            ),
        ),
        validator: validator 
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