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
              Image.asset('assets/logo.jpg', fit: BoxFit.cover),
              SizedBox(height: 12.0),
              Text('The Mind Illuminated',
                  style: GoogleFonts.playfairDisplay(fontSize:Configuration.blockSizeHorizontal*8)),
              SizedBox(height: 6.0),
              Text('''Are you ready to master your mind?''',
                  style: GoogleFonts.roboto(fontSize:Configuration.blockSizeHorizontal*4),
                  textAlign: TextAlign.center),
              SizedBox(height: 60.0),
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
