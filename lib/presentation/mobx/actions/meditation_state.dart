import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/usecases/meditation/take_meditation.dart';
import 'package:mobx/mobx.dart';

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
  MeditationModel selmeditation;  

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
  Duration totalduration = new Duration(minutes: 5);

  @observable
  bool startedmeditation = false;
  
  @observable
  String state = 'initial';

  Timer timer;
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  _MeditationState({this.meditate});


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
   // finishMeditation();
    startTimer();
  }

  @action 
  void selectMeditation(Meditation m){
    if(this.selmeditation == m){
      this.selmeditation = null;
      //this.duration = totalduration;
      state = 'free';
    }else{
      this.selmeditation = m;
      this.duration = m.duration;
      this.totalduration = m.duration;
      state = 'pre_guided';
    }
  }

  @action 
  void setDuration(int time){
    duration = new Duration(minutes: time);
    totalduration = new Duration(minutes: time);
  }

  @action
  void startTimer() {
    var oneSec = new Duration(seconds: 1);
    var timeChange; 

    //PODRIAMOS HACER QUE EL USUARIO PUEDA ELEGIR CUANDO CAMBIAR DE MEDITACION
    if(selmeditation != null){
      timeChange = selmeditation.followalong != null ? (this.totalduration.inSeconds - 3) / selmeditation.followalong.length : 1;
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
              newsentence = false;
              currentsentence = selmeditation.followalong[sentenceindex.toString()];
              assetsAudioPlayer.open(Audio("assets/bowl-sound.mp3"));
              sentenceindex++;
            }else if(currentsentence != null){
              newsentence = true;
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
    timer.cancel();
  }

  @action
  void cancel() {
    if(this.selmeditation != null ){
      state = 'pre_guided';
    }else{
      state = 'free';
    }
    if(duration.inMinutes < 1){
      duration = new Duration(minutes: 5);
      totalduration = new Duration(minutes: 5);  
    }
    
    if(timer != null && timer.isActive){
        timer.cancel();
    }
    sentenceindex = 0;
  }

  @action
  Future finishMeditation() async {
    int currentposition = user.position;
    sentenceindex = 0;
    
    if(timer.isActive){
      timer.cancel();
      duration = new Duration(minutes: 5);
    }

    if(selmeditation == null){
      selmeditation = new MeditationModel(duration: totalduration);
    }else{
      selmeditation.duration = totalduration;
    }
    
    Either<Failure, User> meditation = await meditate.call(Params(meditation: selmeditation, user: user, d: data));
    selmeditation = null;

    assetsAudioPlayer.open(Audio("assets/audios/gong.mp3"));
    state = 'finished';
  }
}
