

import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';

class StartButton extends StatelessWidget {

  dynamic onPressed;

  StartButton({this.onPressed});
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
    onPressed: () async {
      onPressed();
    },
    style: ElevatedButton.styleFrom(
      primary: Configuration.maincolor,
      shape: CircleBorder(),
      padding: EdgeInsets.all(Configuration.medpadding)
    ),
    child: Text(
      'Start',
      style: Configuration.text('medium', Colors.white),
    ),
      );
  }
}