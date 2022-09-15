

// SCREEN POST MEDITATION  !!!



import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/commonWidget/alert_dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/date_tostring.dart';
import 'package:meditation_app/presentation/pages/contentWidgets/meditation_widgets.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

import '../../../domain/entities/content_entity.dart';
import '../../../domain/entities/local_notifications.dart';
import '../../../domain/entities/meditation_entity.dart';
import '../../mobx/actions/user_state.dart';
import '../commonWidget/carousel_balls.dart';
import '../commonWidget/html_towidget.dart';
import '../commonWidget/start_button.dart';
import '../config/configuration.dart';

class MeditationEndedScreen extends StatelessWidget {
  Meditation meditation;

  MeditationEndedScreen({ Key key, this.meditation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: CloseButton(
          onPressed:(){
            Navigator.pop(context,true);
          },
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent
      ),
      extendBodyBehindAppBar: true,
      body: containerGradient(
        child : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // PASAR WeekList AQUÍ!!!
          WeekList(),
          SizedBox(height: Configuration.verticalspacing*3),
          Text('Total meditations: ' + (_userstate.user.totalMeditations.length).toString(),
            style: Configuration.text('medium', Colors.white)),
          SizedBox(height: Configuration.verticalspacing*3),
          Text('Current streak: ' + (_userstate.user.userStats.streak).toString() + ' day' + (_userstate.user.userStats.streak > 1 ? 's':''),
            style: Configuration.text('medium', Colors.white)),
          SizedBox(height: Configuration.verticalspacing*3),
          Text('Meditation time: ' +  meditation.duration.inMinutes.toString() + ' min',
            style: Configuration.text('medium', Colors.white))
        ])
      ),
    );
  }
}


Widget containerGradient({child}){
  return Container(
    decoration: BoxDecoration(
       gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          Color.fromRGBO(23,23,23,100),
          Configuration.maincolor,
        ],
      )
    ),
    child: Container(
      decoration: BoxDecoration(
       gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          Color.fromRGBO(23,23,23,100),
          Configuration.maincolor,
        ],
      )
      ),child:child
    )
  );
}


// WHEH THE USER DOES A FREE MEDITATION OR A WARMUP !!
class TimerCountDownScreen extends StatelessWidget {
  TimerCountDownScreen() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: containerGradient(
        child: Column(
          children: [

          ],
        )
      ),
      
    );
  }
}

class PreMeditationScreen extends StatefulWidget {
  Meditation meditation;

  dynamic then;

  PreMeditationScreen({this.meditation, this.then}) : super();

  @override
  State<PreMeditationScreen> createState() => _PreMeditationScreenState();
}

class _PreMeditationScreenState extends State<PreMeditationScreen> {
  bool finished = false;

  int _index = 0;

  List<Widget> mapToWidget(map){  
      List<Widget> l = new List.empty(growable: true);
      l.add(SizedBox(height: 30));
      
    if (map['title'] != null) {
      l.add(Center(
        child: Text(map['title'],style: Configuration.text('big', Colors.white)),
      ));
      l.add(SizedBox(height:15));
    }

    if (map['image'] != null) {
      l.add(ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image(image: CachedNetworkImageProvider( map['image']), width: Configuration.width*0.6)));
    }

    if (map['text'] != null) {
      l.add(SizedBox(height:15));
      l.add(Text(map['text'],
        style: Configuration.text('smallmedium', Colors.white,font:'Helvetica')));
    }

    if(map['html'] != null){
      l.add(SizedBox(height: 15));
      l.add(Center(child: htmlToWidget(map['html'], color: Colors.white)));
    }

    return l;
  }

  List<Widget> getContent(index) {
    List<Widget> l = mapToWidget(widget.meditation.content[index.toString()]);

    return l;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        elevation:0,
        backgroundColor: Colors.transparent,
        leading: CloseButton(
          color: Colors.white,
        ),
      ),
      extendBodyBehindAppBar: true,
      body: containerGradient(
        child:  Stack(children: [
          CarouselSlider.builder(
              itemCount: widget.meditation.content.entries.length,
              itemBuilder: (context, index,o) {
                return Container(
                  width: Configuration.width,
                  height: Configuration.height,
                  padding: EdgeInsets.all(Configuration.medpadding),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: getContent(index))
                  );
              },
              options: CarouselOptions(
                scrollPhysics: ClampingScrollPhysics(),
                  height: Configuration.height,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  reverse: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _index = index;
                    });
                  })),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _index == widget.meditation.content.length -1 ? 
              BaseButton(
              margin:true,
              text:'Start Timer',
              onPressed: () {
                // SE PODRÍA HACER EL START CUANDO SE ABRE LA VENTANA DE COUNTDOWN
                //_meditationstate.startMeditation(_userstate.user, _userstate.data);
                Navigator.pushReplacement(
                  context, 
                  PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2){
                        // HAY QUE VER SI 
                        return CountDownScreen(
                          content: widget.meditation,
                          then:widget.then
                        );
                      },
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                  ),
                );
              }): Container(),

              CarouselBalls(
                activecolor: Colors.white,
                items: widget.meditation.content.entries.length,
                index: _index,
                key:Key(_index.toString())),
              SizedBox(height: Configuration.verticalspacing*2)
            ],
          ),
        )
        ])
      )
    );
  }
}


// clase en la que se envía un contenido y este contenido se reproduce
class CountDownScreen extends StatefulWidget {
  dynamic onShare, onClose, onEnd,then;

  Content content;

  CountDownScreen({
    this.content,
    this.onShare, this.onClose,
    this.onEnd,
    this.then
    }) : super();

  @override
  State<CountDownScreen> createState() => _CountDownScreenState();
}

class _CountDownScreenState extends State<CountDownScreen> {
  bool pausedCount = false;
  bool loaded = false;
  // PUEDE TENER UN AUDIO O NO
  AssetsAudioPlayer assetsAudioPlayer = new AssetsAudioPlayer();

  AssetsAudioPlayer bellPlayer = new AssetsAudioPlayer();

  Duration totalDuration = new Duration();

  Duration position;

  UserState _userstate;


  List<double> playSpeeds = [0.75,1.0,1.25,1.5];
  int selectedPlaySpeed = 0;

  int secondsAfter,secondsBefore;

  bool isDragging, finished = false;

  Timer t;
  int  bellPosition = 0;

  // IT GOES TO THE FINISH SCREEN
  void finishMeditation(){
    _userstate.finishMeditation(m: widget.content);
  
    Navigator.pushReplacement(
      context, 
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2){
          return MeditationEndedScreen(meditation:widget.content);
        },
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      )
    ).then( widget.then);
  }

  void startFreeMeditation(Meditation m){
    totalDuration = m.duration;
    position = new Duration(seconds: 0);
    showNotification();
    loaded = true;
    new Timer.periodic(Duration(seconds: 1), (timer){
      t = timer;
      if(!pausedCount){
        position += new Duration(seconds: 1);
        if(position.inSeconds == totalDuration.inSeconds){
          t.cancel();
          finishMeditation();
        }else {
          if(m.meditationSettings  != null && 
            m.meditationSettings.bells != null  
            && m.meditationSettings.bells.length > 0 
            && bellPosition  < m.meditationSettings.bells.length
            && position.inSeconds == m.meditationSettings.bells[bellPosition].playAt *60
          ){
            // CUANDO HAYAN DIFERENTES SONIDOS LOS AÑADIREMOS AQUÍ !!!
            bellPlayer.open(Audio(m.meditationSettings.bells[bellPosition].sound));
            bellPosition++;
          }
          setState(() {});
      }}
    });
  }

  void checkBells(){

  }

  void showNotification(){
    LocalNotifications.showMessage(
      playSound: true,
      id:010,
      duration:totalDuration - position,
      title: "Congratulations!",
      body: 'You finished your meditation',
      onFinished: finishMeditation
    );
  }

  Widget secondaryButton(IconData icon, onPressed, tag){
    return FloatingActionButton(mini: true,
    heroTag: tag,
      backgroundColor: Colors.black.withOpacity(0.7),
      onPressed: ()=>{
        if(loaded){
          onPressed()
        }
      },
      child: Icon(icon,color: Colors.white,size: Configuration.smicon)
    );
  }

  @override 
  void dispose(){
    super.dispose();
    assetsAudioPlayer.stop();
    assetsAudioPlayer.dispose();
    if(t != null) t.cancel();
    finished = true;
    
    Wakelock.disable();

    // GUARDAMOS TODO LO QUE HACE EL USUARIO !!!
    if(_userstate != null && position != null && position.inMinutes > 1 && widget.content.cod.isNotEmpty){
      _userstate.finishRecording(widget.content, position, totalDuration);
    }

    if(widget.content.isMeditation()){
      LocalNotifications.cancelAll();
    }
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _userstate = Provider.of<UserState>(context);
    Wakelock.enable();

    print(widget.content.toJson());
    // SINO HAREMOS UN COUNTDOWN NORMAL CON EL TIPO
    if(widget.content.file != null && widget.content.file.isNotEmpty){

      assetsAudioPlayer.open(Audio.network(widget.content.file)).then((value) {
        totalDuration = assetsAudioPlayer.current.value.audio.duration;
        position = Duration(seconds: 0);
        pausedCount = false;

        if(widget.content.isMeditation()){
          showNotification();
        }

        // NO HA FUNCIONADO !!!
        assetsAudioPlayer.playlistFinished.listen((finished) {
          if(finished) {
            if(widget.content.isMeditation()){ 
              finishMeditation();
            }else {
              Navigator.pop(context);
            }
          }
        });



        if(_userstate.user.contentDone.length > 0){ 
          Content content = _userstate.user.contentDone.firstWhere((element) => element.cod == widget.content.cod,
          orElse: (){});

          if(content!=null && content.done.inMinutes < totalDuration.inMinutes){
            assetsAudioPlayer.seek(content.done);
          }
        }

        // PILLAR CUANDO ACABA MEJOR !!!!!        
        assetsAudioPlayer.currentPosition.listen((positionValue){
          if(assetsAudioPlayer.isPlaying.value || !finished){
            if(positionValue == totalDuration){
              finished = true;
            }else{
              position = positionValue;
              setState(() {});
            } 
          }
        });

        loaded = true;

        setState(() {});
      });
    }else if(widget.content.isMeditation()){
      startFreeMeditation(widget.content);
    }
  }

  bool isFreeMeditation(Meditation m){
    
    return m.file == null || m.file.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Configuration.maincolor,
        leading: CloseButton(
          color: Colors.white,
          onPressed: (){
            if(widget.content.isMeditation()){
              showAlertDialog(
                context:context,
                title: 'Are you sure you want to exit?',
                text: 'This meditation will not count',
                onYes:(){
                },
                onNo:(){
                }
              );
            }else{
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: containerGradient(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Container(
              height: Configuration.height*0.35,
              width: Configuration.height*0.35,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Configuration.borderRadius)
              ),
              child: widget.content.image != null && widget.content.image.isNotEmpty  ? 
              Center(child: Image(
                height: Configuration.height*0.3,
                fit: BoxFit.contain, image: CachedNetworkImageProvider(widget.content.image))) : 
              Container(
                color: Colors.white,
                height: Configuration.height*0.35,
                width: Configuration.height*0.35,
                child: Icon(Icons.self_improvement, size: Configuration.bigicon*2),
              ),
            ),
            SizedBox(height: Configuration.verticalspacing*2),
            Container(
              padding: EdgeInsets.symmetric(horizontal: Configuration.smpadding),
              child: Text(
                widget.content.title != null ? 
                widget.content.title : 
                "Enjoy meditating",
                textAlign:TextAlign.left,
                style: Configuration.text('smallmedium',Colors.white)
              ),
            ),
            SizedBox(height: Configuration.verticalspacing*2),
            
            widget.content.description != null ?
            Container(
              padding: EdgeInsets.symmetric(horizontal: Configuration.smpadding),
              child: Text(
                widget.content.description, 
                style: Configuration.text('small', Configuration.lightgrey, font:'Helvetica'),
                textAlign:TextAlign.left
              ),
            )
            : Container(),
            
            SizedBox(height: Configuration.verticalspacing*2),

            totalDuration != null  ?
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('0:00',style: Configuration.text('small',Colors.white)),

                  GestureDetector(
                    onDoubleTap: (){
                      if(widget.content.isMeditation()){
                        finishMeditation();
                      }
                    },
                    child: Text(totalDuration.inHours.toString() + ':' + getMinutes(totalDuration),
                      style: Configuration.text('small',Colors.white)),
                  )

                ],  
              ),
            ): Container(),
            SizedBox(height: Configuration.verticalspacing/2),

            Slider.adaptive(
              activeColor: Colors.lightBlue,
              thumbColor: Colors.white,
              inactiveColor: Colors.white,
              min: 0.0,
              max: loaded ? totalDuration.inSeconds.toDouble() : 100,
              onChangeStart: (a)=>{
                //isDragging = true
              },
              onChanged: (a){
                null;
                //assetsAudioPlayer.seek(Duration(seconds: a.toInt()));
                //setState(() {});
              }, 
              value: loaded ? position.inSeconds > totalDuration.inSeconds ? totalDuration.inSeconds.toDouble() : (position.inSeconds).toDouble() : 0,
            ),
            SizedBox(height:Configuration.verticalspacing*2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [ 
                widget.content.isMeditation() && isFreeMeditation(widget.content) ? Container(): 
                secondaryButton(
                  Icons.replay_30, 
                  (){
                    if(position.inSeconds > 30){
                      assetsAudioPlayer.seekBy(Duration(seconds: -30));
                    }
                    setState(() {});
                  },
                  'heroTag1'
                ),
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    if(assetsAudioPlayer != null){
                      assetsAudioPlayer.playOrPause(); 
                    }
                    setState(()=> pausedCount = !pausedCount);

                    if(pausedCount && widget.content.isMeditation()){
                      LocalNotifications.cancelAll();
                    }else{
                      showNotification();
                    }
                  },
                  child: Icon(
                    !pausedCount ?  Icons.pause  : Icons.play_arrow, 
                    color: Colors.black,
                    size: Configuration.smicon,
                  )
                ),


                widget.content.isMeditation() && isFreeMeditation(widget.content) ? Container(): 
                secondaryButton(
                  Icons.forward_30, 
                  (){
                    if((totalDuration.inSeconds - position.inSeconds) > 40){
                      assetsAudioPlayer.seekBy(Duration(seconds: 30));
                      setState(() {});
                    }
                  },
                  'heroTag2'
                  ),
              ]
            ),     

            SizedBox(height: Configuration.verticalspacing*3),

            widget.content.isMeditation() && isFreeMeditation(widget.content) ? Container(): 
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: Configuration.verticalspacing),
                PopupMenuButton<double>(
                  initialValue: assetsAudioPlayer.playSpeed.value,
                  padding: EdgeInsets.all(0.0),
                  itemBuilder: (BuildContext context) {  
                    return playSpeeds.map((e) => PopupMenuItem(
                      onTap:(){
                        setState(() {
                          assetsAudioPlayer.setPlaySpeed(e);
                        });
                      },
                      value: e,
                      child: Text(e.toString(),style: Configuration.text('small',Colors.black, font: 'Helvetica')),
                    )).toList();
                  },
                  child: Container(
                    padding: EdgeInsets.all(Configuration.smpadding),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Configuration.smpadding),
                      color: Colors.black.withOpacity(0.7)
                    ),
                    child: Text(assetsAudioPlayer.playSpeed.value.toString() +  ' x',
                      style: Configuration.text('tiny',Colors.white),
                    ),
                  ),
                ),
              ],
            )
          ]
        )
    ));
  }
}


class WarmUpScreen extends StatefulWidget {
  Meditation m;
  
  WarmUpScreen({this.m}) : super();

  @override
  State<WarmUpScreen> createState() => _WarmUpScreenState();
}

class _WarmUpScreenState extends State<WarmUpScreen> {
  Duration d;
  Timer t;

  @override 
  void initState(){
    super.initState();

    d = new Duration(seconds: widget.m.meditationSettings.warmuptime.toInt());

    new Timer.periodic(Duration(seconds: 1), (timer) { 
      t = timer;
      
      if(d.inSeconds <=1){
        AssetsAudioPlayer bellPlayer = new AssetsAudioPlayer();

        bellPlayer.open(Audio("assets/bowl-sound.mp3"));

        t.cancel();
        Navigator.pushReplacement(
          context, 
          PageRouteBuilder(
              pageBuilder: (context, animation1, animation2){
                // HAY QUE VER SI 
                return CountDownScreen(
                  content: widget.m,
                );
              },
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
          ),
        );
      }
      
      setState(() {
        d -= Duration(seconds: 1); 
      });
    });
  }

  @override 
  void dispose(){
    super.dispose();

    t.cancel();
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CloseButton(
          onPressed: (){
             showAlertDialog(
              context:context,
              title: 'Are you sure you want to exit?',
              text: 'This meditation will not count',
              onYes:(){
                //t.cancel();
              },
              onNo:(){
              }
            );
          },
          color: Colors.white)
      ),
      body: containerGradient(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
              Text('Get ready for the meditation', style: Configuration.text('small',Colors.white)),
              SizedBox(height: Configuration.verticalspacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width:Configuration.width*0.5,
                    child:Center(child: Text(d.inSeconds.toString() + ' s', style:Configuration.text('huge',Colors.white)))
                  )
                ],
              ),
          ]
        )
      )
    );
  }
}