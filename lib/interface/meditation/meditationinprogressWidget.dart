import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/blocs/meditationBloc.dart';

class MeditationinProgress extends StatelessWidget {
  final MeditationBloc _meditationBloc;

  MeditationinProgress(this._meditationBloc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: CountDownWidget(duration: _meditationBloc.getDuration()));
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

  @override
  void initState() {
    super.initState();
    icon = Icons.pause;
    _duration = widget.duration;
    _started = true;
    startTimer();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
        oneSec,
        (Timer timer) => setState(
              () => _duration.inSeconds < 1
                  ? timer.cancel()
                  : _duration = _duration - oneSec,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
            child: Container(
                margin: EdgeInsets.all(16),
                alignment: Alignment.bottomCenter,
                child: Text(
                  _duration.toString().substring(0, 7),
                  style: TextStyle(fontSize: 22),
                ))),
        Expanded(
            child: Container(
          margin: EdgeInsets.all(16),
          alignment: Alignment.topCenter,
          child: FloatingActionButton(
              child: new Icon(icon),
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
