

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/progress_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/html_towidget.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/main.dart';

import '../../../domain/entities/stage_entity.dart';


void autocloseDialog(User user, {isTablet = false}) async {
  try{
    Timer _timer;

    await Future.delayed(Duration(seconds:1));

    showGeneralDialog(
      context: navigatorKey.currentContext,
      barrierDismissible: false,
      barrierColor: user.progress.what.contains('stage') ? Colors.black : Colors.transparent,
      transitionDuration: Duration(milliseconds: 400),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(anim1),
          child: child,
        );
      },
      pageBuilder:(context, anim1, anim2) {
        _timer = Timer(Duration(seconds: 4), () {
          if(!user.progress.what.contains('stage')){
            // DESCOMENTAR ESTO !!!!
            user.progress = null;
            Navigator.of(context).pop();
          }
        });
        return AbstractDialog(
            content: isTablet 
            ? TabletAnimatedProgress(progress:user.progress)
            : AnimatedProgress(progress: user.progress),
        );
        }).then((val){
          if (_timer.isActive) {
            _timer.cancel();
          }
    });
  } catch(e){
    print(e);
  }
}

class TabletAnimatedProgress extends StatefulWidget {
  final Progress progress;

  const TabletAnimatedProgress({
    this.progress,
    Key key,
  }) : super(key: key);

  @override
  _TabletAnimatedProgressState createState() => _TabletAnimatedProgressState();
}

class _TabletAnimatedProgressState extends State<TabletAnimatedProgress> {
  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      duration: Duration(seconds: 2),
      alignment: Alignment.topCenter,
      child:  Container(
      margin: EdgeInsets.all(16),
      width: Configuration.width *0.2,
      height: Configuration.width*0.1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0), 
        color: Configuration.lightgrey,
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
            width: Configuration.width*0.2,
            child: Text(widget.progress.done.toString() + '/' + widget.progress.total.toString(), style: Configuration.tabletText('tiny', Colors.black), textAlign: TextAlign.center),
          ),
          Text(widget.progress.what, style:Configuration.tabletText('tiny', Colors.grey), textAlign: TextAlign.center,)
        ],
      ),
    ));
  }
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

  Widget progressDialog(){
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.only(top: Configuration.verticalspacing*2),
        padding: EdgeInsets.all(Configuration.smpadding),
        width: Configuration.width*0.4,
        decoration: BoxDecoration(
          color: Colors.lightBlue,
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(
            Configuration.borderRadius/2
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Configuration.width*0.2,
              child: Text(widget.progress.done.toString() + '/' + widget.progress.total.toString(), style: Configuration.text('big', Colors.white), textAlign: TextAlign.center),
            ),
            Text(widget.progress.what, style:Configuration.text('smallmedium', Colors.white), textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }

  Widget stageDialog(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height:Configuration.verticalspacing*3),
        Text('Congratulations', style: Configuration.text('big', Colors.white)),
        SizedBox(height:Configuration.verticalspacing*2),
        Text('You have updated to the next stage', style: Configuration.text('smallmedium', Colors.white) ),
        SizedBox(height: Configuration.verticalspacing * 2),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
            )
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(imageUrl: widget.progress.stage.shortimage, fit:BoxFit.cover, width: Configuration.width * 0.8, placeholder: (context, url) => Container(height: Configuration.width*0.2, width: Configuration.width*0.2,), errorWidget: (context, url, error) => Container(height: Configuration.width*0.2, width: Configuration.width*0.2,)),
              SizedBox(height: Configuration.verticalspacing),
              Padding(
                padding:EdgeInsets.only(left:6),
                child: Text('Stage '+ widget.progress.done.toString(), style: Configuration.text('big', Colors.white)),
              ),
              SizedBox(height: Configuration.verticalspacing),
              Padding(
                padding:EdgeInsets.only(left:6),
                child: Text(widget.progress.stage.description, style: Configuration.text('smallmedium', Colors.white)),
              ),
              SizedBox(height: Configuration.verticalspacing),
              htmlToWidget(widget.progress.stage.longdescription,color: Colors.white, fontsize: 14)
            ],
          ),
        ),
        SizedBox(height: Configuration.verticalspacing),
        Spacer(),
        BaseButton(
          color: Colors.red,
          text:'Close',
          textcolor: Colors.white,
          border: true,
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        SizedBox(height: Configuration.verticalspacing * 2),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.progress.what);
    return AnimatedOpacity(
      duration: Duration(seconds: 3),
      opacity: 1,
      child: widget.progress.what.contains('stage') ?
        stageDialog() : progressDialog(),
    );
  }
}




Widget stageUpdated({Stage s,UserState userstate, close}){
    return Container(
      color: Colors.black.withOpacity(0.9),
      padding: EdgeInsets.all(Configuration.smpadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height:Configuration.verticalspacing*5),
          Text('Congratulations', style: Configuration.text('big', Colors.white)),
          SizedBox(height:Configuration.verticalspacing*2),
          Text('You have updated to the next stage', style: Configuration.text('smallmedium', Colors.white) ),
          SizedBox(height: Configuration.verticalspacing * 2),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Configuration.borderRadius/3),
              border: Border.all(
                color: Colors.white,
              )
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(Configuration.borderRadius/3)),
                  child: CachedNetworkImage(
                    imageUrl: s.shortimage, 
                    fit:BoxFit.cover, 
                    width: Configuration.width,
                    placeholder: (context, url) => Container(height: Configuration.width*0.2, width: Configuration.width*0.2,), errorWidget: (context, url, error) => Container(height: Configuration.width*0.2, width: Configuration.width*0.2,))
                ),
                SizedBox(height: Configuration.verticalspacing),
                Padding(
                  padding:EdgeInsets.only(left:6),
                  child: Text('Stage '+ s.stagenumber.toString(), style: Configuration.text('big', Colors.black)),
                ),
                SizedBox(height: Configuration.verticalspacing/2),
                Padding(
                  padding:EdgeInsets.only(left:6),
                  child: Text(s.description, style: Configuration.text('smallmedium', Colors.black, font:'Helvetica')),
                ),
                SizedBox(height: Configuration.verticalspacing),
                htmlToWidget(s.longdescription,color: Colors.black, fontsize: 13)
              ],
            ),
          ),
          SizedBox(height: Configuration.verticalspacing),
          Spacer(),
          BaseButton(
            color: Colors.red,
            text:'Close',
            textcolor: Colors.white,
            border: true,
            onPressed: (){
              userstate.closeStageUpdate();
              close();
              //Navigator.of(navigatorKey.currentContext).pop();
            },
          ),
          SizedBox(height: Configuration.verticalspacing * 2),
        ],
      ),
    );
  }
