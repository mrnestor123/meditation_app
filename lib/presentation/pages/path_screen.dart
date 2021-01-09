import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/radial_progress.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:provider/provider.dart';

class PathScreen extends StatelessWidget {
  PathScreen();

  UserState _userstate;

  Widget porcentaje() {
    double goal;
    int achieveduser = 0;
    int stageobjective = 0;

    //esto se tendrá que sacar en el modelo
    _userstate.user.stats.forEach((key, value) {
      if (key != 'ultimosleidos' && key != 'racha') {
        achieveduser += value;
      }
    });

    _userstate.user.stage.objectives.forEach((key, value) {
      if (key != 'meditation') {
        stageobjective += value;
      } else {
        stageobjective += value.length;
      }
    });

    return RadialProgress(
      goalCompleted: (achieveduser/stageobjective),
      progressColor: Configuration.accentcolor,
      progressBackgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(Configuration.smpadding),
        child: Text(
          (achieveduser*100/stageobjective).round().toString() + '%',
          style: Configuration.text('medium', Colors.white),
        ),
      ),
    );
  }

  Widget goals() {
    return Container(
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
                style: Configuration.text('small', Configuration.accentcolor)),
            Text(_userstate.user.stage.obstacles,
                style: Configuration.text('small', Colors.white))
          ]),
          SizedBox(height: Configuration.safeBlockVertical * 1),
          Row(children: [
            Text('Skills: ',
                style: Configuration.text('small', Configuration.accentcolor)),
            Text(_userstate.user.stage.skills,
                style: Configuration.text('small', Colors.white))
          ]),
          SizedBox(height: Configuration.safeBlockVertical * 1),
          Row(children: [
            Text('Mastery: ',
                style: Configuration.text('small', Configuration.accentcolor)),
            Text(_userstate.user.stage.mastery,
                style: Configuration.text('small', Colors.white),
                overflow: TextOverflow.visible)
          ]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);
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
        porcentaje(),
        SizedBox(height: Configuration.height * 0.05),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  _userstate.user.stats['tiempo'].toString() +
                      '/' +
                      _userstate.user.stage.objectives['totaltime'].toString(),
                  style:
                      Configuration.text('medium', Configuration.accentcolor),
                ),
                Text(
                  'Hours\nmeditated',
                  style: Configuration.text('small', Configuration.whitecolor),
                  textAlign: TextAlign.center,
                )
              ],
            ),
            Column(
              children: [
                Text(
                  _userstate.user.stats['maxstreak'].toString() +
                      '/' +
                      _userstate.user.stage.objectives['streak'].toString(),
                  style:
                      Configuration.text('medium', Configuration.accentcolor),
                ),
                Text(
                  'Meditation\nstreak',
                  style: Configuration.text('small', Configuration.whitecolor),
                  textAlign: TextAlign.center,
                )
              ],
            ),
            Column(
              children: [
                Text(
                  '0' +
                      '/' +
                      _userstate.user.stage.objectives['meditation']['count']
                          .toString(),
                  style:
                      Configuration.text('medium', Configuration.accentcolor),
                ),
                Text(
                  _userstate.user.stage.objectives['meditation']['time']
                          .toString() +
                      ' min\nmeditations',
                  style: Configuration.text('small', Configuration.whitecolor),
                  textAlign: TextAlign.center,
                )
              ],
            )
          ],
        ),
        SizedBox(height: Configuration.height * 0.05),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Column(
            children: [
              Text(
                _userstate.user.stats['totallecciones'].toString() +
                    '/' +
                    _userstate.user.stage.objectives['totallessons'].toString(),
                style: Configuration.text('medium', Configuration.accentcolor),
              ),
              Text(
                'Taken\nlessons',
                style: Configuration.text('small', Configuration.whitecolor),
                textAlign: TextAlign.center,
              )
            ],
          ),
          Column(
            children: [
              Text(
                _userstate.user.stats['totalmeditaciones'].toString() +
                    '/' +
                    _userstate.user.stage.objectives['totalmeditations']
                        .toString(),
                style: Configuration.text('medium', Configuration.accentcolor),
              ),
              Text(
                'Guided\nmeditations',
                style: Configuration.text('small', Configuration.whitecolor),
                textAlign: TextAlign.center,
              )
            ],
          )
        ]),
        SizedBox(height: Configuration.height * 0.05),
        goals()
      ],
    );
  }
}
