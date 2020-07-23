import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meditation_app/presentation/mobx/actions/meditation_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:provider/provider.dart';

class SetMeditation extends StatefulWidget {
  @override
  _SetMeditationState createState() => _SetMeditationState();
}

Duration duration;

class _SetMeditationState extends State<SetMeditation> {
  Timer _timer;
  Duration _duration;
  bool _started;
  IconData icon;
  UserState _loginstate;

  bool added = false;

  //changes between initial, meditating and finished
  String state = 'initial';

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void populateTimer() {
    icon = Icons.pause;
    _duration = duration;
    _started = true;
    print('starting timer with duration ' + _duration.toString());
    startTimer();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              if (_duration.inSeconds < 1) {
                state = 'finished';
                timer.cancel();
              } else {
                _duration = _duration - oneSec;
              }
            }));
  }

  Widget countDown() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
            child: Container(
                margin: EdgeInsets.all(16),
                alignment: Alignment.bottomCenter,
                child: Text(
                    _duration.inHours > 0
                        ? _duration.toString().substring(0, 7)
                        : _duration.toString().substring(2, 7),
                    style: Configuration.numbers))),
        Expanded(
            child: Container(
          margin: EdgeInsets.all(16),
          alignment: Alignment.topCenter,
          child: FloatingActionButton(
              backgroundColor: Colors.white,
              child: new Icon(icon, color: Colors.black),
              onPressed: () {
                setState(() {
                  if (_started) {
                    _timer.cancel();
                    icon = Icons.play_arrow;
                  } else {
                    startTimer();
                    icon = Icons.pause;
                  }
                  _started = !_started;
                });
              }),
        )),
      ],
    );
  }

  Widget preMeditation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text('Meditate', style: Configuration.subtitle2),
        Container(
            height: Configuration.height * 0.08,
            width: Configuration.width,
            padding: EdgeInsets.only(
                left: Configuration.width * 0.05,
                right: Configuration.width * 0.05),
            margin: EdgeInsets.all(Configuration.width * 0.05),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Duration', style: Configuration.settings),
                TimePicker()
              ],
            )),
        FloatingActionButton(
            child: Icon(Icons.check, color: Colors.black),
            backgroundColor: Colors.white,
            onPressed: () => duration.inSeconds > 0
                ? setState(() {
                    state = 'started';
                    populateTimer();
                  })
                : null)
      ],
    );
  }

  Widget finishedMeditation() {
    return Container(
      width: Configuration.width * 0.9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(FontAwesomeIcons.male,size: Configuration.blockSizeHorizontal*25),
          Text('Congrats',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: Configuration.safeBlockHorizontal * 10)),
          SizedBox(height: Configuration.safeBlockVertical * 2),
          Text(
              'You have completed a ' +
                  _printDuration(duration) +
                  ' meditation',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: Configuration.safeBlockHorizontal * 7)),
          SizedBox(height: Configuration.safeBlockVertical * 2),
          Text(
              'Total meditations: ' +
                  _loginstate.user.totalMeditations.length.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: Configuration.safeBlockHorizontal * 7))
        ],
      ),
    );
  }

  Widget switchScreen(_meditationstate) {
    switch (state) {
      case 'started':
        return countDown();
      case 'initial':
        return preMeditation();
      case 'finished':
        return finishedMeditation();
    }
    return Container();
  }

  void takeMeditation() async {
    await _loginstate.takeMeditation(duration);
  }

  @override
  Widget build(BuildContext context) {
    final _meditationstate = Provider.of<MeditationState>(context);
    _loginstate = Provider.of<UserState>(context);
    if (state == 'finished' && !added) {
      added = true;
      takeMeditation();
    }
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
            height: Configuration.height,
            width: Configuration.width,
            child: switchScreen(_meditationstate),
            decoration: BoxDecoration(color: Configuration.maincolor)),
        new Positioned(
          //Place it at the top, and not use the entire screen
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: state != 'initial'
                  ? Icon(Icons.close,
                      size: Configuration.iconSize, color: Colors.white)
                  : Icon(Icons.arrow_back,
                      size: Configuration.iconSize, color: Colors.white),
              onPressed: () {
                if (state != 'initial' && state != 'finished') {
                  showDialog(
                      context: context,
                      builder: (_) => CustomDialog(),
                      barrierDismissible: false);
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ),
      ],
    ));
  }
}

class CustomDialog extends StatelessWidget {
  CustomDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  top: Configuration.safeBlockVertical * 4,
                  left: Configuration.safeBlockVertical * 2,
                  bottom: Configuration.safeBlockVertical * 2,
                  right: Configuration.safeBlockVertical * 2),
              margin: EdgeInsets.only(top: Configuration.safeBlockVertical * 3),
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(17),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 10.0))
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Are you sure?',
                      style: TextStyle(
                          fontSize: Configuration.safeBlockHorizontal * 8,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: Configuration.safeBlockVertical * 3),
                  Text("This meditation will not count if you exit now."),
                  SizedBox(height: Configuration.safeBlockVertical * 4)
                ],
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Row(
                children: <Widget>[
                  FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('No')),
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text('Yes')),
                ],
              ),
            )
          ],
        ));

    /*return AlertDialog(
          title: Text("You can't come back"),
          shape: ContinuousRectangleBorder(),
          backgroundColor: Colors.grey,
          content: Text(
              "This session won't count if you abandon now. Do you want to exit?"),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );*/
  }
}

class TimePicker extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<TimePicker> {
  int hours;
  int minutes;
  int seconds;

  @override
  void initState() {
    super.initState();
    hours = 0;
    minutes = 0;
    seconds = 0;
    duration = new Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  @override
  Widget build(BuildContext context) {
    // final _meditationBloc = BlocProvider.of<MeditationBloc>(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            child: GestureDetector(
          child: Text(hours.toString() +
              ' : ' +
              minutes.toString() +
              ' : ' +
              seconds.toString()),
          onTap: () => showModalBottomSheet(
              context: context,
              builder: (BuildContext builder) {
                return CupertinoTimerPicker(
                    mode: CupertinoTimerPickerMode.hms,
                    minuteInterval: 1,
                    secondInterval: 1,
                    initialTimerDuration: duration,
                    onTimerDurationChanged: (Duration changedtimer) {
                      setState(() {
                        duration = changedtimer;
                        hours = changedtimer.inSeconds ~/ 3600;
                        minutes = (changedtimer.inSeconds % 3600) ~/ 60;
                        seconds = (changedtimer.inSeconds % 3600) % 60;
                      });
                    });
              }),
        )),
      ],
    );
  }
}

/** 

class FinishedMeditation extends StatelessWidget {
  Duration duration;

  FinishedMeditation({this.duration});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class PreMeditation extends StatelessWidget {
  const PreMeditation({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _meditationstate = Provider.of<MeditationState>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text('Meditate', style: Configuration.title),
        Container(
            height: Configuration.height * 0.08,
            width: Configuration.width,
            padding: EdgeInsets.only(
                left: Configuration.width * 0.05,
                right: Configuration.width * 0.05),
            margin: EdgeInsets.all(Configuration.width * 0.05),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Duration', style: Configuration.settings),
                TimePicker()
              ],
            )),
        FloatingActionButton(
            child: Icon(Icons.check, color: Colors.black),
            backgroundColor: Colors.white,
            onPressed: () => duration.inSeconds > 0
                ? _meditationstate.startMeditation(duration)
                : null)
      ],
    );
  }
}



class CountDownWidget extends StatefulWidget {
  final Duration duration;

  CountDownWidget({this.duration});

  @override
  _CountDownWidgetState createState() => _CountDownWidgetState();
}

class _CountDownWidgetState extends State<CountDownWidget> {
  Timer _timer;
  Duration _duration;
  bool _started;
  IconData icon;
  bool finished = false;

  @override
  void initState() {
    super.initState();
    icon = Icons.pause;
    _duration = widget.duration;
    _started = true;
    print('starting timer with duration ' + _duration.toString());
    startTimer();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              if (_duration.inSeconds < 1) {
                timer.cancel();
                finished = true;
              } else {
                _duration = _duration - oneSec;
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    final _meditationstate = Provider.of<MeditationState>(context);
    final _userstate = Provider.of<UserState>(context);
    if (finished) {
      _userstate.takeMeditation(widget.duration);
    }
    return finished
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Container(
                      margin: EdgeInsets.all(16),
                      alignment: Alignment.bottomCenter,
                      child: Text(
                          _duration.inHours > 0
                              ? _duration.toString().substring(0, 7)
                              : _duration.toString().substring(2, 7),
                          style: Configuration.numbers))),
              Expanded(
                  child: Container(
                margin: EdgeInsets.all(16),
                alignment: Alignment.topCenter,
                child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    child: new Icon(icon, color: Colors.black),
                    onPressed: () {
                      setState(() {
                        if (_started) {
                          _timer.cancel();
                          icon = Icons.play_arrow;
                        } else {
                          startTimer();
                          icon = Icons.pause;
                        }
                        _started = !_started;
                      });
                    }),
              )),
            ],
          );
  }
}
*/
