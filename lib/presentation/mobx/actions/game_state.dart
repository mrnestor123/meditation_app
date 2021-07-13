import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/game_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/usecases/user/answer_question.dart';
import 'package:mobx/mobx.dart';
import 'package:video_player/video_player.dart';

part 'game_state.g.dart';

class GameState extends _GameState with _$GameState {
  GameState({AnswerQuestionUseCase answerusecase}) : super(answerusecase: answerusecase);
}

abstract class _GameState with Store {
  _GameState({this.answerusecase});

  AnswerQuestionUseCase answerusecase;

  @observable 
  Game selectedgame;

  @observable 
  bool success;

  @observable
  String state = 'before';

  @observable
  User user;

  Question selectedquestion;

  @observable
  bool started = false;

  @observable 
  int selectedanswer;

  @observable
  VideoPlayerController controller;

  @observable
  VideoPlayerController beforecontroller;

  @action
  void selectgame(Game g){
    started = false;
    selectedgame = g;
  }

  
  @action 
  void startgame(){
    state = 'video';
  }

  //TODO: based on users answers we get a question
  @action
  void getRandomquestion(){
    print('random question');
    state = 'question';
    started = false;
    print('video Ended');
    var rnd = new Random();
    selectedquestion = selectedgame.questions[rnd.nextInt(selectedgame.questions.length -1)];
  }

  @action
  void userAnswer(int answer, User u) {
    selectedanswer = answer;
    state = 'answer';
    success = selectedquestion.isValid(answer);
    if(success){
      answerusecase.call(GameParams(game: selectedgame,question: selectedquestion, user: u));
    }
  }
  //todo. ask question ??
}
