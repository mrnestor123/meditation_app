import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';

import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  MainScreen();

  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);
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
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/imagepath'),
              child: Container(
                  width: Configuration.width * 0.9,
                  height: Configuration.height * 0.2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Configuration.lightpurple),
                  child: Center(
                      child: Image(
                          width: Configuration.width * 0.75,
                          image: AssetImage('assets/stage 1/stage 1.png')))),
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
                      Navigator.pushNamed(context, '/premeditation');
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
                    Navigator.pushNamed(context, '/leaderboard');
                  },
                ),
                Container(
                    child: Text('Explore',
                        style: Configuration.text('large', Colors.black)),
                    margin: EdgeInsets.only(top: 10)),
              ])
            ])
          ]),
    );
  }
}
