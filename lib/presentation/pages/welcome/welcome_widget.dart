import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/commonWidget/login_register_buttons.dart';
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
      body: LayoutBuilder(
      builder: (builder, constraints) {
        print(constraints.maxWidth);
        if (constraints.maxWidth < 700) {
          return Container(
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
                        flex: 2,
                        child:Image.asset('assets/logo.png')
                      ),
                      LoginRegisterButton(
                        text: 'LOGIN',
                        onPressed: (){
                          Navigator.pushNamed(context, '/login');
                        },
                      ),
                      SizedBox(height: Configuration.height*0.03),
                      LoginRegisterButton(
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
          );
        } else {
          return Container(
            padding: EdgeInsets.all(12),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child:Image.asset('assets/logo.png')
                  ),
                  Flexible(
                    flex: 3,
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                            width: Configuration.width*0.25,
                            child: AspectRatio(
                              aspectRatio: 6/2,
                              child: ElevatedButton(
                              onPressed: () async {
                                Navigator.pushNamed(context, '/login');
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0.0,
                                primary: Configuration.maincolor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))
                              ),
                              child: Text(
                                'Login',
                                style: Configuration.tabletText('small', Colors.white),
                              ),
                              ),
                          ),
                        ),
                        Container(
                            width: Configuration.width*0.25,
                            child: AspectRatio(
                              aspectRatio: 6/2,
                              child: ElevatedButton(
                              onPressed: () async {
                                Navigator.pushNamed(context, '/register');
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0.0,
                                primary: Configuration.maincolor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))
                              ),
                              child: Text(
                                'Register',
                                style: Configuration.tabletText('small', Colors.white),
                              ),
                              ),
                          ),
                        ),
                      ],
                    ) 
                  ),
                ],
              ),
            ),
          );
        }
      },
      )
    );
  }
}
