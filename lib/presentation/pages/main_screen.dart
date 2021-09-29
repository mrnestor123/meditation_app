import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meditation_app/domain/entities/action_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/mobx/login_register/login_state.dart';
import 'package:timezone/timezone.dart' as tz;


import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:provider/provider.dart';

import 'commonWidget/stage_card.dart';
import 'main.dart';

class MainScreen extends StatefulWidget {
  MainScreen();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  UserState _userstate;
  LoginState _loginstate;

  Color darken(Color c, [int percent = 0]) {
    assert(0 <= percent && percent <= 100);
    var f = 1 - percent / 100;
    return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(),
        (c.blue * f).round());
  }

  @override
  Widget build(BuildContext context) {
    UserState _userstate = Provider.of<UserState>(context);
    return Flex(
    direction: Configuration.width > 600 ? Axis.horizontal : Axis.vertical,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(height: 20),
      /*ElevatedButton(onPressed: (){
        scheduleNotification();
      }, child: Text("NOtification")),
      */
      Flexible(
        flex: 2,
        child:StageCard(stage: _userstate.user.stage),
      ),
      SizedBox(height: 20,width: 20),
      Expanded(
        flex: 4,
        child:_Timeline()
      ),
    ]);
  }
}

class _Timeline extends StatefulWidget {
  bool isTablet;

  _Timeline({this.isTablet = false});

  @override
  __TimelineState createState() => __TimelineState();
}

class __TimelineState extends State<_Timeline> {
  UserState _userstate;
  String mode = 'Today'; 
  List<User> users = new List.empty(growable: true);
  var states = ['Today','This week'];
  
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies()async {
    super.didChangeDependencies();
    _userstate = Provider.of<UserState>(context);
    users = await _userstate.getUsersList(_userstate.user.following);
  }

  //Pasar ESTO FUERA !!! HACERLO SOLO UNA VEZ !!
  List<Widget> getMessages() { 
      List<UserAction> sortedlist = new List.empty(growable: true);
      
      mode == 'Today' ? sortedlist.addAll(_userstate.user.todayactions) : sortedlist.addAll(_userstate.user.thisweekactions);
      
      sortedlist.sort((a,b) => b.time.compareTo(a.time));

      List<Widget> widgets = new List.empty(growable: true);

      if (sortedlist.length > 0) {
        for (var action in sortedlist) {
          widgets.add(
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Stack(
                children: [
                  Container(
                  height:  Configuration.width*0.15,
                  width: Configuration.width*0.12,
                  child: Container(
                    decoration: BoxDecoration(
                      image: action.userimage != null ? DecorationImage(image: NetworkImage(action.userimage), fit: BoxFit.fitWidth) : null,
                      color: action.userimage == null ? Configuration.maincolor : null,
                      shape: BoxShape.circle
                    ),
                    width: Configuration.width*0.1,
                    height: Configuration.height*0.1
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 27,
                      height: 27,
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.lightBlue),
                      child: Icon(action.icono, color: Colors.white, size: 20.0) ),
                  ) 
                ],
              ),
              SizedBox(width: 5.0),
              Expanded(
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    Text((action.username == _userstate.user.nombre ? 'You': action.username) + ' ' + action.message,
                        style: Configuration.text('tiny', Colors.black, font: 'Helvetica'),
                        overflow: TextOverflow.fade,
                        ),
                    Text((mode == 'Today' ? '' : action.day + ' ') +   action.hour,
                        style: Configuration.text('tiny', Configuration.grey, font: 'Helvetica'))
                ]),
              )
            ]),
          );
          widgets.add(SizedBox(height: 10));
        }
      } else {
        widgets.add(SizedBox(height: 20));
        widgets.add(Center(child: Text('No actions realized ' + (mode == 'Today' ? 'today' : 'this week'), style: Configuration.text('small', Colors.grey, font: 'Helvetica'))));
      }

      Timer(Duration(milliseconds: 1), () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent));

      return widgets;
    }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);

    return Container(
        decoration: BoxDecoration(
          color:Colors.white,  
          borderRadius: BorderRadius.circular(16.0), 
          border: Border.all(color: Colors.grey, width: 0.15)),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
           children:[ 
              DropdownButton<String>(
                    value: mode,
                    elevation: 16,
                    style: Configuration.text('small', Colors.black),
                    underline: Container(
                      height: 0,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        mode = newValue;
                      });
                    },
                    items: states.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()
                ),
              RawMaterialButton(
                    elevation: 0.0,
                    fillColor: Configuration.maincolor,
                    child: Row(
                      children: [
                        Icon(Icons.leaderboard, color: Colors.white, size: widget.isTablet ? Configuration.tinpadding : Configuration.smicon),
                        Icon(Icons.person, color: Colors.white,size:widget.isTablet ? Configuration.tinpadding : Configuration.smicon)
                      ],
                    ),
                    padding: EdgeInsets.all(4.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                    onPressed: () {
                      //HABRA QUE CAMBIAR ESTO
                      widget.isTablet ? 
                      Navigator.pushNamed(context, '/tabletleaderboard').then((value) => setState(() => null)) :
                      Navigator.pushNamed(context, '/leaderboard').then((value) => setState(() => null));
                    },
                  ),
            ]
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 0.15,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Expanded(child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: ListView(
              controller: _scrollController,
              children: getMessages()))
            )
        ]));
  }
}


void scheduleNotification()async{
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'tenstages', 'tenstages', 'Channel for displaying shitt',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    
    await flutterLocalNotificationsPlugin.show(
    0, 'plain title', 'plain body', platformChannelSpecifics,
    payload: 'item x');
}


void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
