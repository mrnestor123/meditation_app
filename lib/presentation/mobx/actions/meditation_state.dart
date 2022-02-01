import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/usecases/meditation/take_meditation.dart';
import 'package:meditation_app/presentation/pages/commonWidget/file_helpers.dart';
import 'package:mobx/mobx.dart';
import 'package:video_player/video_player.dart';
//import 'package:wakelock/wakelock.dart';

part 'meditation_state.g.dart';

class MeditationState extends _MeditationState with _$MeditationState {
  MeditationState({MeditateUseCase meditate}) : super(meditate: meditate);
}

abstract class _MeditationState with Store {
  MeditateUseCase meditate;

  @observable
  User user;

  DataBase data;

  @observable
  Meditation selmeditation;  

  Content content;

  @observable
  int currentpage = 0;

  PageController practice = new PageController(initialPage: 0);

  @observable
  Map<String,dynamic> currentsentence;
  @observable
  bool newsentence = false;
  @observable
  int sentenceindex = 0;


  bool finished = false;

  var selectedstage = 1;
  var selectedtype = 'Meditation';

  @observable
  Duration duration = new Duration(minutes: 5);
  
  @observable
  Duration totalduration = new Duration(minutes: 5);

  @observable
  bool startedmeditation = false;

  bool hasVideo = false;
  bool hasAudio = false;
  
  @observable
  String state = 'initial';

  Timer timer;
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  @observable
  VideoPlayerController controller;

  _MeditationState({this.meditate});

  @observable 
  bool shadow = false;
  bool delaying = false;

  var timeChange; 


  @action 
  void switchpage(int index, [avoidjump]) {
    currentpage = index;
    if(avoidjump == null || !avoidjump ){
      practice.jumpToPage(index);
    }
  }

  @action
  void startMeditation(User u, DataBase d) {
    this.user = u;

    // PARA QUE QUEREMOS DATA!!
    this.data = d;
    this.currentsentence = null;
   
    //PODRIAMOS HACER QUE EL USUARIO PUEDA ELEGIR CUANDO CAMBIAR DE FRASE !!!
    if(selmeditation != null && selmeditation.followalong != null){
      timeChange =  (this.totalduration.inSeconds - 3) / selmeditation.followalong.length;
    }
    startTimer();
  }

  @action 
  //DEBERÍA DE HABER SOLO UN STARTMEDITATION !!!
  void selectMeditation(Meditation m){
    if(this.selmeditation == m){
      this.selmeditation = null;
      //this.duration = totalduration;
      state = 'free';
    }else{
      // ESTO NO DEBERIA SER ASI
      this.selmeditation = m;
      if(m.duration != null){
        this.duration = m.duration;
        this.totalduration = m.duration;
        state = 'pre_guided';

      }else{
        if(selmeditation.file != null){
          if(isAudio(selmeditation.file)){
            hasAudio = true;
            assetsAudioPlayer.open(Audio.network(selmeditation.file)).then((value) {
              this.totalduration = assetsAudioPlayer.current.value.audio.duration;
              this.duration = assetsAudioPlayer.current.value.audio.duration;
              //assetsAudioPlayer.stop();
              state = 'pre_guided';
              }
            );
           // 
          }else{
            controller = new VideoPlayerController.network(selmeditation.file)..initialize().then((value) {
              this.totalduration = controller.value.duration;
              this.duration = controller.value.duration;
              state = 'pre_guided';
            });
            hasVideo = true;
          }
        }
      }
    }
  }

  @action 
  void setDuration(int time){
    duration = new Duration(minutes: time);
    totalduration = new Duration(minutes: time);
  }


  @action
  void startTimer() {
    // The following line will enable the Android and iOS wakelock.
    //Wakelock.enable();

    
    if(hasAudio){
      assetsAudioPlayer.playOrPause();
    }

    if(hasVideo){
      controller.play();
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


    this.state = 'started';

    timer = new Timer.periodic(oneSec, (timer) {
      if (this.duration.inSeconds < 2 ) {
        finishMeditation();
        state = 'finished';
        timer.cancel();
      } else {
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


  @action
  void pause() {
    this.state = 'paused';

     if(hasVideo){
      controller.pause();
    }

    if(hasAudio){
      assetsAudioPlayer.pause();
    }

    timer.cancel();
  }

  @action
  void cancel() {
    // The next line disables the wakelock again.
    //Wakelock.disable();
    if(this.selmeditation != null ){
      state = 'pre_guided';
    }else{
      state = 'free';
    }

    duration = new Duration(minutes: totalduration.inMinutes);
     
    if(timer != null ){
      timer.cancel();
    }
    sentenceindex = 0;
  }

  @action
  void light(){
    shadow = false;
     
    if(!delaying){
      delaying = true;
      Future.delayed(Duration(seconds: 10), (){
        delaying = false;
        shadow=true;
      });
    }
  }


  @action
  Future finishMeditation() async {
    if(selmeditation == null || selmeditation.file == null || selmeditation.file.isEmpty){
      int currentposition = user.position;
      sentenceindex = 0;
      
      if(timer != null || timer.isActive){
        timer.cancel();
        duration = new Duration(minutes: totalduration.inMinutes);
      }

      if(selmeditation != null){
        selmeditation.duration = totalduration;
      }
      //ESTO DEBERIA DE ESTAR EN  USER_STATE ???
      Either<Failure, User> meditation = await meditate.call(Params(meditation: selmeditation == null ? new MeditationModel(duration: totalduration) : selmeditation, user: user, d: data));
      selmeditation = null;
    }

    assetsAudioPlayer.open(Audio("assets/audios/gong.mp3"));
    state = 'finished';

  }
}
