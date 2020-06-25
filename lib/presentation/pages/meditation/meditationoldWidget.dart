import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/blocs/meditationBloc.dart';
import 'package:meditation_app/interface/commonWidget/bottomMenu.dart';
import 'package:meditation_app/interface/commonWidget/titleWidget.dart';
import 'package:meditation_app/interface/meditation/meditationinprogressWidget.dart';

class MeditationOldWidget extends StatelessWidget {
  final int selectedIndex;

  MeditationWidget(this.selectedIndex);

  @override
  Widget build(BuildContext context) {
    //final _meditationBloc = BlocProvider.of<MeditationBloc>(context);
    return Scaffold(
      body: Column(
        children: <Widget>[
          DescriptionWidget(
              'Meditate with the help of a master \n or step up to the challenge \n and meditate yourself'),
          Expanded(flex: 2, child: ElementsWidget()),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(16),
              child: FloatingActionButton(
                backgroundColor: Colors.redAccent,
                child: Text('Start'),
                elevation: 0,
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MeditationinProgress(//_meditationBloc)
                                ))),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavyBar(selectedIndex),
    );
  }
}

class ElementsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(child: Text('Duration')),
                  TimePicker()
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Row(children: <Widget>[
                Expanded(child: Text('Guided meditation'))
              ]),
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text('Ambient sound'),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
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
  Duration initialtimer;

  @override
  void initState() {
    super.initState();
    hours = 0;
    minutes = 0;
    seconds = 0;
    initialtimer =
        new Duration(hours: hours, minutes: minutes, seconds: seconds);
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
                    initialTimerDuration: initialtimer,
                    onTimerDurationChanged: (Duration changedtimer) {
                      setState(() {
                        initialtimer = changedtimer;
                        hours = changedtimer.inSeconds ~/ 3600;
                        minutes = (changedtimer.inSeconds % 3600) ~/ 60;
                        seconds = (changedtimer.inSeconds % 3600) % 60;
                        //_meditationBloc.setDuration(changedtimer);
                      });
                    });
              }),
        )),
      ],
    );
  }
}
