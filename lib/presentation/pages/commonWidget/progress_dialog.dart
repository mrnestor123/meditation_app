

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/progress_entity.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';


void autocloseDialog(context, progress) async {
  Timer _timer;

  await Future.delayed(Duration(seconds:1));

  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    transitionDuration: Duration(milliseconds: 400),
    transitionBuilder: (context, anim1, anim2, child) {
      return FadeTransition(
        opacity: Tween(begin: 0.0, end: 1.0).animate(anim1),
        child: child,
      );
    },
    pageBuilder:(context, anim1, anim2) {
      _timer = Timer(Duration(seconds: 4), () {
        Navigator.of(context).pop();
      });

      return AbstractDialog(
          width: Configuration.width*0.4,
          height: Configuration.width*0.2,
          content: AnimatedProgress(progress: progress),
      );
      }).then((val){
        if (_timer.isActive) {
          _timer.cancel();
        }
  });
}



class AnimatedProgress extends StatefulWidget {
  final Progress progress;

  const AnimatedProgress({
    this.progress,
    Key key,
  }) : super(key: key);

  @override
  _AnimatedProgressState createState() => _AnimatedProgressState();
}

class _AnimatedProgressState extends State<AnimatedProgress> {
  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      duration: Duration(seconds: 2),
      alignment: Alignment.topCenter,
      child:  Container(
      margin: EdgeInsets.all(Configuration.medmargin),
      width: Configuration.width *0.4,
      height: Configuration.width*0.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0), 
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(2, 2), // changes position of shadow
          ),
        ]
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: Configuration.width*0.1,
            child: Text(widget.progress.done.toString() + '/' + widget.progress.total.toString(), style: Configuration.text('smallmedium', Colors.black)),
          ),
          Text(widget.progress.what, style:Configuration.text('small', Colors.grey), textAlign: TextAlign.center,)
        ],
      ),
    ));
  }
}