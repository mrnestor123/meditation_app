import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/game_state.dart';
import 'package:meditation_app/presentation/mobx/actions/meditation_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:provider/provider.dart';

import 'commonWidget/progress_dialog.dart';
import 'config/configuration.dart';


class MeditationScreen extends StatefulWidget {
  @override
  _MeditationScreenState createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  UserState _userstate;
  MeditationState _meditationstate;
  GameState _gamestate;
  int seltime = 5;  

  //podriamos utilizar meditationstate de arriba
  var meditationtype = 'free';
  var selectedstage = 1;
  var selectedtype = 'Meditation';
  var finished = false;
  bool canStart = false;

  Widget buttonModal(child, text, selected){
    return AspectRatio(
      aspectRatio: 10/2,
      child: ElevatedButton(
        style: OutlinedButton.styleFrom(
          primary: Configuration.maincolor,
          backgroundColor: Colors.white,
          elevation: 1.5,
          side: BorderSide.none
        ),
        onPressed: ()=>{
          showModalBottomSheet(
            barrierColor: Colors.black.withOpacity(0.5),
             shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            isScrollControlled:true,
            context: context, 
            builder: (context){
              return Container(
                padding: EdgeInsets.all(12),
                child: child
              );
            }).then((value) => 
              setState((){})            
            )
        }, 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style:Configuration.text('small', Colors.black)),
            selected
          ],
        )
      ),
    );

  }

  Widget guidedMeditation() {
    return layout(
      Column(
      children: [
        SizedBox(height: 20),
        buttonModal(
          CirclePicker(),
          'Duration', 
          Observer(
              builder: (context) {
                return Text(_meditationstate.duration.inMinutes.toString() + ' min ', style: Configuration.text('small', Colors.black));
              }
            )
        ),
        SizedBox(height: 25),
        buttonModal(
          MeditationList(), 
          'Guided Meditations', 
          Observer(
              builder: (context) {
                if(_meditationstate.selmeditation != null){
                  return Image(image: NetworkImage(_meditationstate.selmeditation.image), fit: BoxFit.cover);
                }else{
                  return Text('Press to select one',style: Configuration.text('small',Configuration.maincolor));
                }
              }
            )
          )
      ]), 
      () => {
        Navigator.pushNamed(context, '/countdown').then(
          (value) => setState(()=>{
            _userstate.user.progress != null ? autocloseDialog(context, _userstate.user) : null
          })
        ), 
      }, _meditationstate.duration.inMinutes > 0,
            'Set the timer for a guided or a free meditation' 
      );
  }

  Widget games() {
    Widget gamelist(){
      return GridView.builder(
        shrinkWrap: true,
        itemCount: _userstate.data.stages[0].games.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200), 
        itemBuilder: (context,index) {
          var game = _userstate.data.stages[0].games[index];
          var _blocked = _userstate.user.isGameBlocked(game);
          var gamebefore = _userstate.data.stages[0].games[game.position == 0 ? 0 : game.position-1];

          return GestureDetector(
            onTap: ()=> setState((){
              if(!_blocked){
                _gamestate.selectgame(game);
              }
            }),
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
                    width: Configuration.width*0.35,
                    height: _gamestate.selectedgame != null && _gamestate.selectedgame.cod == game.cod ?  
                    Configuration.width*0.3: Configuration.width * 0.26,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(game.image)),
                    ),
                   child:
                    _blocked ? 
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.7)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.lock),
                          Text('Complete ' +  gamebefore.title , style: Configuration.text('verytiny', Colors.black), textAlign: TextAlign.center,)
                        ],
                      ),
                    )  :
                    Stack(
                     children: [
                       _gamestate.selectedgame != null && _gamestate.selectedgame.cod == game.cod ?
                       Positioned(
                         top: -5,
                         right: 25,
                         child:
                         Chip(
                           side: BorderSide.none,
                           label: Text( 
                             (_userstate.user.answeredGame(game.cod) ? _userstate.user.answeredquestions[game.cod].toString(): '0' )
                             + '/' + game.questions.length.toString(), 
                              style: Configuration.text('mini', Colors.white)
                            )
                          )
                       ) : Container()
                     ],
                   ),
                  ),
                  SizedBox(height: 10),
                  Text(game.title, style: Configuration.text('small', _blocked ?  Colors.grey:  Colors.black),)
                ]
              ),
            ),
          );
        });
    }

    return layout(
      gamelist(), 
      () {
         _gamestate.startgame();
        Navigator.pushNamed(context,'/gamestarted').then((value) => setState(()=>{}));
      },
      _gamestate.selectedgame != null,
      'Concentration games'
    );
  }

  Widget layout(child, onPressed, condition,[title]){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(height: 35),
        title != null ? Center(child: Text(title,style: Configuration.text('smallmedium', Colors.black),textAlign: TextAlign.center)): Container(),
        SizedBox(height: 10), 
        Expanded(child: 
          child,
        ),
        StartButton(
          onPressed:condition ? ()=> onPressed() : null,
        ),
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
          _meditationstate.switchpage(newPage, true);
        });
      },
      children: [guidedMeditation(), games()],
    );
  }
}

class MeditationList extends StatefulWidget {

  const MeditationList({
    Key key,
  }) : super(key: key);

  @override
  State<MeditationList> createState() => _MeditationListState();
}

class _MeditationListState extends State<MeditationList> {
  MeditationState _meditationstate;
  UserState _userstate;
  List<int> stages = [1,2,3,4,5,6,7,8,9,10];
  

  Widget meditation(meditation,_blocked){
    bool isSelected = _meditationstate.selmeditation != null && _meditationstate.selmeditation.cod == meditation.cod ;

    return GestureDetector(
      onTap: () => !_blocked ? 
      setState(() {
        _meditationstate.selectMeditation(meditation);
      }) : null,
      child: Container(
        padding: EdgeInsets.all(isSelected ? 0 : Configuration.tinpadding),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                padding: EdgeInsets.all(6.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: meditation.image != null && meditation.image != '' ? Image(
                    image: NetworkImage(meditation.image)
                  ) : Container(),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 50,
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Text(
                    meditation.title,
                    style: Configuration.text('tiny', _blocked ? Colors.grey : Colors.black),
                    textAlign: TextAlign.center,
                  ),
                )
              )
            ),
            _blocked ? 
              Positioned.fill(
                child: Container(
                  margin: EdgeInsets.all(5.0),
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.7)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.lock),
                      SizedBox(height: 4),
                      Text('Unlocked at stage ' +  meditation.stagenumber.toString(), style: Configuration.text('verytiny', Colors.black), textAlign: TextAlign.center,)
                    ],
                  ), 
                ),
              ):Container(),
          ],
        ),
      )
      );
         
  }


  List<Widget> meditations() { 
    List<Widget> meditcontent = new List.empty(growable: true);

    for(Stage s in _userstate.data.stages){
      for(Meditation med in s.meditpath){
        var _blocked = _userstate.user.isBlocked(med);
        meditcontent.add(meditation(med,_blocked));
      }
    }
      
    return meditcontent;
  }

  List<Widget> optionalmeditations(){
    List<Widget> meditcontent = new List.empty(growable: true);

    for(Meditation m in _userstate.data.nostagemeditations){
      meditcontent.add(meditation(m,false));
    }

    return meditcontent;
  }


  @override
  Widget build(BuildContext context) {
    _meditationstate = Provider.of<MeditationState>(context);
    _userstate = Provider.of<UserState>(context);

    return Container(
      padding:EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children:[ 
          SizedBox(height: 10),
          Text('Stage meditations',style:Configuration.text('smallmedium',Colors.black)),
          GridView(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: Configuration.width > 600 ? 4  : 3,
              crossAxisSpacing: 10
            ),
            children: meditations()
          ),
          Text('Optional meditations',style:Configuration.text('smallmedium',Colors.black)),
          GridView(
            shrinkWrap: true,
            gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: Configuration.width > 600 ? 4  : 3,
              crossAxisSpacing: 10
            ),
            children: optionalmeditations()
          ),
        ]
      ),
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
  int _index = 0;

  //podriamos utilizar meditationstate de arriba
  var meditationtype = 'free';
  var selectedstage = 1;
  var selectedtype = 'Meditation';
  var finished = false;
  var selectedduration = 15;

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
                  style: Configuration.text('medium', Colors.white)),
              SizedBox(height: Configuration.height * 0.05),
              Text('Current streak: ' + (_userstate.user.userStats.streak).toString() + ' days',
                  style: Configuration.text('medium', Colors.white)),
              SizedBox(height: Configuration.height*0.05),
              Text('Total time meditated: ' + _userstate.user.timemeditated,
                  style: Configuration.text('medium', Colors.white)),
              /*
              Text('Total meditations: ' +
                      (_userstate.user.totalMeditations.length).toString(),
                  style: Configuration.text('medium', Colors.white)
              )*/
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
                ? Colors.white
                : Color.fromRGBO(0, 0, 0, 0.4),
          ),
        ));
      });
      return res;
    }

    List<Widget> getContent(index) {
      List<Widget> l = mapToWidget(_meditationstate.selmeditation.content[index.toString()]);

      if (finished && index != null && index == _meditationstate.selmeditation.content.length -1) {
        l.add(SizedBox(height: Configuration.height * 0.02));
        l.add(StartButton(
          onPressed: () {
            _meditationstate.startMeditation(_userstate.user, _userstate.data);
          },
        ));
      }

      return l;
    }

    /*
    Widget durationButton(duration){
      return OutlinedButton(
        onPressed: (){
          setState(() {
            selectedduration = int.parse(duration);
          });
        }, 
        style: OutlinedButton.styleFrom(
          backgroundColor: selectedduration.toString() == duration ? Configuration.maincolor : Colors.transparent,
          primary: Colors.white,
          textStyle: Configuration.text('small', Colors.white)
        ),
        child: Text(duration)
      );
    }*/

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /*
            finished && _index ==_meditationstate.selmeditation.content.length -1 ? 
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Choose meditation duration', style: Configuration.text('small',Colors.white)),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        durationButton('5'),
                        durationButton('10'),
                        durationButton('15'),
                        durationButton('30')
                      ],
                    ),
                    SizedBox(height: 15)
                  ],
                )
            : Container(),*/
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: getBalls(),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    ]);
  }

  List<Widget> mapToWidget(map){  
     List<Widget> l = new List.empty(growable: true);
     l.add(SizedBox(height: 30));
      
      if (map['title'] != null) {
        l.add(Center(
          child: Text(map['title'],style: Configuration.text('medium', Colors.white)),
        ));
        l.add(SizedBox(height:15));
      }

      if (map['image'] != null) {
        l.add(ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image(image: NetworkImage( map['image']), width: Configuration.width*0.6)));
      }

      if (map['text'] != null) {
        l.add(SizedBox(height:15));
        l.add(Text(map['text'],
            style: Configuration.text('small', Colors.white,font:'Helvetica')));
      }

      if(map['html'] != null){
        l.add(SizedBox(height: 15));
        l.add(Center(child: Html(data: map['html'],
        style: {
          "body": Style(color: Colors.white,fontSize: FontSize(18)),
          "li": Style(margin: EdgeInsets.symmetric(vertical: 10.0)),
          "h2":Style(textAlign: TextAlign.center)
        })));
      }

    return l;
    
  }

  Widget countdown(context){
    return Stack(
        children: [
        Align(
          alignment: Alignment.center,
          child: _meditationstate.selmeditation != null ? 
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: _meditationstate.currentsentence != null ? MainAxisAlignment.start : MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: 
                 _meditationstate.currentsentence != null ?  [
                  AnimatedOpacity(
                    opacity: _meditationstate.newsentence ? 1.0: 0.0, 
                    child: Column(
                      children: mapToWidget(_meditationstate.currentsentence),
                    ),
                    duration: Duration(seconds: 2))
                 ] : [
                   ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image(image: NetworkImage(_meditationstate.selmeditation.image),
                      height: Configuration.height*0.35,
                      width: Configuration.height*0.35
                      ),
                    ),
                  SizedBox(height: Configuration.blockSizeVertical*3),
                  GestureDetector(
                    onDoubleTap: (){
                      _meditationstate.finishMeditation();
                    }, 
                    child: Text(_meditationstate.selmeditation.title,style: Configuration.text('smallmedium',Colors.white))
                  )
                ],
            ),
          ) :  
          Container(
            height: Configuration.blockSizeHorizontal * 60,
            width: Configuration.blockSizeHorizontal * 60,
            decoration: BoxDecoration(color: Configuration.grey, borderRadius: BorderRadius.circular(12.0)),
            child: Center(
              child:GestureDetector(
                onDoubleTap: (){ _meditationstate.finishMeditation();}, 
                child:Text('free meditation', style:Configuration.text('smallmedium', Colors.white))
              )
            ),
          ),
        ),
        SizedBox(height: Configuration.blockSizeHorizontal * 5),
        Positioned(
          bottom: 20,
          right:10,
          left:10,
          child: Stack(
            children: [
              Column(
              children: [
                _meditationstate.currentsentence != null? 
                  Text(
                    _meditationstate.sentenceindex.toString() + '/' + _meditationstate.selmeditation.followalong.entries.length.toString(), 
                    style:Configuration.text('small', Colors.white)
                  ) : 
                  Container(),
                Slider(
                  activeColor: Configuration.maincolor,
                  inactiveColor: Colors.white,
                  min: 0.0,
                  max: _meditationstate.totalduration.inSeconds.toDouble(),
                  onChanged: (a)=> null, 
                  value: _meditationstate.totalduration.inSeconds - _meditationstate.duration.inSeconds.toDouble() ,
                  label:  _meditationstate.duration.inHours > 0
                        ? _meditationstate.duration.toString().substring(0, 7)
                        : _meditationstate.duration.toString().substring(2, 7)
                ),
                _meditationstate.state == 'started' ?
                  FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () => setState(()=>  _meditationstate.pause()),
                    child: Icon(Icons.pause, color: Colors.black)
                    )
                    :
                    FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () => setState(()=>_meditationstate.startTimer()),
                    child: Icon(Icons.play_arrow, color: Colors.black)
                )              
            ]),
            ]
          ),
        )
      ]);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _meditationstate = Provider.of<MeditationState>(context);
    _userstate = Provider.of<UserState>(context);

    if(_meditationstate.state != 'pre_guided'){
      _meditationstate.startMeditation(_userstate.user, _userstate.data);
    }else{
        if (_meditationstate.selmeditation != null && _meditationstate.selmeditation.followalong != null){
          var configuration = createLocalImageConfiguration(context);
          _meditationstate.selmeditation.followalong.values.forEach((value) {
            if(value['image']!=null){
              new NetworkImage(value['image'])..resolve(configuration);
            }
          });
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.close),
            color: Colors.white,
            onPressed: () {
              if(_meditationstate.state == 'started'){
                _meditationstate.pause();
              }
              if(_meditationstate.state != 'finished'){
                showDialog(
                context: context, 
                builder:(context) {
                    return AlertDialog(
                      content: Text("Are you sure you want to exit?. This meditation won't count", 
                        style: Configuration.text('small', Colors.black)
                      ),
                      actions: [
                        TextButton(
                          child: Text('Yes',style: Configuration.text('small', Colors.black)),
                          onPressed: () {
                            _meditationstate.cancel();
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: Text('No',style: Configuration.text('small', Colors.black)),
                          onPressed: () {
                            if(_meditationstate.state == 'started'){
                              _meditationstate.startTimer();
                            }
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  }
              );
              }else{
                Navigator.pop(context);
              }
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
                } else if (_meditationstate.state == 'started' || _meditationstate.state == 'paused'  ) {
                  return countdown(context);
                } else if(_meditationstate.state == 'finished') {
                  return finish(context);
                }else{
                  return Container();
                }
              }
            ),
      )
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
        _meditationstate.selmeditation != null ?
        Text(
          'Duration must be more than ${_meditationstate.selmeditation.duration.inMinutes.toString()} min for ${_meditationstate.selmeditation.title} meditation',
          style: Configuration.text('small',Colors.black),
         ):Container(),
        SingleCircularSlider(
                95,
                _meditationstate.duration.inMinutes,
                baseColor: Colors.grey.withOpacity(0.6),
                handlerColor: Colors.transparent,
                handlerOutterRadius: 10,
                onSelectionChange: (a, b, c) {
                  setState(() {
                    if(_meditationstate.selmeditation ==null || _meditationstate.selmeditation.duration.inMinutes < b){
                      _meditationstate.setDuration(b);
                    }
                  });
                },
                height: Configuration.width > 600 ? Configuration.width*0.7 : Configuration.width*0.9,
                width: Configuration.width > 600 ? Configuration.width*0.7: Configuration.width*0.9,
                selectionColor: Configuration.maincolor,
                sliderStrokeWidth: Configuration.width > 600 ? 80:  40,
                child: Center(
                    child: Text(
                    _meditationstate.duration.inMinutes.toString() + ' min',
                  style: Configuration.text('smallmedium', Colors.black),
                )),
          ),
      ],
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

