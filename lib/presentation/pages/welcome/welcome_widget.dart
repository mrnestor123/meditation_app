import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/oldwidgets/button.dart';

class WelcomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 64, horizontal: 16),
        margin: EdgeInsets.symmetric(vertical: 64, horizontal: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('images/logo.jpg', fit: BoxFit.cover),
              SizedBox(height: 12.0),
              Text('The Mind Illuminated',
                  style: Theme.of(context).textTheme.title),
              SizedBox(height: 6.0),
              Text('''Are you ready to master
                      your mind?''',
                  style: Theme.of(context).textTheme.subtitle,
                  textAlign: TextAlign.center),
              SizedBox(height: 60.0),
              ButtonContainer(
                  text: 'LOGIN',
                  color: Theme.of(context).accentColor,
                  route: '/login'),
              SizedBox(height: 12.0),
              ButtonContainer(
                  text: 'REGISTER',
                  color: Theme.of(context).accentColor,
                  route: '/register')
            ],
          ),
        ),
      ),
    );
  }
}
