
import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';

class LoginRegisterButton extends StatelessWidget {
  dynamic onPressed;

  String text;


  LoginRegisterButton({this.onPressed, this.text}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Configuration.width*0.85,
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
            style: Configuration.text('small', Colors.white),
            ),
          ),
        ),
      );
  }
}