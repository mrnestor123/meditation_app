import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
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
  int _index;

  //podriamos utilizar meditationstate de arriba
  var meditationtype = 'free';
  Meditation selectedmeditation;
  var selectedstage = 1;
  var selectedtype = 'Meditation';
  var finished = false;

  Widget initialPage(context) {
    Widget freeMeditation() {
      return Column(
        children: [
          TimePicker(),
          SizedBox(height: Configuration.height * 0.1),
          GestureDetector(
            onTap: () {
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
        _userstate.data.stages[selectedstage - 1].meditpath
            .forEach((key, list) {
          for (var meditation in list) {
            meditations.add(GestureDetector(
                onTap: () => setState(() => selectedmeditation = meditation),
                child: Column(children: [
                  Container(
                      height: Configuration.height * 0.1,
                      width: Configuration.height * 0.1,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          border: selectedmeditation != null &&
                                  selectedmeditation.cod == meditation.cod
                              ? Border.all(color: Configuration.maincolor)
                              : null,
                          image: DecorationImage(
                              image: NetworkImage(meditation.image)))),
                  Text(
                    meditation.title,
                    style: Configuration.text('small', Colors.black),
                    textAlign: TextAlign.center,
                  )
                ])));
          }
        });

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
                    style: TextStyle(color: Colors.deepPurple),
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
                    style: TextStyle(color: Colors.deepPurple),
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

      return SingleChildScrollView(
        child: Column(
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
            GestureDetector(
              onTap: () => {_meditationstate.state = 'pre_guided'},
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
            ),
          ],
        ),
      );
    }

    return Column(children: [
      Container(
          width: Configuration.width,
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                blurRadius: 0.5,
                offset: Offset(0, 1),
                spreadRadius: 0.5,
                color: Colors.black.withOpacity(0.2))
          ]),
          padding: EdgeInsets.all(Configuration.smpadding),
          child: Column(children: [
            SizedBox(height: Configuration.height * 0.04),
            Text(
              '''Choose the\n meditation ''',
              style: Configuration.text('medium', Colors.black),
              textAlign: TextAlign.center,
            )
          ])),
      SizedBox(height: Configuration.height * 0.05),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        GestureDetector(
            onTap: () => {setState(() => meditationtype = 'free')},
            child: Container(
              width: Configuration.width * 0.3,
              height: Configuration.height * 0.1,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: meditationtype == 'guided'
                      ? Colors.white
                      : Configuration.maincolor),
              child: Center(
                  child: Text('Free',
                      style: Configuration.text(
                          'medium',
                          meditationtype == 'guided'
                              ? Colors.black
                              : Colors.white))),
            )),
        GestureDetector(
            onTap: () => {setState(() => meditationtype = 'guided')},
            child: Container(
              width: Configuration.width * 0.3,
              height: Configuration.height * 0.1,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: meditationtype == 'guided'
                      ? Configuration.maincolor
                      : Colors.white),
              child: Center(
                  child: Text('Guided',
                      style: Configuration.text(
                          'medium',
                          meditationtype == 'free'
                              ? Colors.black
                              : Colors.white))),
            ))
      ]),
      SizedBox(height: Configuration.height * 0.05),
      Expanded(
          child: meditationtype == 'guided'
              ? guidedMeditation()
              : freeMeditation())
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

  Widget guided(context) {
    List<Widget> getBalls() {
      List<Widget> res = new List();
      selectedmeditation.content.forEach((key, value) {
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
      List<Widget> l = new List();

      if (selectedmeditation.content[index.toString()]['title'] != null) {
        l.add(Text(selectedmeditation.content[index.toString()]['title'],
            style: Configuration.text('medium', Colors.black)));
      }

      if (selectedmeditation.content[index.toString()]['image'] != null) {
        l.add(Image(
            image: NetworkImage(
                selectedmeditation.content[index.toString()]['image'])));
      }

      if (selectedmeditation.content[index.toString()]['text'] != null) {
        l.add(Text(selectedmeditation.content[index.toString()]['text'],
            style: Configuration.text('small', Colors.black)));
      }

      if (finished) {
        l.add(SizedBox(height: Configuration.height * 0.03));
        l.add(GestureDetector(
          onTap: ()=> {_meditationstate.startMeditation(selectedmeditation.duration, _userstate.user, _userstate.data)} ,
          child: Container(
            child: Text(
              'Start',
              style: Configuration.text('medium', Colors.white),
            ),
            padding: EdgeInsets.all(Configuration.medpadding),
            height: Configuration.height * 0.1,
            decoration: BoxDecoration(
                color: Configuration.maincolor,
                borderRadius: BorderRadius.circular(14)),
          ),
        ));
      }

      return l;
    }

    return Stack(children: [
      CarouselSlider.builder(
          itemCount: selectedmeditation.content.entries.length,
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
                  if (_index == selectedmeditation.content.entries.length - 1) {
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

  @override
  Widget build(BuildContext context) {
    _meditationstate = Provider.of<MeditationState>(context);
    _userstate = Provider.of<UserState>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _meditationstate.state == 'initial'
            ? IconButton(
                icon: Icon(Icons.arrow_back_sharp),
                color: Colors.black,
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : IconButton(
                icon: Icon(Icons.close),
                color: Colors.black,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
          height: Configuration.height,
          color: Configuration.lightgrey,
          width: Configuration.width,
          child: Observer(
            builder: (BuildContext context) {
              if (_meditationstate.state == 'initial') {
                return initialPage(context);
              }
              if (_meditationstate.state == 'pre_guided') {
                return guided(context);
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
