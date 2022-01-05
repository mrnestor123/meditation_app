

import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';

class BaseButton extends StatelessWidget {
  dynamic onPressed;
  String text;
  bool justpressed = false;
  bool margin;
  Color color;
  Color textcolor;
  bool noelevation, border;

  BaseButton({this.onPressed, this.text, this.margin= false, this.color, this.textcolor,this.border = false, this.noelevation = false});
  
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
            Future.delayed(Duration(seconds: 1),()=> justpressed = false);
          }
        } : null,
        style: ElevatedButton.styleFrom(
          elevation: noelevation ? 0.0 : 2.0,
          primary: color != null ? color: Configuration.maincolor,
          shape: RoundedRectangleBorder(
            side:border ? BorderSide(color:Colors.grey) :  BorderSide.none ,
            borderRadius: BorderRadius.circular(Configuration.borderRadius)
          )
        ),
        child: Text(
          text != null ? text : 'Start',
          style: Configuration.text('smallmedium',textcolor != null ? textcolor : Colors.white),
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