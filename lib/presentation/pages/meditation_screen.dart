import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/meditation_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:provider/provider.dart';

import 'commonWidget/progress_dialog.dart';
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
  int _index;

  //podriamos utilizar meditationstate de arriba
  var meditationtype = 'free';
  var selectedstage = 1;
  var selectedtype = 'Meditation';
  var finished = false;

  Widget initialPage(context) { 
    Widget freeMeditation() {
      return Column(
        children: [
          TimePicker(),
          SizedBox(height: Configuration.height * 0.1),
          StartButton(
            onPressed: () => {
              _meditationstate.setMeditation(MeditationModel(duration: Duration(minutes: seltime), type:"free") , _userstate.user, _userstate.data),
              Navigator.pushNamed(context, '/countdown').then((value) => setState(()=>{
              })),
            },
          ),
        ],
      );
    }

    Widget guidedMeditation() {
      List<Widget> meditations() {
        List<Widget> meditations = new List.empty(growable:true);
        for (var meditation in _userstate.data.stages[selectedstage - 1].meditpath) {
          var _blocked = _userstate.user.meditposition < meditation.position && _userstate.user.stagenumber == meditation.stagenumber || _userstate.user.stagenumber < meditation.stagenumber;
          meditations.add(GestureDetector(
              onTap: () => !_blocked ? setState(() => _meditationstate.selmeditation = meditation) : null,
              child: Container(
                decoration: BoxDecoration(
                  border: _meditationstate.selmeditation != null && _meditationstate.selmeditation.cod == meditation.cod ? 
                  Border.all(color: Configuration.maincolor) : null),
                child: Stack(
                  children: [
                    Column(children: [
                      Container(
                        width: Configuration.width* 0.2,
                        height:Configuration.width* 0.2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          image: DecorationImage(
                              image: NetworkImage(meditation.image)))),
                      Text(
                        meditation.title,
                        style: Configuration.text('small', _blocked ? Colors.grey : Colors.black),
                        textAlign: TextAlign.center,
                      )
                    ])
                  ],
                ),
              )
              )
            );
        }

        return meditations;
      }

      Widget stages() {
        var stages = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
        var types = ['Meditation', 'Game'];

        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(children: [
                Text(
                  'Stage',
                  style: Configuration.text('small', Colors.black),
                ),
                SizedBox(width: Configuration.blockSizeVertical * 1),
                DropdownButton<int>(
                    value: selectedstage,
                    elevation: 16,
                    style: TextStyle(color: Colors.black),
                    underline: Container(
                      height: 0,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (int newValue) {
                      setState(() {
                        selectedstage = newValue;
                      });
                    },
                    items: stages.map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList())
              ]),
              Row(children: [
                Text(
                  'Type',
                  style: Configuration.text('small', Colors.black),
                ),
                SizedBox(width: Configuration.blockSizeVertical * 1),
                DropdownButton<String>(
                    value: selectedtype,
                    elevation: 16,
                    style: TextStyle(color: Colors.black),
                    underline: Container(
                      height: 0,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        selectedtype = newValue;
                      });
                    },
                    items: types.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList())
              ]),
            ]);
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: Configuration.height * 0.45,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0)),
              margin: EdgeInsets.all(Configuration.bigmargin),
              child: Column(children: [
                Container(
                  height: Configuration.height * 0.05,
                  child: stages(),
                ),
                Container(
                  height: Configuration.height * 0.4,
                  child: GridView(
                      padding: EdgeInsets.all(Configuration.medpadding),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      children: meditations()),
                )
              ])),
              StartButton(
                onPressed: () => {
                  _meditationstate.state ='pre_guided', 
                  Navigator.pushNamed(context, '/countdown').then(
                    (value) => setState(()=>{
                      _userstate.user.progress != null ? 
                      autocloseDialog(context, _userstate.user.progress) : null
                    })), 
                },
              )
        ],
      );
    }

    return ListView(children: [
      SizedBox(height: Configuration.height * 0.05),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Flexible(
          child: AspectRatio(
            aspectRatio: 7/4,
            child: Container(
              margin: EdgeInsets.all(Configuration.bigmargin),
              child: ElevatedButton(
              onPressed: () => {setState(() => meditationtype = 'free')},
              style: ElevatedButton.styleFrom(
                primary:  meditationtype == 'free' ? Configuration.maincolor : Colors.white,
              ),
              child: Center(
                  child: Text('Free',
                      style: Configuration.text(
                          'smallmedium',
                          meditationtype == 'guided'
                              ? Colors.black
                              : Colors.white)))
                  ),
            ),
          ),
        ),
        Flexible(
              child: AspectRatio(
                aspectRatio: 7/4,
                child: Container(
                  margin: EdgeInsets.all(Configuration.bigmargin),
                  child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary:  meditationtype == 'guided' ? Configuration.maincolor : Colors.white,
                  ),
                  onPressed: () => {setState(() => meditationtype = 'guided')},
                  child: Center(
                      child: Text('Guided',
                          style: Configuration.text(
                              'smallmedium',
                              meditationtype == 'free'
                                  ? Colors.black
                                  : Colors.white)))),
                ),
              ),
        )
      ]),
      SizedBox(height: Configuration.height * 0.05),
      Expanded(
          child: meditationtype == 'guided'
              ? guidedMeditation()
              : freeMeditation())
    ]);
  }

  @override
  Widget build(BuildContext context) {
    _meditationstate = Provider.of<MeditationState>(context);
    _userstate = Provider.of<UserState>(context);
    return Container(
          height: Configuration.height,
          color: Configuration.lightgrey,
          width: Configuration.width,
          child:Stack(children:[ 
            initialPage(context),
          ])
    );
  }
}

class Countdown extends StatefulWidget {
  const Countdown({
    Key key
  }) :  super(key: key);

  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  var started = false;
  MeditationState _meditationstate;
  UserState _userstate;
  int _index;

  //podriamos utilizar meditationstate de arriba
  var meditationtype = 'free';
  var selectedstage = 1;
  var selectedtype = 'Meditation';
  var finished = false;

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
              WeekList(),
              SizedBox(height: Configuration.height * 0.05),
              Text('Total meditations: ' +
                      (_userstate.user.totalMeditations.length).toString(),
                  style: Configuration.text('medium', Colors.black))
            ],
          ),
        )
      ],
    );
  }

  Widget guided(context) {
    List<Widget> getBalls() {
      List<Widget> res = new List.empty(growable: true);
      _meditationstate.selmeditation.content.forEach((key, value) {
        int index = int.parse(key);
        res.add(Container(
          width: Configuration.safeBlockHorizontal * 3,
          height: Configuration.safeBlockHorizontal * 3,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _index == index
                ? Color.fromRGBO(0, 0, 0, 0.9)
                : Color.fromRGBO(0, 0, 0, 0.4),
          ),
        ));
      });
      return res;
    }

    List<Widget> getContent(index) {
      List<Widget> l = new List.empty(growable: true);

      if (_meditationstate.selmeditation.content[index.toString()]['title'] != null) {
        l.add(Text(_meditationstate.selmeditation.content[index.toString()]['title'],
            style: Configuration.text('medium', Colors.black)));
      }

      if (_meditationstate.selmeditation.content[index.toString()]['image'] != null) {
        l.add(Image(
            image: NetworkImage(
                _meditationstate.selmeditation.content[index.toString()]['image'])));
      }

      if (_meditationstate.selmeditation.content[index.toString()]['text'] != null) {
        l.add(Text(_meditationstate.selmeditation.content[index.toString()]['text'],
            style: Configuration.text('tiny', Colors.white,font:'Helvetica')));
      }

      if (finished) {
        l.add(SizedBox(height: Configuration.height * 0.02));
        l.add(ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Configuration.maincolor,
            padding: EdgeInsets.all(Configuration.medpadding),
            shape: CircleBorder(),
            animationDuration: Duration(milliseconds: 500)
          ),
          onPressed: ()=> {_meditationstate.setMeditation(_meditationstate.selmeditation, _userstate.user, _userstate.data)} ,
          child: Text(
            'Start',
            style: Configuration.text('medium', Colors.white),
          ),
        ));
      }

      return l;
    }

    return Stack(children: [
      CarouselSlider.builder(
          itemCount: _meditationstate.selmeditation.content.entries.length,
          itemBuilder: (context, index) {
            return Container(
                width: Configuration.width,
                height: Configuration.height,
                padding: EdgeInsets.all(Configuration.medpadding),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: getContent(index)));
          },
          options: CarouselOptions(
              height: Configuration.height,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: false,
              reverse: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _index = index;
                  if (_index == _meditationstate.selmeditation.content.entries.length - 1) {
                    finished = true;
                  }
                });
              })),
      Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: getBalls(),
        ),
      ),
    ]);
  }

  Widget countdown(context){
    return Stack(
        children: [
        Align(
          alignment: Alignment.center,
          child: _meditationstate.selmeditation.type != 'free' ? 
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: Configuration.height*0.35,
                width: Configuration.height*0.35,
                child: Image(image: NetworkImage(_meditationstate.selmeditation.image),fit: BoxFit.cover),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
              ),
              SizedBox(height: Configuration.blockSizeVertical*3),
              Text(_meditationstate.selmeditation.title,style: Configuration.text('small',Colors.white))
            ],
          ):  Container(
            height: Configuration.blockSizeHorizontal * 60,
            width: Configuration.blockSizeHorizontal * 60,
            decoration: BoxDecoration(color: Configuration.grey, borderRadius: BorderRadius.circular(12.0)),
            child: Center(child: Text('free meditation', style:Configuration.text('smallmedium', Colors.white))),
          ),
        ),
        /*SizedBox(height: Configuration.height *0.05),
        Observer(builder: (BuildContext context) {
          if (_meditationstate.duration != null) {
            return Text(
                _meditationstate.duration.inHours > 0
                    ? _meditationstate.duration.toString().substring(0, 7)
                    : _meditationstate.duration.toString().substring(2, 7),
                style: Configuration.text('huge', Colors.black));
          }
        }),*/
        SizedBox(height: Configuration.blockSizeHorizontal * 5),
        Positioned(
          bottom: 50,
          right:10,
          left:10,
          child: Column(children: [
            Slider(
              activeColor: Configuration.maincolor,
              inactiveColor: Colors.white,
              min: 0.0,
              max: _meditationstate.selmeditation.duration.inMinutes.toDouble(),
              onChanged: (a)=> null, 
              value:_meditationstate.totalduration.inSeconds/60 - _meditationstate.duration.inSeconds/60 ,
              label:  _meditationstate.duration.inHours > 0
                    ? _meditationstate.duration.toString().substring(0, 7)
                    : _meditationstate.duration.toString().substring(2, 7)
            ),
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

  @override
  Widget build(BuildContext context) {
    _meditationstate = Provider.of<MeditationState>(context);
    _userstate = Provider.of<UserState>(context);

    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.close),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration:  BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color.fromRGBO(23,23,23,100),
                Configuration.maincolor,
              ],
            )
          ),
        child: Observer(
              builder: (BuildContext context) {
                if (_meditationstate.state == 'pre_guided') {
                  return guided(context);
                } else if (_meditationstate.state == 'started' || _meditationstate.state == 'paused') {
                  return countdown(context);
                } else {
                  return finish(context);
                }
              }
            ),
      )
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
      baseColor: Colors.grey.withOpacity(0.6),
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
        style: Configuration.text('smallmedium', Colors.black),
      )),
    );
  }
}

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
    var monday = today.subtract(Duration(days: today.weekday - dayOfWeek)).weekday;
    var meditationstreak = _userstate.user.userStats.streak;

   //List<Meditation> meditations = _userstate.user.totalMeditations;


  /*    while(monday != today){
      if(_userstate.user.stats['meditationtime'][monday.day.toString() + '-' + monday.month.toString()]){
        weekDays
      }



    }*/

    print(meditationstreak);
  
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
