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
  Future<Either<Failure, Meditation>> _meditationFuture;

  @observable
  String errorMessage = "";

  @observable
  String type = 'free';

  bool finished = false;


  var selectedstage = 1;
  var selectedtype = 'Meditation';

  @observable
  Duration duration;

  Duration totalduration;



  @observable
  bool startedmeditation = false;

  @observable
  String state = 'initial';
  Timer timer;
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  _MeditationState({this.meditate});

  //types are guided, free and games
  @action 
  void switchtype(String newtype){
    type = newtype;

    if(type =='guided') {
      practice.jumpToPage(1);
      currentpage=1;
    }

    if(type == 'free'){
      practice.jumpToPage(0);
      currentpage=0;
    }

    
    if(type == 'games') {
      practice.jumpToPage(2);
      currentpage = 2;
    }
  }

  @action 
  void switchpage(int index) {
    currentpage = index;
  }


  @action
  void setMeditation(MeditationModel m, User u, DataBase d) {
    this.user = u;
    this.data = d;
    this.totalduration = m.duration;
    this.duration = m.duration;
    this.selmeditation = m;
    //finishMeditation();
    startMeditation();
  }

  @action
  void startMeditation() {
    finishMeditation();
    //startTimer();
  }

  @action
  void startTimer() {
    var oneSec = new Duration(seconds: 1);
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
        duration = duration - oneSec;
      }
    });
  }


  @action
  void pause() {
    this.state = 'paused';
    timer.cancel();
  }

  @action
  Future finishMeditation() async {
    int currentposition = user.position;
    Either<Failure, User> meditation = await meditate.call(Params(meditation: selmeditation, user: user, d: data));
    assetsAudioPlayer.open(Audio("assets/audios/gong.mp3"));
    this.state = 'finished';
  }
}
