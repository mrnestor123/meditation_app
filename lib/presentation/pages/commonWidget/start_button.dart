

import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';

class BaseButton extends StatelessWidget {
  dynamic onPressed;
  String text;
  bool justpressed = false;
  bool margin;

  BaseButton({this.onPressed, this.text, this.margin= false});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Configuration.width*0.9,
      margin: EdgeInsets.only(bottom: margin ? Configuration.verticalspacing * 1.5 : 0),
      child: AspectRatio(
        aspectRatio:Configuration.buttonRatio,
        child: ElevatedButton(
        onPressed: onPressed != null ? () async {
          if(!justpressed){
            onPressed();
            justpressed = true;
            Future.delayed(Duration(seconds: 2),()=> justpressed = false);
          }
        } : null,
        style: ElevatedButton.styleFrom(
          elevation: 2.0,
          primary: Configuration.maincolor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Configuration.borderRadius))
        ),
        child: Text(
          text != null ? text : 'Start',
          style: Configuration.text('smallmedium', Colors.white),
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