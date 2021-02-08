import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/meditation_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:provider/provider.dart';

import 'config/configuration.dart';

//esto es mejorable
int seltime = 1;

class MeditationScreen extends StatefulWidget {
  @override
  _MeditationScreenState createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  UserState _userstate;
  MeditationState _meditationstate;

  Widget initialPage(context) {
    Widget freeMeditation() {
      return Column(
        children: [
          TimePicker(),
          SizedBox(height: Configuration.height * 0.1),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              _meditationstate.startMeditation(
                  Duration(minutes: seltime), _userstate.user, _userstate.data);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Configuration.maincolor,
              ),
              padding: EdgeInsets.all(Configuration.smpadding),
              width: Configuration.width * 0.3,
              height: Configuration.height * 0.1,
              child: Center(
                child: Text(
                  'Start',
                  style: Configuration.text('medium', Colors.white),
                ),
              ),
            ),
          )
        ],
      );
    }

    Widget guidedMeditation() {
      List<Widget> meditations() {
        List<Widget> meditations = new List<Widget>();

        _userstate.data.stages[0].meditpath.forEach((key, list) {
          for (var meditation in list) {
            meditations.add(GestureDetector(
                onTap: () => print('tapped'),
                child: Container(
                  height: Configuration.height * 0.12,
                  width: Configuration.width * 0.12,
                  child: Stack(children: [
                    Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Image.network(meditation.image)),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(meditation.title,
                            style: Configuration.text('small', Colors.white)))
                  ]),
                )));
          }
        });

        return meditations;
      }

      return Column(
        children: [
          Text('Choose your meditation',
              style: Configuration.text('small', Colors.black)),
          Expanded(child: Column(children: meditations()))
        ],
      );
    }

    return Column(children: [
      SizedBox(height: Configuration.height * 0.1),
      Text(
        '''Choose the\n meditation type ''',
        style: Configuration.text('medium', Colors.white),
        textAlign: TextAlign.center,
      ),
      Divider(color: Colors.white),
      SizedBox(height: Configuration.height * 0.1),
      GestureDetector(
        onTap: () => showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => Container(
                height: Configuration.height * 0.85,
                padding: EdgeInsets.all(Configuration.smpadding),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))),
                child: freeMeditation())),
        child: Container(
          width: Configuration.width * 0.9,
          height: Configuration.height * 0.2,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0), color: Colors.white),
          child: Center(
              child: Text('Free',
                  style: Configuration.text('big', Configuration.maincolor))),
        ),
      ),
      SizedBox(height: Configuration.height * 0.1),
      GestureDetector(
        onTap: () => showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => Container(
                height: Configuration.height * 0.8,
                padding: EdgeInsets.all(Configuration.medpadding),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))),
                child: guidedMeditation())),
        child: Container(
          width: Configuration.width * 0.9,
          height: Configuration.height * 0.2,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0), color: Colors.white),
          child: Center(
              child: Text('Guided',
                  style: Configuration.text('big', Configuration.maincolor))),
        ),
      ),
      SizedBox(height: Configuration.height * 0.1),
      Container()
    ]);
  }

  Widget countDown(context) {
    return Stack(children: [
      AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.close),
            iconSize: Configuration.medicon,
            onPressed: () => Navigator.pop(context)),
      ),
      Container(
        height: Configuration.height,
        width: Configuration.width,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Observer(builder: (BuildContext context) {
            if (_meditationstate.duration != null) {
              return Text(
                  _meditationstate.duration.inHours > 0
                      ? _meditationstate.duration.toString().substring(0, 7)
                      : _meditationstate.duration.toString().substring(2, 7),
                  style: Configuration.text('huge', Colors.white));
            }
          }),
          SizedBox(height: Configuration.blockSizeHorizontal * 5),
          Observer(builder: (context) {
            if (_meditationstate.state == 'started') {
              return FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () => _meditationstate.pause(),
                  child: Icon(Icons.pause, color: Colors.black));
            } else {
              return FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () => _meditationstate.startTimer(),
                  child: Icon(Icons.play_arrow, color: Colors.black));
            }
          })
        ]),
      )
    ]);
  }

  Widget finish(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: Configuration.height,
          width: Configuration.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                  onTap: () => _meditationstate.finishMeditation(),
                  child: Text('hola')),
              WeekList(),
              SizedBox(height: Configuration.height * 0.05),
              Text(
                  'Total meditations: ' +
                      (_userstate.user.totalMeditations.length).toString(),
                  style: Configuration.text('medium', Colors.white))
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _meditationstate = Provider.of<MeditationState>(context);
    _userstate = Provider.of<UserState>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
          height: Configuration.height,
          color: Configuration.maincolor,
          width: Configuration.width,
          child: Observer(
            builder: (BuildContext context) {
              if (_meditationstate.state == 'initial') {
                return initialPage(context);
              } else if (_meditationstate.state == 'started' ||
                  _meditationstate.state == 'paused') {
                return countDown(context);
              } else {
                return finish(context);
              }
            },
          )),
    );
  }
}

class TimePicker extends StatefulWidget {
  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  @override
  void initState() {
    seltime = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleCircularSlider(
      95,
      1,
      baseColor: Colors.transparent,
      handlerColor: Configuration.maincolor,
      onSelectionChange: (a, b, c) {
        setState(() {
          seltime = b;
          print(seltime);
        });
      },
      height: Configuration.height * 0.2,
      width: Configuration.height * 0.2,
      selectionColor: Configuration.maincolor,
      child: Center(
          child: Text(
        seltime.toString() + ' min',
        style: Configuration.text('medium', Colors.black),
      )),
    );
  }
}

//REFACTORIZAR ESTO CON EL TIEMPO!!
List<Map> weekDays = [
  {'day': "M", 'meditated': false, 'index': 1},
  {'day': 'T', 'meditated': false, 'index': 2},
  {'day': 'W', 'meditated': false, 'index': 3},
  {'day': 'TH', 'meditated': false, 'index': 4},
  {'day': 'F', 'meditated': false, 'index': 5},
  {'day': 'S', 'meditated': false, 'index': 6},
  {'day': 'S', 'meditated': false, 'index': 7}
];

class WeekList extends StatefulWidget {
  @override
  _WeekListState createState() => _WeekListState();
}

class _WeekListState extends State<WeekList> {
  UserState _userstate;

  List<Widget> getDays() {
    List<Widget> result = new List();
    var dayOfWeek = 1;
    DateTime today = DateTime.now();
    var weekday = today.weekday;
    //   var monday = today.subtract(Duration(days: today.weekday - dayOfWeek));
    var meditationstreak = 0;

    List<Meditation> meditations = _userstate.user.totalMeditations;

    if (meditationstreak == 1) {
      weekDays[--weekday]['meditated'] = true;
    } else {
      while (meditationstreak-- != 0 && weekday > 1) {
        weekDays[weekday--]['meditated'] = true;
      }
    }

    for (var e in weekDays) {
      result.add(WeekItem(
          day: e['day'],
          meditated: e['meditated'],
          animate: today.weekday == e['index']));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);
    return Container(
      width: Configuration.width * 0.9,
      child: Column(
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: getDays()),
          SizedBox(height: Configuration.height * 0.05),
        ],
      ),
    );
  }
}

class WeekItem extends StatefulWidget {
  bool meditated;
  bool animate;
  String day;

  WeekItem({this.day, this.meditated, this.animate});

  @override
  _WeekItemState createState() => _WeekItemState();
}

class _WeekItemState extends State<WeekItem> {
  bool changed = false;
  @override
  Widget build(BuildContext context) {
    print(changed);
    if (widget.animate && !changed) {
      var timer =
          Timer(Duration(seconds: 1), () => setState(() => changed = true));
    }

    return AnimatedContainer(
      width: Configuration.width * 0.1,
      height: Configuration.width * 0.1,
      duration: Duration(seconds: 3),
      curve: Curves.easeIn,
      decoration: new BoxDecoration(
        color: widget.meditated && !widget.animate || widget.animate && changed
            ? Colors.white
            : Configuration.grey,
        shape: BoxShape.circle,
      ),
      child: Center(
          child: Text(widget.day,
              style: TextStyle(
                  color: widget.meditated && !widget.animate ||
                          widget.animate && changed
                      ? Colors.black
                      : Colors.white))),
    );
  }
}
