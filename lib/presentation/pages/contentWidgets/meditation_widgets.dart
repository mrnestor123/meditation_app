import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/meditation_entity.dart';
import '../../mobx/actions/meditation_state.dart';
import '../../mobx/actions/user_state.dart';
import '../commonWidget/alert_dialog.dart';
import '../config/configuration.dart';

class WeekList extends StatefulWidget {
  @override
  _WeekListState createState() => _WeekListState();
}

class _WeekListState extends State<WeekList> {
  UserState _userstate;
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


  List<Widget> getDays() {
    List<Widget> result = new List.empty(growable: true);
    var dayOfWeek = 1;
    DateTime today = DateTime.now();
    var weekday = today.weekday;
    DateTime monday = today.subtract(Duration(days: today.weekday - dayOfWeek));
    var meditationstreak = _userstate.user.userStats.streak;
    List<Meditation> filteredmeditations = _userstate.user.totalMeditations.where((meditation)=>
      meditation.day.isAfter(monday)&&
      meditation.day.isBefore(today)
    ).toList();


     for (var item in weekDays) {
      bool hasMeditated = filteredmeditations.where((meditation)=>
        meditation.day.weekday == item['index']
      ).isNotEmpty;

      result.add(WeekItem(
          day: item['day'],
          meditated: hasMeditated,
          animate: today.weekday == item['index'])
      );
    }


    /*
    if (meditationstreak == 1) {
      weekDays[--weekday]['meditated'] = true;
    } else {
      while (meditationstreak != 0 && (weekday + 1) != monday) {
        weekDays[(monday-1)]['meditated'] = true;
        monday++;
        meditationstreak--;
      }
    }

    for (var e in weekDays) {
      result.add(WeekItem(
          day: e['day'],
          meditated: e['meditated'],
          animate: today.weekday == e['index']));
    }*/
    return result;
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: getDays()
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
    if (widget.animate && !changed) {
      var timer = Timer(Duration(seconds: 1), () => setState(() => changed = true));
    }

    return AnimatedContainer(
      width: Configuration.width * 0.1,
      height: Configuration.width * 0.1,
      duration: Duration(seconds: 3),
      curve: Curves.easeIn,
      decoration: new BoxDecoration(
        color: widget.meditated && !widget.animate || widget.animate && changed
            ? Configuration.maincolor
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

class CirclePicker extends StatefulWidget {
  const CirclePicker() : super();

  @override
  _CirclePickerState createState() => _CirclePickerState();
}

class _CirclePickerState extends State<CirclePicker> {
  @override
  Widget build(BuildContext context) {
    final _meditationstate = Provider.of<MeditationState>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SingleCircularSlider(
          95,
          _meditationstate.selmeditation.duration.inMinutes,
          baseColor: Colors.grey.withOpacity(0.6),
          handlerColor: Colors.transparent,
          handlerOutterRadius: 10,
          onSelectionChange: (a, b, c) {
            setState(() { _meditationstate.setDuration(b);});
          },
          height: Configuration.width > 600 ? Configuration.width*0.7 : Configuration.width*0.9,
          width: Configuration.width > 600 ? Configuration.width*0.7: Configuration.width*0.9,
          selectionColor: Colors.lightBlue,
          sliderStrokeWidth: Configuration.width > 600 ? 80:  40,
          child: Center(
            child: Text(
            _meditationstate.selmeditation.duration.inMinutes.toString() + ' min',
            style: Configuration.text('smallmedium', Colors.black),
          )),
        ),
      ],
    );
  }
}


Widget secondaryButton(IconData icon, onPressed, tag){
    return FloatingActionButton(mini: true,
    heroTag: tag,
      backgroundColor: Colors.black.withOpacity(0.7),
      onPressed: ()=>{
        onPressed()
      },
      child: Icon(icon,color: Colors.white,size: Configuration.smicon)
    );
  }


void wantToExitDialog(context){
  showAlertDialog(
    context:context,
    title: 'Are you sure you want to exit?',
    text: 'This meditation will not count',
    onYes:(){
      //_meditationstate.cancel();
    },
    onNo:(){
      /*if(_meditationstate.state == _meditationstate.meditating || _meditationstate.state == _meditationstate.paused){
        _meditationstate.startTimer();
      }*/
    }
  );
}