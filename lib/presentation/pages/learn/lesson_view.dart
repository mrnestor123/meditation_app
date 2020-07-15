import 'package:flutter/material.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/presentation/pages/commonWidget/bottom_menu.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';

class LessonView extends StatelessWidget {
  LessonModel lesson;

  LessonView({this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          //My container or any other widget
          height: Configuration.height * 0.35,
          width: Configuration.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(1000, 100),
                bottomRight: Radius.elliptical(1000, 100)),
            color: Colors.grey[500],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(lesson.title,style: Configuration.title)
            ],
          ),


        ),
        new Positioned(
          //Place it at the top, and not use the entire screen
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, size: Configuration.iconSize),
              color: Colors.white,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    ),
    
    
    );
  }
}
