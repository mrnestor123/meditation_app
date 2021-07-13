
import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';

//UTILIZAR ESTE EN  TODOS LOS SITIOS !!!
class LoginRegisterButton extends StatelessWidget {
  dynamic onPressed;
  bool isTablet;
  String text;  

  LoginRegisterButton({this.onPressed, this.text, this.isTablet= false}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
        width:Configuration.width > 500 ? Configuration.width * 0.4 : Configuration.width*0.85,
        child: AspectRatio(
          aspectRatio: 10/2,
          child: ElevatedButton(
          onPressed: () async {
            this.onPressed();
          },
          style: ElevatedButton.styleFrom(
            elevation: 0.0,
            primary: Configuration.maincolor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))
          ),
          child: Text(
            text,
            style: Configuration.width > 500 ? Configuration.tabletText('small', Colors.white) : Configuration.text('small', Colors.white),
            ),
          ),
        ),
      );
  }
}