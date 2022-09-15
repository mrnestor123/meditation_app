
import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';

//UTILIZAR ESTE EN  TODOS LOS SITIOS !!!
class LoginRegisterButton extends StatelessWidget {
  dynamic onPressed;
  bool isTablet;
  Widget content;
  String text;  

  LoginRegisterButton({this.onPressed, this.text, this.isTablet= false, this.content}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Configuration.width*0.9,
        child: AspectRatio(
          aspectRatio: Configuration.buttonRatio,
          child: ElevatedButton(
          onPressed: () async {
            this.onPressed();
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal:Configuration.bigpadding),
            primary: Configuration.maincolor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Configuration.borderRadius))
          ),
          child: text != null ? Text(
            text,
            style: Configuration.text('small', Colors.white)
            ) : content,
          ),
        ),
      );
  }
}