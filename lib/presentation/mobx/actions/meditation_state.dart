import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/local_notifications.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:mobx/mobx.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
//import 'package:wakelock/wakelock.dart';

part 'meditation_state.g.dart';

class MeditationState extends _MeditationState with _$MeditationState {
  MeditationState() : super();
}

// CAMBIAR LAS STRINGS DE LOS ESTADOS AQUI TAMBIEN !!!!


abstract class _MeditationState with Store {
  //MeditateUseCase meditate;

  @observable
  User user;

  DataBase data;

  @observable
  Meditation selmeditation = new Meditation(
    duration: Duration(minutes: 5),
    meditationSettings: MeditationSettings()
  );  

  Content content;

  @observable
  int currentpage = 1;

  PageController practice = new PageController(initialPage: 0);

  @observable
  Map<String,dynamic> currentsentence;

  @observable
  bool newsentence = false;
  
  @observable
  int sentenceindex = 0;

  var selectedstage = 1;
  var selectedtype = 'Meditation';

  @observable
  Duration duration = new Duration(minutes: 5);
  
  @observable
  Duration totalduration = new Duration(minutes: 5);

  @observable
  bool startedmeditation = false;


  @observable 
  double warmuptime = 0.0;

  Map<String,dynamic> intervalBells = {
    'No interval Bell':'',
    'Every Minute': '1 min',
    'Every 2 Minutes':'2 min',
    'Every 5 Minutes': '5 min',
    'Every 10 Minutes': '10 min',
    'Every 20 Minutes': '20 min',
    'Halfway':'Halfway'
  };
  
  @observable
  String selectedIntervalBell = '';

  int intervalBell;


  int selectingmeditation = 0;
  int premeditation = 1;
  int meditating = 2;
  int finished = 3;
  int paused = 4;
  int warmup = 5;

  bool hasVideo = false;
  bool hasAudio = false;
  
  @observable
  int state;

  Timer timer;
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  List<IntervalBell> bells = new List.empty(growable: true);


  @observable
  VideoPlayerController videocontroller;

  _MeditationState( ){
    state = selectingmeditation;
  }

  @observable 
  bool shadow = false;
  bool delaying = false;

  var timeChange; 

  Timer bellTimer;

  Timer warmupTimer;


  int volume;


  @action 
  void switchpage(int index, [avoidjump]) {
    currentpage = index;
    
    if(avoidjump == null || !avoidjump ){
      practice.jumpToPage(index);
    }
  }

  @action
  void selectBell(String interval){
    selectedIntervalBell = interval;
  }

  void setUpIntervalBell(){

    void playBell(){
      if(duration.inMinutes >= 1){
        assetsAudioPlayer.open(Audio("assets/bowl-sound.mp3"));
      }
    }

    int time;
    // ESTO NO HACEFALTA
    

  }

  // esto es cuando la meditación es free y va con tiempo 
  //  PARA BORRAR
  @action
  void startMeditation(User u, DataBase d) {
    //PORQUE HACE FALTA El USUARIO AQUI ????
    this.user = u;

    // PARA QUE QUEREMOS DATA!!
    this.data = d;
    this.currentsentence = null;

    this.state = meditating;
   
    //PODRIAMOS HACER QUE EL USUARIO PUEDA ELEGIR CUANDO CAMBIAR DE FRASE !!!
    if(selmeditation != null && selmeditation.followalong != null){
      timeChange =  (this.totalduration.inSeconds - 3) / selmeditation.followalong.length;
    }

    LocalNotifications.showMessage(
      playSound: true,
      id:010,
      duration: this.totalduration,
      title: "Congratulations!",
      body: 'You finished your meditation',
      onFinished: this.finishMeditation
    );
  
    startTimer();
  }

  // PARA BORRAR !!! ARREGLADO !!!
  @action 
  void selectMeditation(Meditation m){
    // ESTO NO DEBERIA SER ASI
    this.selmeditation = m;
    if(m.duration != null){
      this.duration = m.duration;
      this.totalduration = m.duration;
    }
  }

  @action 
  void setDuration(int time){
    selmeditation.duration = new Duration(minutes: time);
  }

  // BORRAR
  @action   
  void startWarmup(){
    warmupTimer =  Timer.periodic(Duration(seconds: 1), (t) { 
      if(warmuptime > 0){
        warmuptime = warmuptime - 1;
      }else {
        // un sonido de que empieza la meditación
        assetsAudioPlayer.open(Audio("assets/bowl-sound.mp3"));
        t.cancel();
        warmupTimer.cancel();
        startTimer();
        state = meditating;
      }
    });
  }



  // BORRAR
  @action
  void startTimer() {
    shadow=false;

    // HAY QUE SALIR DE ESTE MODO UNA VEZ SE ACABA !!!!!!!
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    if(selectedIntervalBell != ''){
      setUpIntervalBell();
    }

    if(state == paused){
      LocalNotifications.showMessage(
        playSound: true,
        id:010,
        duration: this.duration,
        title: "Congratulations!",
        body: 'You finished your meditation',
        onFinished: this.finishMeditation
      );
    }

    // The following line will enable the Android and iOS wakelock.
    Wakelock.enable();
    if(hasAudio){
      assetsAudioPlayer.playOrPause();
    }

    if(hasVideo){
      videocontroller.play();
    }
   
    var oneSec = new Duration(seconds: 1);
    
    if(!delaying){
      Future.delayed(Duration(seconds: 10), (){
        delaying = false;
        shadow=true;
      });
    }
    
    if(timer != null){
      timer.cancel();
    }


    this.state = meditating;

    timer = new Timer.periodic(oneSec, (timer) {
      if (this.duration.inSeconds < 2 ) {
        finishMeditation();
        state = finished;
        timer.cancel();
      } else {
        // COMPROBAR CADA SEGUNDO NO ES EFICIENTE !!!
        if(selmeditation != null){
          if(selmeditation.type !='free' && selmeditation.followalong != null){
            if((this.totalduration.inSeconds - this.duration.inSeconds) > (timeChange * sentenceindex) + 3){
              shadow = true;
              newsentence = true;
              currentsentence = selmeditation.followalong[sentenceindex.toString()];
              assetsAudioPlayer.open(Audio("assets/bowl-sound.mp3"));
              sentenceindex++;
            }else if(currentsentence != null){
              newsentence = false;
            }
          }
        }

        this.duration = this.duration - oneSec;
      }
    });
  }

  // BORRAR
  @action
  void pause() {
    this.state = paused;

    if(hasVideo){
      videocontroller.pause();
    }

  /*
    if(hasAudio){
      assetsAudioPlayer.pause();
    }*/

    timer.cancel();

    LocalNotifications.cancelAll();
  }


  List<IntervalBell> createIntervalBells(){

    if(bells.length > 0){
     
      List<IntervalBell> aux = new List.empty(growable: true);
      for(IntervalBell b in bells){
        if(b.repeat){
          int minutes = b.playAt;
          int intervaltime = b.playAt ;

          while(minutes < selmeditation.duration.inMinutes){
            aux.add(IntervalBell(
              sound: b.sound,
              name: b.name,
              playAt:minutes
            ));
            minutes += intervaltime;
          }
        }else{
          aux.add(b);
        }
      }

      aux.sort((a,b)=> a.playAt - b.playAt);
      
      selmeditation.meditationSettings.bells = aux;
    }

    // PARA EL MODELO ANTERIOR 
    if(selectedIntervalBell != '' && selectedIntervalBell.isNotEmpty){
      List<IntervalBell> bells = new List.empty(growable: true);

      if(selectedIntervalBell == 'Halfway'){
        bells.add(IntervalBell(playAt: selmeditation.duration.inMinutes~/2));
      }else {
        int seconds = int.parse(selectedIntervalBell.substring(0,2)) * 60;
        int intervaltime = int.parse(selectedIntervalBell.substring(0,2)) * 60;

        while(seconds < selmeditation.duration.inSeconds){
          bells.add(IntervalBell(playAt: seconds~/60));
          seconds += intervaltime;
        }
      }

      selmeditation.meditationSettings.bells = bells;
    
    }
  }

  @action 
  // EL PRESET  TIENE LOS SETTINGS TAMBIÉN!!! 
  void selectPreset(MeditationPreset p){
    selmeditation = new Meditation(
      duration: Duration(minutes: p.duration),
      meditationSettings: p.settings
    );


    //  CREO QUE ESTO NO FUNCIONA
    Duration d = new Duration(minutes: p.duration);
    this.duration = d;
    this.totalduration = d;

    this.bells  = new List.empty(growable: true);

    if(p.intervalBell != null && p.intervalBell.isNotEmpty){
      this.bells.add(IntervalBell(
        sound: 'assets/audios/bowl-sound.mp3',
        name: 'Bowl',
        playAt: int.parse(p.intervalBell.substring(0,2)),
        repeat: true
      ));
    }else{
      this.selectedIntervalBell = '';
      if(p.settings.bells.length > 0){
        this.bells.addAll(p.settings.bells);
      }
    }
  }


  // BORRAR
  @action
  void cancel({bool hasFinishedMeditation = false}) {
    Wakelock.disable();

    if(!hasFinishedMeditation){
      LocalNotifications.cancelNotification(id:010);
      state = selectingmeditation;  
    }

    duration = new Duration(minutes: totalduration.inMinutes);
     
    if(timer != null ){
      timer.cancel();
    }

    /*
    if(hasAudio){
      assetsAudioPlayer.stop();
      hasAudio = false;
    }*/

    if(hasVideo){

    }

    if(bellTimer != null && bellTimer.isActive){
      bellTimer.cancel();
    }

    if(warmupTimer != null && warmupTimer.isActive){
      warmupTimer.cancel();
    }

    if(selmeditation != null){
      selmeditation = null;
    }

    sentenceindex = 0;
  }

  // BORRAR
  @action
  void light(){
    shadow = false;
     
    if(!delaying){
      delaying = true;
      Future.delayed(Duration(seconds: 10), (){
        delaying = false;
        shadow = true;
      });
    }
  }


  // BORRAR ESTO YA NO SE HACE AQUI :(((((
  
  @action
  Future finishMeditation() async {
    Wakelock.disable();

    //int currentposition = user.position;
    sentenceindex = 0;

    shadow = false;

  /*
    Either<Failure, User> meditation = await meditate.call(
      Params(meditation:  selmeditation == null 
        ? new MeditationModel(duration: totalduration) 
        : selmeditation, 
      )
    );*/

    selmeditation = null;

    // SOLO ESTO SI NO FUNCIONA LO OTRO !
    assetsAudioPlayer.open(Audio("assets/audios/gong.mp3"));
    
    // NO ESTA CLARO ESTO !!!
    //assetsAudioPlayer.dispose();
    state = finished;

    cancel(hasFinishedMeditation:true);

  }
}




