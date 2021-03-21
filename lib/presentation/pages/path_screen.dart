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
    var stageobj = _userstate.user.stage.objectives;
    var userst = _userstate.user.stats;
    int stageobjective = _userstate.user.stage.objectives.length ;

    if (stageobj['totaltime'] != null) {
      if (userst['etapa']['tiempo'] >= stageobj['totaltime']) {
        achieveduser++;
      }
    }

    if (stageobj['streak']  != null) {
      if (userst['etapa']['maxstreak'] >= stageobj['streak']) {
        achieveduser++;
      }
    }

    if (stageobj['meditation']['count']  != null) {
      if (userst['etapa']['medittiempo'] >= stageobj['meditation']['count']) {
        achieveduser++;
      }
    }

    if (stageobj['lecciones']  != null) {
      if (userst['etapa']['lecciones'] >= stageobj['lecciones']) {
        achieveduser++;
      }
    }

    if (stageobj['meditguiadas']  != null) {
      if (userst['etapa']['meditguiadas'] >= stageobj['meditguiadas']) {
        achieveduser++;
      }
    }

    return RadialProgress(
      goalCompleted: 100.0,
      progressColor: Colors.transparent,
      progressBackgroundColor: Colors.grey,
      child: Container(
        padding: EdgeInsets.all(Configuration.blockSizeHorizontal * 2),
        child: RadialProgress(
          goalCompleted: (achieveduser / stageobjective),
          progressColor: Configuration.maincolor,
          progressBackgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(Configuration.medpadding),
            child: Text(
              (achieveduser * 100 / stageobjective).round().toString() + '%',
              style: Configuration.text('medium', Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  Widget goals() {
    return Container(
      width: Configuration.width,
      padding: EdgeInsets.symmetric(
          vertical: Configuration.smpadding,
          horizontal: Configuration.smpadding),
      decoration: BoxDecoration(
          color: Configuration.maincolor,
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Row(children: [
            Text(
              'Goals ',
              style: Configuration.text('small', Colors.black),
            ),
            Flexible(child:Text(_userstate.user.stage.goals,
                style: Configuration.text('small', Colors.white)))
          ]),
          SizedBox(height: Configuration.safeBlockVertical * 1),
          Row(children: [
            Text('Obstacles ',
                style: Configuration.text('small', Colors.black)),
            Flexible(
                          child: Text(_userstate.user.stage.obstacles,
                  style: Configuration.text('small', Colors.white)),
            )
          ]),
          SizedBox(height: Configuration.safeBlockVertical * 1),
          Row(children: [
            Text('Skills ',
                style: Configuration.text('small', Colors.black)),
            Flexible(
                  child: Text(_userstate.user.stage.skills,
                  style: Configuration.text('small', Colors.white)),
            )
          ]),
          SizedBox(height: Configuration.safeBlockVertical * 1),
          Row(children: [
            Text('Mastery ',
                style: Configuration.text('small', Colors.black)),
            Flexible(
                  child: Text(_userstate.user.stage.mastery,
                  style: Configuration.text('small', Colors.white),
                  overflow: TextOverflow.visible),
            )
          ]),
        ],
      ),
    );
  }

  Widget data(dynamic value, dynamic valuestage, String text) {
    return Column(
      children: [
        value >= valuestage
            ? Icon(Icons.check_circle,
                size: Configuration.medpadding, color: Configuration.maincolor)
            : Text(
                (value).toString() + '/' + (valuestage).toString(),
                style: Configuration.text('medium', Configuration.maincolor),
              ),
        SizedBox(height: Configuration.blockSizeVertical * 0.2),
        Text(
          text,
          style: Configuration.text('small', Colors.black),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);
    return Container(
      height: Configuration.height,
      width: Configuration.width,
      color: Configuration.lightgrey,
      padding: EdgeInsets.symmetric(horizontal: Configuration.medpadding),
      child: SingleChildScrollView(
              child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Configuration.height * 0.025),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('You are currently on ',
                    style: Configuration.text('smallmedium', Colors.black)),
                Text('Stage ' + _userstate.user.stagenumber.toString(),
                    style: Configuration.text(
                        'medium', Configuration.maincolor))
              ],
            ),
            SizedBox(height: Configuration.height * 0.01),
            Text(_userstate.user.stage.description, style: Configuration.text('smallmedium',Colors.black), textAlign: TextAlign.center,),
            SizedBox(height: Configuration.height * 0.05),
            porcentaje(),
            SizedBox(height: Configuration.height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _userstate.user.stage.objectives['totaltime'] != null
                    ? data(
                        _userstate.user.stats['etapa']['tiempo'],
                        _userstate.user.stage.objectives['totaltime'],
                        'Min\nmeditated')
                    : Container(),
                _userstate.user.stage.objectives['streak'] != null
                    ? data(
                        _userstate.user.stats['etapa']['maxstreak'],
                        _userstate.user.stage.objectives['streak'],
                        'Meditation\nstreak')
                    : Container(),
                _userstate.user.stage.objectives['meditation'].entries.length > 0
                    ? data(
                        _userstate.user.stats['etapa']['medittiempo'],
                        _userstate.user.stage.objectives['meditation']['count'],
                        _userstate.user.stage.objectives['meditation']['time']
                                .toString() +
                            ' min\nmeditations')
                    : Container()
              ],
            ),
            SizedBox(height: Configuration.height * 0.05),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              data(
                  _userstate.user.stats['etapa']['lecciones'],
                  _userstate.user.stage.objectives['lecciones'],
                  'Taken\nlessons'),
              data(
                  _userstate.user.stats['etapa']['meditguiadas'],
                  _userstate.user.stage.objectives['meditguiadas'],
                  'Guided\nmeditations')
            ]),
            SizedBox(height: Configuration.height * 0.05),
            goals()
          ],
        ),
      ),
    );
  }
}
