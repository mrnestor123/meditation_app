/*
*  login_widget.dart
* 
*/

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/mobx/login_register/login_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/TextField.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:provider/provider.dart';

class LoginWidget extends StatelessWidget {
  final TextEditingController _userController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _loginstate = Provider.of<LoginState>(context);
    final _userstate = Provider.of<UserState>(context);
    return Scaffold(
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
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          padding: EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset('images/logo.jpg', fit: BoxFit.cover),
                SizedBox(height: 20.0),
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
                GestureDetector(
                    child: Container(
                      child: Center(
                          child: Text(
                        'LOGIN',
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
                          boxShadow:[BoxShadow(color:Colors.grey,offset:Offset(2, 3),spreadRadius: 1,blurRadius: 3)]
                          ),
                    ),
                    onTap: () async {
                      await _loginstate.login(
                          _userController.text, _passwordController.text);
                      if (_loginstate.loggeduser != null) {
                        _userstate.setUser(_loginstate.loggeduser);
                        Navigator.pushNamed(context, '/main');
                      }
                    }),
                SizedBox(height:10)
              ],
            ),
          ),
        ));
  }
}
