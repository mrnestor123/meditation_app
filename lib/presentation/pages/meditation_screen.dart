import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/game_state.dart';
import 'package:meditation_app/presentation/mobx/actions/meditation_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:numberpicker/numberpicker.dart';
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
  GameState _gamestate;
  int _index;

  //podriamos utilizar meditationstate de arriba
  var meditationtype = 'free';
  var selectedstage = 1;
  var selectedtype = 'Meditation';
  var finished = false;

  bool canStart = false;


  Widget freeMeditation() {
    return layout( 
      TimePicker(), 
    () {
        _meditationstate.setMeditation(MeditationModel(duration: Duration(minutes: seltime), type:"free") , _userstate.user, _userstate.data);
        Navigator.pushNamed(context, '/countdown').then((value) => setState(()=>{
          _userstate.user.progress != null ? autocloseDialog(context, _userstate.user) : null }));
    }, true);
  }

  Widget guidedMeditation() {
    List<int> stages = [1,2,3,4,5,6,7,8,9,10];

    List<Widget> meditations() {
      List<Widget> meditations = new List.empty(growable:true);
      for (var meditation in _userstate.data.stages[selectedstage - 1].meditpath) {
        //estascondiciones podria ponerlas en el dominio _userstate.user.canMeditate(x)
        var _blocked = _userstate.user.meditposition < meditation.position && _userstate.user.stagenumber == meditation.stagenumber || _userstate.user.stagenumber < meditation.stagenumber;
        meditations.add(GestureDetector(
            onTap: () => !_blocked ? setState(() => _meditationstate.selmeditation = meditation) : null,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: _meditationstate.selmeditation != null && _meditationstate.selmeditation.cod == meditation.cod ? Colors.grey.withOpacity(0.1) : Colors.transparent,
              ),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Container(
                    height:_meditationstate.selmeditation != null && _meditationstate.selmeditation.cod == meditation.cod ? Configuration.width*0.2: Configuration.width * 0.15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      image: DecorationImage(
                          image: NetworkImage(meditation.image)))),
                  Flexible(
                      child: Text(
                      meditation.title,
                      style: Configuration.text('tiny', _blocked ? Colors.grey : Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10)
                ]),
              )
            )
          );
      }

      return meditations;
    }

    return layout(
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('Stage',
          style: Configuration.text('small', Colors.black),
        ),
        SizedBox(width: Configuration.blockSizeVertical * 1),
        Container(
          width: Configuration.width,
          child: GridView.builder(
            itemCount: 10,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, crossAxisSpacing: 5.0, mainAxisSpacing: 30.0),
            itemBuilder: (context,index) {
              return Text(stages[index].toString(), style: Configuration.text('tiny',Colors.black));
            }          
          ),
        ),
        GridView(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 30.0),
            children: meditations())
        ]
      ), 
      () => {
                _meditationstate.state ='pre_guided', 
                Navigator.pushNamed(context, '/countdown').then(
                  (value) => setState(()=>{
                    _userstate.user.progress != null ? 
                    autocloseDialog(context, _userstate.user) : null
                  })), 
      }, _meditationstate.selmeditation != null);
  }

  Widget games() {
    Widget gamelist(){
      return GridView.builder(
        shrinkWrap: true,
        itemCount: _userstate.data.stages[0].games.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200), 
        itemBuilder: (context,index) {
          var game = _userstate.data.stages[0].games[index];
          return GestureDetector(
            onTap: ()=> setState(()=> _gamestate.selectgame(game)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color:  _gamestate.selectedgame != null && _gamestate.selectedgame.cod == game.cod  ? Colors.grey.withOpacity(0.1) : Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 5),
                  Container(
                    height: _gamestate.selectedgame != null && _gamestate.selectedgame.cod == game.cod ? Configuration.height*0.17 :Configuration.height*0.15,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(game.image)),
                    ),
                   child: Stack(
                     children: [
                       _gamestate.selectedgame != null && _gamestate.selectedgame.cod == game.cod ?
                       Positioned(
                         top: -5,
                         right: 25,
                         child:
                         Chip(
                           side: BorderSide.none,
                           label: Text( 
                             (_userstate.user.answeredGame(game.cod) ? _userstate.user.answeredquestions.length.toString(): '0' )
                             + '/' + game.questions.length.toString(), 
                              style: Configuration.text('mini', Colors.white)
                            )
                          )
                       ) : Container(),
                     ],
                   ),
                  ),
                  SizedBox(height: 10),
                  Text(game.title, style: Configuration.text('small',Colors.black),)
                ]
              ),
            ),
          );
        });
    }

    return layout(
      Container(
        width: Configuration.width > 500 ? Configuration.width*0.45 : Configuration.width,
        height: Configuration.height,
        child: gamelist(),
      ), 
      () {
         _gamestate.startgame();
        Navigator.pushNamed(context,'/gamestarted');
      },
      _gamestate.selectedgame != null 
    );
  }

  Widget layout(child, onPressed, condition){
    return Stack(
      children: [
        Align(
          alignment: Configuration.width > 500 ? Alignment.centerRight : Alignment.bottomCenter,
          child: StartButton(
            onPressed:condition ? ()=> onPressed() : null,
          ),
        ),
        Align(
          alignment: Configuration.width > 500 ? Alignment.topLeft : Alignment.topCenter,
          child: child,
        )
      ],
    );

  }

  @override 
  void initState(){
    super.initState();
  }

  @override 
  void didChangeDependencies(){
    super.didChangeDependencies();
    _userstate = Provider.of<UserState>(context);
    _meditationstate = Provider.of<MeditationState>(context);
    _meditationstate.practice = PageController(initialPage: _meditationstate.currentpage);
    selectedstage = _userstate.user.stagenumber;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _gamestate = Provider.of<GameState>(context);

    return PageView(
      controller: _meditationstate.practice,
      onPageChanged: (newPage) {
        setState(() {
          _meditationstate.switchpage(newPage);
        });
      },
      children: [freeMeditation(), guidedMeditation(), games()],
    );
  }
}

//VISTA DE MEDITACIÓN
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
            image: NetworkImage( _meditationstate.selmeditation.content[index.toString()]['image'])));
      }

      if (_meditationstate.selmeditation.content[index.toString()]['text'] != null) {
        l.add(Text(_meditationstate.selmeditation.content[index.toString()]['text'],
            style: Configuration.text('small', Colors.white,font:'Helvetica')));
      }

      if (finished) {
        l.add(SizedBox(height: Configuration.height * 0.02));
        l.add(StartButton(
          onPressed: () {
            // esto hace falta hacerlo ???
            _meditationstate.setMeditation(_meditationstate.selmeditation, _userstate.user, _userstate.data);
          },
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: 
               _meditationstate.currentsentence != null ? [
                  Text(_meditationstate.currentsentence, style: Configuration.text('small', Colors.white), textAlign: TextAlign.center)
               ]: [
                  Container(
                    height: Configuration.height*0.35,
                    width: Configuration.height*0.35,
                    child: Image(image: NetworkImage(_meditationstate.selmeditation.image),fit: BoxFit.cover),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                  ),
                SizedBox(height: Configuration.blockSizeVertical*3),
                Text(_meditationstate.selmeditation.title,style: Configuration.text('small',Colors.white))
            ],
          ) :  
          Container(
            height: Configuration.blockSizeHorizontal * 60,
            width: Configuration.blockSizeHorizontal * 60,
            decoration: BoxDecoration(color: Configuration.grey, borderRadius: BorderRadius.circular(12.0)),
            child: Center(child: Text('free meditation', style:Configuration.text('smallmedium', Colors.white))),
          ),
        ),
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
              _meditationstate.pause();
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

  TimePicker();

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
      height: Configuration.width > 600 ? 200 : Configuration.height*0.2,
      width: Configuration.width > 600 ? 200 : 200,
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

// VISTA DE TABLETS !!!!
/*
class TabletMeditationScreen extends StatefulWidget {
  @override
  _TabletMeditationScreenState createState() => _TabletMeditationScreenState();
}

class _TabletMeditationScreenState extends State<TabletMeditationScreen> {
  UserState _userstate;
  MeditationState _meditationstate;
  GameState _gamestate;

  int _index;

  //podriamos utilizar meditationstate de arriba
  var meditationtype = 'free';
  var selectedstage = 1;
  var selectedtype = 'Meditation';
  var finished = false;

  Widget freeMeditation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TimePicker(),
        SizedBox(height: Configuration.height * 0.1),
        TabletStartButton(
          onPressed: () => {
            _meditationstate.setMeditation(MeditationModel(duration: Duration(minutes: seltime), type:"free") , _userstate.user, _userstate.data),
            Navigator.pushNamed(context, '/tabletcountdown').then((value) => setState(()=>{
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
              child: Column(children: [
                Container(
                  width: Configuration.width* 0.06,
                  height:Configuration.width* 0.06,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    image: DecorationImage(
                        image: NetworkImage(meditation.image)))),
                Text(
                  meditation.title,
                  style: Configuration.tabletText('mini', _blocked ? Colors.grey : Colors.black),
                  textAlign: TextAlign.center,
                )
              ]),
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
              Text('Stage',
                style: Configuration.tabletText('verytiny', Colors.black),
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
                style: Configuration.tabletText('verytiny', Colors.black),
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
            width: Configuration.height*0.45,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0)),
            child: Column(children: [
              Container(
                height: Configuration.height * 0.05,
                child: stages(),
              ),
              Expanded(
                child: GridView(
                    padding: EdgeInsets.all(12.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    children: meditations()),
              )
            ])
        ),
        SizedBox(height: 20),
        TabletStartButton(
          onPressed: () => {
            _meditationstate.state ='pre_guided', 
            Navigator.pushNamed(context, '/tabletcountdown').then(
              (value) => setState(()=>{
                _userstate.user.progress != null ? 
                autocloseDialog(context, _userstate.user, isTablet: true) : null
              })), 
          },
        )
      ],
    );
  }

  Widget games() {
    List<Widget> gamelist(){
        List<Widget> g = new List.empty(growable: true);
        for(var element in _userstate.data.stages[0].games){
          g.add(
            Column(
              children: [
                GestureDetector(
                    onTap: ()=> setState(()=> _gamestate.selectgame(element)),
                    child: Container(
                    decoration: BoxDecoration(border: _gamestate.selectedgame != null && _gamestate.selectedgame.cod == element.cod ? Border.all(color: Configuration.maincolor): Border()),
                    width: Configuration.width*0.12,
                    child: AspectRatio(
                      aspectRatio: 1/1,
                      child: Container( 
                        margin: EdgeInsets.all(Configuration.tinpadding),
                        decoration: BoxDecoration(color: Colors.grey))),
                  ),
                ),
                Text(element.title, style: Configuration.tabletText('tiny',Colors.black),)
              ],
            )
        );

      return g;
      }
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: Configuration.height * 0.4,
            child: Column(
              children: gamelist(),
              ), 
          ),
          TabletStartButton(
            onPressed: () { 
              _gamestate.startgame();
              Navigator.pushNamed(context,'/gamestarted');
            },
          )
      ]),
    );
  }

  Widget chiporText(String text, bool chip){
      Widget g;

      var types = {'Guided':'guided','Free':'free','Games':'games'};

      if (chip){
        g = Chip(padding: EdgeInsets.all(12), label: Text(text, style: Configuration.tabletText('tiny', Colors.black)));
      } else {
        g = Text(text, style: Configuration.tabletText('tiny', Colors.black));
      }

      return GestureDetector(
        onTap: () {
          setState(() {
            _meditationstate.switchtype(types[text]);
          });
        },
        child: Container(padding: EdgeInsets.all(14.0), child: g)
      );
    }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    _meditationstate = Provider.of<MeditationState>(context);
    _gamestate = Provider.of<GameState>(context);
    _userstate = Provider.of<UserState>(context);

    return Column(
     children: [
      SizedBox(height: Configuration.height*0.1),
      Container(
          child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Observer(builder: (BuildContext context) {  
              return chiporText('Free', _meditationstate.currentpage == 0);
            }),
            
            Observer(builder: (BuildContext context) {  
              return chiporText('Guided', _meditationstate.currentpage == 1);
            }),
            
            Observer(builder: (BuildContext context) {  
              return chiporText('Games', _meditationstate.currentpage == 2);
            })
          ]
        ),
      ),
      SizedBox(height: Configuration.height*0.05),
      Container(
        height: Configuration.height*0.6,
        child:PageView(
          controller: _meditationstate.practice,
          onPageChanged: (newPage) {
            setState(() {
              _meditationstate.switchpage(newPage);
            });
          },
            children: [freeMeditation(), guidedMeditation(),games()],
          ) 
        )
      ]
    );
  }
}

class TabletCountdown extends StatefulWidget {
  TabletCountdown({
    Key key
  }) :  super(key: key);

  @override
  _TabletCountdownState createState() => _TabletCountdownState();
}

class _TabletCountdownState extends State<TabletCountdown> {
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
              Text('Total meditations: ' + (_userstate.user.totalMeditations.length).toString(),
                style: Configuration.tabletText('tiny', Colors.black))
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
          width: Configuration.safeBlockHorizontal * 2,
          height: Configuration.safeBlockHorizontal * 2,
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

    Widget getContent(slide) {

      return Container(
        padding: EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            slide['title'] != null ? Text(slide['title'],style: Configuration.tabletText('small', Colors.black, font: 'Helvetica')) : Container(),
            slide['image'] != null ? Image(image: NetworkImage(slide['image'])) : Container(),
            slide['text'] != null ?  Text(slide['text'], style: Configuration.tabletText('tiny', Colors.white,font:'Helvetica')) : Container(),
            SizedBox(height: Configuration.height*0.02),
            AnimatedOpacity(
            duration: Duration(seconds: 5),
            opacity: finished ? 1 : 0,
            child: TabletStartButton(
              onPressed: ()=> {_meditationstate.setMeditation(_meditationstate.selmeditation, _userstate.user, _userstate.data)},
              ),
            )
        ]),
      );
    }

    return Stack(children: [
      CarouselSlider.builder(
          itemCount: _meditationstate.selmeditation.content.entries.length,
          itemBuilder: (context, index) {
            return getContent(_meditationstate.selmeditation.content[index.toString()]);
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
              })
      ),
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
                height: Configuration.height*0.1,
                width: Configuration.height*0.1,
                child: Image(image: NetworkImage(_meditationstate.selmeditation.image),fit: BoxFit.cover),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
              ),
              SizedBox(height: Configuration.blockSizeVertical*3),
              Text(_meditationstate.selmeditation.title,style: Configuration.tabletText('tiny',Colors.white))
            ],
          ) :    
          Container(
            height: Configuration.blockSizeHorizontal * 30,
            width: Configuration.blockSizeHorizontal * 30,
            decoration: BoxDecoration(color: Configuration.grey, borderRadius: BorderRadius.circular(12.0)),
            child: Center(child: Text('free meditation', style:Configuration.tabletText('tiny', Colors.white))),
          ),
        ),
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
              _meditationstate.pause();
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









*/

