import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/game_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:mobx/mobx.dart';
import 'package:video_player/video_player.dart';

part 'game_state.g.dart';

class GameState extends _GameState with _$GameState {
  GameState() : super();
}

abstract class _GameState with Store {
  _GameState();

  @observable 
  Game selectedgame;

  @observable 
  bool success;

  @observable
  String state = 'before';

  Question selectedquestion;

  @observable
  bool started = false;

  @observable
  VideoPlayerController controller;

  @action
  void selectgame(Game g){
    started = false;
    selectedgame = g;
  }
  
  @action 
  void startgame(){
    state = 'video';
    controller = VideoPlayerController.network(selectedgame.video)..initialize();
    controller.addListener(() {
      if(controller.value.position == controller.value.duration) {
        getRandomquestion();
        state = 'question';
        started = false;
        print('video Ended');
      }
    });
  }

  void play() {
    controller.play();
    started = true;
  }

  //based on users answers we get a question
  String getRandomquestion(){
    var rnd = new Random();
    selectedquestion = selectedgame.questions[rnd.nextInt(selectedgame.questions.length -1)];
    return selectedquestion.question;
  }

  @action
  void userAnswer(String answer) {
    state = 'answer';
    success = selectedquestion.isValid(answer);
  }
  //todo. ask question ??
}
