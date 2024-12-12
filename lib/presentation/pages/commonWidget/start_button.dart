

import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';

import '../../../domain/entities/stage_entity.dart';

class BaseButton extends StatelessWidget {
  dynamic onPressed;
  String text;
  Color color;
  Color textcolor,  bordercolor;
  bool border, filled, justpressed=false, margin;
  double aspectRatio;
  double width;

  Widget child;

  BaseButton({
    this.onPressed,
    this.child, 
    this.text,
    this.bordercolor, 
    this.width, 
    this.aspectRatio, 
    this.margin= false, 
    this.color, 
    this.textcolor,
    this.border = false,
    this.filled = false
  });
  
  @override
  Widget build(BuildContext context) {
    width= width != null ? width:  Configuration.width*0.9;

    return Container(
      constraints: BoxConstraints(
        minHeight: width/Configuration.buttonRatio,
        minWidth: width
      ),
      margin: EdgeInsets.only(
        bottom: margin ? Configuration.verticalspacing * 1.5 : 0, 
        left: margin ? Configuration.verticalspacing * 1.5 : 0,
        right: margin ? Configuration.verticalspacing * 1.5 : 0
      ),
      child:OutlinedButton(
      onPressed: onPressed != null ? () async {
        if(!justpressed){
          onPressed();
          justpressed = true;
          Future.delayed(Duration(seconds: 1),()=> justpressed = false);
        }
      } : null,
      style:filled ? 
      ElevatedButton.styleFrom(
        side: BorderSide(color:  color != null ? color:  Configuration.maincolor, width: 2),
        backgroundColor: color != null ? color : Configuration.maincolor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Configuration.borderRadius)
      )) :
       OutlinedButton.styleFrom(
        side: BorderSide(color:  color != null ? color:  Configuration.maincolor, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Configuration.borderRadius))
      ),
      child: this.child != null ?
        this.child :
        Text(
          text != null ? text : 'Start',
          textAlign: TextAlign.center,
          style: Configuration.text('medium',textcolor != null ? textcolor : color != null ? color : Configuration.maincolor),
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





Widget discussionButton(context,Stage stage, [type]){
  return AspectRatio(
    aspectRatio: Configuration.buttonRatio,
    child: OutlinedButton(
      onPressed:(){
        Navigator.pushNamed(context, '/requests', arguments: {'stage': stage, 'type': type});
      },
      child: Row(
        mainAxisAlignment:MainAxisAlignment.spaceBetween,
        children: [
          Text('Join the discussion',style:Configuration.text('small',Colors.lightBlue)
          ),
          Row(
            children: [
              Icon(Icons.question_answer,
                size:Configuration.smicon,
                color:Colors.lightBlue
              )
            ],
          )
        ],
      ),
      style:OutlinedButton.styleFrom(
        side: BorderSide(color:Colors.lightBlue),
        padding: EdgeInsets.symmetric(horizontal: Configuration.medpadding),
        //primary: Configuration.maincolor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Configuration.borderRadius/2))
      )
    ),
  );
}