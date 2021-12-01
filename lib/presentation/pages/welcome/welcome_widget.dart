import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/commonWidget/login_register_buttons.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/oldwidgets/button.dart';
import 'package:upgrader/upgrader.dart';

class WelcomeWidget extends StatelessWidget {
  AppcastConfiguration cfg= AppcastConfiguration(
    url: 'https://raw.githubusercontent.com/mrnestor123/meditation_app/master/appcast.xml', 
    supportedOS: ['android']
  );

  @override
  Widget build(BuildContext context) {
    Configuration().init(context);
    return new Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: Configuration.smpadding, horizontal: Configuration.smpadding),
        margin: EdgeInsets.symmetric(vertical: Configuration.smpadding, horizontal: Configuration.smpadding),
        child: Center(
          child: Stack(
            children: [
              UpgradeAlert(
                  dialogStyle: Platform.isAndroid ? 
                  UpgradeDialogStyle.material:  
                  UpgradeDialogStyle.cupertino,
                appcastConfig: cfg,
                child: Text(''),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex:Configuration.width > 500 ? 1 : 2,
                    child:Image.asset('assets/logo.png')
                  ),
                  BaseButton(
                    text: 'LOGIN',
                    onPressed: (){
                      Navigator.pushNamed(context, '/login');
                    },
                  ),
                  SizedBox(height: Configuration.verticalspacing*2),
                  BaseButton(
                    text: 'REGISTER',
                    onPressed: (){
                      Navigator.pushNamed(context, '/register');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}
