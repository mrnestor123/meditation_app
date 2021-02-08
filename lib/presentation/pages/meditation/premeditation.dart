import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/meditation_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

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
  final assetsAudioPlayer = AssetsAudioPlayer();

  bool added = false;

  //changes between initial, meditating and finished
  String state = 'initial';

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

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

  Future<void> startTimer() async {
    const oneSec = const Duration(seconds: 1);
    Wakelock.enable();

    // await AndroidAlarmManager.initialize();
    // await AndroidAlarmManager.periodic(duration, 0, callback)

    _timer = new Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              print("el estado sigue cambiando");
              if (_duration.inSeconds < 2) {
                state = 'finished';
                Wakelock.disable();
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
                  style: Configuration.text('huge', Colors.white),
                ))),
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
        Text('Meditate', style: Configuration.text('huge', Colors.white)),
        MeditationPicker(),
        TimePicker(),
        SoundPicker(),
        SizedBox(height: Configuration.height * 0.05),
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

  bool played = false;
  Widget finishedMeditation() {
    if (!played) {
      assetsAudioPlayer.open(Audio("assets/audios/gong.mp3"));
      played = true;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        WeekList(),
        SizedBox(height: Configuration.height * 0.05),
        Text(
            'Total meditations: ' +
                (_loginstate.user.totalMeditations.length).toString(),
            style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: Configuration.blockSizeHorizontal * 7))),
      ],
    );
  }

  Widget switchScreen(state) {
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
            child: switchScreen(state),
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
                  ? Icon(Icons.close, color: Colors.white)
                  : Icon(Icons.arrow_back, color: Colors.white),
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

class MeditationPicker extends StatefulWidget {
  @override
  _MeditationPickerState createState() => _MeditationPickerState();
}

class _MeditationPickerState extends State<MeditationPicker> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (BuildContext builder) {
            return Wrap(children: <Widget>[
              Container(
                padding: EdgeInsets.all(Configuration.safeBlockVertical * 4),
                margin: EdgeInsets.all(Configuration.safeBlockVertical * 2),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.all(Radius.circular(25.0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('title'),
                    SizedBox(height: Configuration.safeBlockVertical * 3),
                    Text('subtitle')
                  ],
                ),
              )
            ]);
          }),
      child: ContainerSelect(lefttext: 'Meditation', righttext: Text('none')),
    );
  }
}

class ContainerSelect extends StatelessWidget {
  String lefttext;
  Widget righttext;

  ContainerSelect({
    this.lefttext,
    this.righttext,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Configuration.height * 0.08,
        width: Configuration.width,
        padding: EdgeInsets.only(
            left: Configuration.width * 0.05,
            right: Configuration.width * 0.05),
        margin: EdgeInsets.only(
            top: Configuration.width * 0.05,
            left: Configuration.width * 0.05,
            right: Configuration.width * 0.05),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[Text(lefttext), righttext],
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
    return GestureDetector(
        onTap: () => showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (BuildContext builder) {
              return Wrap(
                children: [
                  Container(
                    margin: EdgeInsets.all(Configuration.safeBlockVertical * 2),
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.all(Radius.circular(25.0)),
                    ),
                    child: CupertinoTimerPicker(
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
                        }),
                  ),
                ],
              );
            }),
        child: ContainerSelect(
          lefttext: 'Duration',
          righttext: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text(hours.toString() +
                    ' : ' +
                    minutes.toString() +
                    ' : ' +
                    seconds.toString()),
              ),
            ],
          ),
        ));
  }
}

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
          Text(
            'to change',
            //_userstate.user.meditationstreak.toString() + ' consecutive days',
            style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: Configuration.blockSizeHorizontal * 7)),
          ),
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

class SoundPicker extends StatefulWidget {
  @override
  _SoundPickerState createState() => _SoundPickerState();
}

class _SoundPickerState extends State<SoundPicker> {
  IconData icon;

  @override
  void initState() {
    super.initState();
    icon = Icons.music_note;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (BuildContext builder) {
            return Wrap(children: <Widget>[
              Container(
                padding: EdgeInsets.all(Configuration.safeBlockVertical * 4),
                margin: EdgeInsets.all(Configuration.safeBlockVertical * 2),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.all(Radius.circular(25.0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //  Text('title', style: Configuration.modaltitle),
                    SizedBox(height: Configuration.safeBlockVertical * 3),
                    //Text('subtitle', style: Configuration.modalsubtitle)
                  ],
                ),
              )
            ]);
          }),
      child: ContainerSelect(lefttext: 'Ambient Sound', righttext: Icon(icon)),
    );
  }
}