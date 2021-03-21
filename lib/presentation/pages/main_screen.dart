import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';

import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  MainScreen();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  UserState _userstate;

  Color darken(Color c, [int percent = 0]) {
    assert(0 <= percent && percent <= 100);
    var f = 1 - percent / 100;
    return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(),
        (c.blue * f).round());
  }

  Widget timeline() {
    List<Widget> getMessages(String day) {
      List<Widget> widgets = new List();
      if (_userstate.user.actions[day] != null &&
          _userstate.user.actions[day].length > 0) {
        print(_userstate.user.actions);

        for (var action in _userstate.user.actions[day]) {
          widgets.add(
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.lightBlue,
                child: Icon(action['type'].contains('meditat') ||
                        action['type'].contains('game')
                    ? Icons.self_improvement
                    : action['type'].contains('less')
                        ? Icons.book
                        : action['type'].contains('unfollow')
                            ? Icons.person_add
                            : Icons.person_remove),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                    (action['user'] == _userstate.user.nombre
                            ? 'You'
                            : action['user']) +
                        ' ' +
                        action['message'],
                    style: Configuration.text('small', Colors.black)),
                Text(action['hour'],
                    style: Configuration.text('tiny', Configuration.grey))
              ])
            ]),
          );
          widgets.add(SizedBox(height: Configuration.safeBlockVertical * 2));
        }
      }

      return widgets;
    }

    return Container(
        width: Configuration.width * 0.8,
        height: Configuration.height * 0.3,
        padding: EdgeInsets.all(Configuration.tinpadding),
        color: Colors.white,
        child: Column(children: [
          Text('Today', style: Configuration.text('medium', Colors.black)),
          Expanded(
              child: ListView(
                  children: getMessages(DateTime.now().day.toString() +
                      '-' +
                      DateTime.now().month.toString())))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);
    return Container(
      height: Configuration.height,
      width: Configuration.width,
      color: Configuration.lightgrey,
      padding: EdgeInsets.symmetric(horizontal: Configuration.medpadding),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Configuration.height * 0.025),
            Container(
              margin: EdgeInsets.all(Configuration.medmargin),
              width: Configuration.width * 0.9,
              height: Configuration.height * 0.2,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(16.0)),
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/imagepath'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stage ' + _userstate.user.stagenumber.toString(),
                      style: Configuration.text('small', Colors.white),
                    ),
                    Expanded(
                        child: Image(
                            image: AssetImage('assets/stage 1/stage 1.png'))),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                    primary: Configuration.maincolor,
                    onPrimary: Colors.white,
                    padding: EdgeInsets.all(Configuration.smpadding),
                    minimumSize: Size(double.infinity, double.infinity)),
              ),
            ),
            SizedBox(height: Configuration.height * 0.05),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Column(
                children: [
                  RawMaterialButton(
                    fillColor: Configuration.maincolor,
                    child: Icon(Icons.timer,
                        color: Colors.white, size: Configuration.bigicon),
                    padding: EdgeInsets.all(4.0),
                    shape: CircleBorder(),
                    onPressed: () {
                      Navigator.pushNamed(context, '/premeditation')
                          .then((value) => setState(() => null));
                    },
                  ),
                  Container(
                    child: Text('Meditate',
                        style: Configuration.text('large', Colors.black)),
                    margin: EdgeInsets.only(top: 10),
                  )
                ],
              ),
              Column(children: [
                RawMaterialButton(
                  fillColor: Configuration.maincolor,
                  child: Icon(Icons.emoji_events,
                      color: Colors.white, size: Configuration.bigicon),
                  padding: EdgeInsets.all(4.0),
                  shape: CircleBorder(),
                  onPressed: () {
                    Navigator.pushNamed(context, '/leaderboard')
                        .then((value) => setState(() => null));
                  },
                ),
                Container(
                    child: Text('Explore',
                        style: Configuration.text('large', Colors.black)),
                    margin: EdgeInsets.only(top: 10)),
              ])
            ]),
            SizedBox(height: Configuration.height * 0.05),
            timeline()
          ]),
    );
  }
}
