import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/action_entity.dart';
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Configuration.height * 0.025),
              AspectRatio(
                aspectRatio: 16/9,
                  child: Container(
                  margin: EdgeInsets.all(Configuration.medmargin),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(16.0)),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/imagepath'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Stage ' + _userstate.user.stagenumber.toString(),
                          style: Configuration.text('small', Colors.white),
                        ),
                        Expanded(child: Image(image: AssetImage('assets/stage 1/stage 1.png'))),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Configuration.maincolor,
                        onPrimary: Colors.white,
                        padding: EdgeInsets.all(Configuration.smpadding),
                        minimumSize: Size(double.infinity, double.infinity)),
                  ),
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
              _Timeline(),
              SizedBox(height: Configuration.height*0.05)
            ]),
      ),
    );
  }
}


class _Timeline extends StatefulWidget {
  @override
  __TimelineState createState() => __TimelineState();
}

class __TimelineState extends State<_Timeline> {
  UserState _userstate;
  String mode = 'today'; 

   //Hay que crear un filtro de acciones !!!!!!!
  List<Widget> getMessages() {
      DateTime today = DateTime.now();
      DateTime filtereddate = mode == 'today' ? today : DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1, hours: today.hour));
      List<UserAction> sortedlist = _userstate.user.acciones.where((a) => mode == 'today' && a.time.year == filtereddate.year && a.time.day == filtereddate.day && a.time.month == filtereddate.month || mode == 'thisweek' && filtereddate.compareTo(a.time) <= 0 ).toList();
      List<Widget> widgets = new List.empty(growable: true);


      if (sortedlist.length > 0) {
        for (var action in sortedlist) {
          widgets.add(
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.lightBlue,
                child: Icon(action.icono),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  Container(
                    width: Configuration.width*0.62,
                    child: Text((action.username == _userstate.user.nombre ? 'You ': action.username) + action.message,
                        style: Configuration.text('small', Colors.black),
                        overflow: TextOverflow.fade,
                        ),
                  ),
                  Text((mode == 'today' ? ' ' : action.day + ' ') +   action.hour,
                      style: Configuration.text('tiny', Configuration.grey))
              ])
            ]),
          );
          widgets.add(SizedBox(height: Configuration.safeBlockVertical * 2));
        }
      } else {
        widgets.add(Center(child: Text('No actions realized ' + (mode == 'today' ? 'today' : 'this week'), style: Configuration.text('small', Colors.grey))));
      }

      return widgets;
    }


  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);

    return Container(
        width: Configuration.width * 0.8,
        height: Configuration.height * 0.3,
        padding: EdgeInsets.all(Configuration.tinpadding),
        color: Colors.white,
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
           children:[ 
              OutlinedButton(
                onPressed: ()=> setState(()=> mode = 'thisweek'),
                style: OutlinedButton.styleFrom(
                  backgroundColor: mode == 'thisweek' ? Configuration.maincolor : Colors.white
                ), 
                child: Text('THIS WEEK', style: Configuration.text('tiny', mode == 'thisweek' ? Colors.white : Colors.black))
              ),
              OutlinedButton(
                onPressed: ()=> setState(()=> mode = 'today'), 
                style: OutlinedButton.styleFrom(
                  backgroundColor: mode == 'today' ? Configuration.maincolor : Colors.white,
                ),
                child: Text('TODAY', style: Configuration.text('tiny', mode == 'today' ? Colors.white : Colors.black))
              ),
            ]
          ),
          Divider(),
          Expanded(child: ListView(children: getMessages()))
        ]));
  }
}