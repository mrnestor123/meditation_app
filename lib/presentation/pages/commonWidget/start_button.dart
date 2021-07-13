

import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';

class StartButton extends StatelessWidget {

  dynamic onPressed;
  String text;

  StartButton({this.onPressed, this.text});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      margin: EdgeInsets.only(bottom: 12.0),
      child: AspectRatio(
        aspectRatio: 9/2,
        child: ElevatedButton(
        onPressed: onPressed != null ? () async {
          onPressed();
        } : null,
        style: ElevatedButton.styleFrom(
          elevation: 0.0,
          primary: Configuration.maincolor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0))
        ),
        child: Text(
          text != null ? text : 'Start',
          style: Configuration.text('small', Colors.white),
        ),
          ),
      ),
    );
  }
}


class TabletStartButton extends StatelessWidget {

  dynamic onPressed;
  String text;

  TabletStartButton({this.onPressed, this.text});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.0),
      width: Configuration.width*0.25,
      child: AspectRatio(
        aspectRatio: 6/2,
        child: ElevatedButton(
        onPressed: () async {
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          elevation: 0.0,
          primary: Configuration.maincolor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))
        ),
        child: Text(
          text != null ? text :'Start',
          style: Configuration.tabletText('small', Colors.white),
        ),
          ),
      ),
    );
  }
}