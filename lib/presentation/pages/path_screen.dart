import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/radial_progress.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:provider/provider.dart';

class PathScreen extends StatelessWidget {
  PathScreen();

  Widget porcentaje() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: Configuration.height * 0.05),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You are currently on ',
                style: Configuration.text('smallmedium', Colors.white)),
            Text('Stage ' + _userstate.user.stagenumber.toString(),
                style: Configuration.text(
                    'smallmedium', Configuration.accentcolor))
          ],
        ),
        SizedBox(height: Configuration.height * 0.05),
        RadialProgress(
          goalCompleted: 0.7,
          progressColor: Configuration.accentcolor,
          progressBackgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(Configuration.smpadding),
            child: Text('70%', style: Configuration.text('medium', Colors.white),),
          ),
        ),
        SizedBox(height: Configuration.height * 0.05),
        Container(
          width: Configuration.width * 0.95,
          padding: EdgeInsets.symmetric(
              vertical: Configuration.smpadding,
              horizontal: Configuration.smpadding),
          decoration: BoxDecoration(
              color: Configuration.lightpurple,
              borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              Row(children: [
                Text(
                  'Goals: ',
                  style: Configuration.text('small', Configuration.accentcolor),
                ),
                Text(_userstate.user.stage.goals,
                    style: Configuration.text('small', Colors.white))
              ]),
              SizedBox(height: Configuration.safeBlockVertical * 1),
              Row(children: [
                Text('Obstacles: ',
                    style:
                        Configuration.text('small', Configuration.accentcolor)),
                Text(_userstate.user.stage.obstacles,
                    style: Configuration.text('small', Colors.white))
              ]),
              SizedBox(height: Configuration.safeBlockVertical * 1),
              Row(children: [
                Text('Skills: ',
                    style:
                        Configuration.text('small', Configuration.accentcolor)),
                Text(_userstate.user.stage.skills,
                    style: Configuration.text('small', Colors.white))
              ]),
              SizedBox(height: Configuration.safeBlockVertical * 1),
              Row(children: [
                Text('Mastery: ',
                    style:
                        Configuration.text('small', Configuration.accentcolor)),
                Text(_userstate.user.stage.mastery,
                    style: Configuration.text('small', Colors.white),
                    overflow: TextOverflow.visible)
              ]),
            ],
          ),
        )
      ],
    );
  }
}
