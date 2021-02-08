import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/oldwidgets/button.dart';

class WelcomeWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Configuration().init(context);
    return new Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 64, horizontal: 16),
        margin: EdgeInsets.symmetric(vertical: 64, horizontal: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/logo.png', fit: BoxFit.cover),
              ButtonContainer(
                  text: 'LOGIN',
                  color: Configuration.maincolor,
                  route: '/login'),
              SizedBox(height: 16.0),
              ButtonContainer(
                  text: 'REGISTER',
                  color: Configuration.maincolor,
                  route: '/register')
            ],
          ),
        ),
      ),
    );
  }
}
