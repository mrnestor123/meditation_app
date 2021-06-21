import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/oldwidgets/button.dart';

class WelcomeWidget extends StatelessWidget {

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: 3,
                    child:Image.asset('assets/logo.png')
                  ),
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
                                Navigator.pushNamed(context, '/tabletlogin');
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
                                Navigator.pushNamed(context, '/tabletlogin');
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
