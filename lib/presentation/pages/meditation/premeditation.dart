import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';

class SetMeditation extends StatefulWidget {
  @override
  _SetMeditationState createState() => _SetMeditationState();
}

class _SetMeditationState extends State<SetMeditation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Configuration.maincolor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: Configuration.iconSize),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Meditate', style: Configuration.title),
          Container(
            height: Configuration.height * 0.08,
            width: Configuration.width,
            padding: EdgeInsets.only(left:Configuration.width * 0.05,right: Configuration.width * 0.05),
            margin: EdgeInsets.all(Configuration.width * 0.05),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Duration',style: Configuration.settings),
                  TimePicker()
                ],

            )
              
            

          ),
          FloatingActionButton(child: Icon(Icons.check,color: Colors.black),backgroundColor: Colors.white, onPressed: null)
        ],
      )),
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
