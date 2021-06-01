import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/action_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
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
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0)
                  ),
                  child: TextButton(
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                        primary: Configuration.maincolor,
                        elevation: 0.0,
                        onPrimary: Colors.white,
                        padding: EdgeInsets.all(Configuration.smpadding),
                        minimumSize: Size(double.infinity, double.infinity)),
                  ),
                ),
              ),
              SizedBox(height: Configuration.height * 0.05),
              _Timeline(),
              SizedBox(height: Configuration.height*0.05)
            ]),
      ),
    );
  }
}


class TabletMainScreen extends StatefulWidget {
  @override
  _TabletMainScreenState createState() => _TabletMainScreenState();
}

class _TabletMainScreenState extends State<TabletMainScreen> {
  @override
  Widget build(BuildContext context) {
    UserState _userstate = Provider.of<UserState>(context);

    return Container(
      height: Configuration.height,
      width: Configuration.width,
      color: Configuration.lightgrey,
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
            child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Configuration.width*0.4,
                child: AspectRatio(
                  aspectRatio: 16/9,
                    child: Container(
                    margin: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0)
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/imagepath'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Stage ' + _userstate.user.stagenumber.toString(),
                            style: Configuration.tabletText('tiny', Colors.white),
                          ),
                          Expanded(child: Image(image: AssetImage('assets/stage 1/stage 1.png'))),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                          primary: Configuration.maincolor,
                          elevation: 0.0,
                          onPrimary: Colors.white,
                          padding: EdgeInsets.all(12.0),
                          minimumSize: Size(double.infinity, double.infinity)),
                    ),
                  ),
                ),
              ),
              _Timeline(isTablet: true),
            ])
      ));
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
  var states = ['Today','This week'];

  //Pasar ESTO FUERA !!! 
  List<Widget> getMessages() { 
      List<User> following = _userstate.user.following;
      List<UserAction> sortedlist = mode == 'Today' ? _userstate.user.todayactions : _userstate.user.thisweekactions;

      //ESTO NO LO DEBERÍA DE HACER MÁS DE UNA VEZ
      for(User u in following) {
        if(mode == 'Today'){
          sortedlist.addAll(u.todayactions);
        } else {
          sortedlist.addAll(u.thisweekactions);
        }
      }

      List<Widget> widgets = new List.empty(growable: true);
      
      widgets.add(SizedBox(height:Configuration.blockSizeVertical*2));

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
                    width: Configuration.width*0.3,
                    child: Text((action.username == _userstate.user.nombre ? 'You ': action.username) + action.message,
                        style: widget.isTablet ? Configuration.tabletText('verytiny', Colors.black, font: 'Helvetica') :  Configuration.text('tiny', Colors.black, font: 'Helvetica'),
                        overflow: TextOverflow.fade,
                        ),
                  ),
                  Text((mode == 'today' ? '' : action.day + ' ') +   action.hour,
                      style:widget.isTablet ? Configuration.tabletText('verytiny', Colors.black, font: 'Helvetica') : Configuration.text('tiny', Configuration.grey, font: 'Helvetica'))
              ])
            ]),
          );
          widgets.add(SizedBox(height: Configuration.safeBlockVertical * 2));
        }
      } else {
        widgets.add(Center(child: Text('No actions realized ' + (mode == 'Today' ? 'today' : 'this week'), style: widget.isTablet ? Configuration.tabletText('tiny', Colors.grey, font: 'Helvetica') : Configuration.text('small', Colors.grey, font: 'Helvetica'))));
      }

      return widgets;
    }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);

    return Container(
        width: Configuration.width * (widget.isTablet == null ? 0.8 : 0.4),
        height: Configuration.height *(widget.isTablet == null ? 0.8 : 0.7),
        decoration: BoxDecoration(
          color:Colors.white,  
          borderRadius: BorderRadius.circular(16.0), 
          border: Border.all(color: Colors.grey, width: 0.15)),
        padding: EdgeInsets.all(widget.isTablet ? 16.0 : Configuration.tinpadding),
        margin: EdgeInsets.all(widget.isTablet ? 16.0 : 0.0) ,
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
           children:[ 
              DropdownButton<String>(
                    value: mode,
                    elevation: 16,
                    style: widget.isTablet ? Configuration.tabletText('tiny', Colors.black) : Configuration.text('small', Colors.black),
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
                      Navigator.pushNamed(context, '/leaderboard').then((value) => setState(() => null));
                    },
                  ),
            ]
          ),
          Divider(),
          Expanded(child: ListView(children: getMessages()))
        ]));
  }
}