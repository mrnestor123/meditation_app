import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/oldwidgets/button.dart';

class WelcomeWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Configuration().init(context);
    return new Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: Configuration.smpadding, horizontal: Configuration.smpadding),
        margin: EdgeInsets.symmetric(vertical: Configuration.smpadding, horizontal: Configuration.smpadding),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/logo.png', width: Configuration.width*0.6),
              ButtonContainer(
                  text: 'LOGIN',
                  color: Configuration.maincolor,
                  route: '/login'),
              SizedBox(height: Configuration.height*0.03),
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
