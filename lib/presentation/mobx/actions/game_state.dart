import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/game_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';
import 'package:mobx/mobx.dart';
import 'package:video_player/video_player.dart';

part 'game_state.g.dart';

class GameState extends _GameState with _$GameState {
  GameState({UserRepository repository}) : super(repository: repository);
}

abstract class _GameState with Store {
  UserRepository repository;
  
  _GameState({this.repository});

  @observable 
  Game selectedgame;

  @observable 
  bool success;


  int before_video = 4;
  int finished = 3;
  int showing_video = 0;
  int question_ask = 1;
  int question_answered = 2;


  @observable
  int state;

  @observable
  User user;

  @observable
  Question selectedquestion;

  @observable
  bool started = false;

  @observable 
  bool max = false;

  @observable 
  bool unlockednext = false;




  int selectedanswer;

  @observable
  ObservableList<bool> answeredquestions = new ObservableList();

  @observable
  VideoPlayerController controller;

  @action
  void selectgame(Game g){
    started = false;
    selectedgame = g;
    state = before_video;
  }

  
  @action 
  void startgame(){
    answeredquestions.clear();
    max = false;
    state = showing_video;
  }

  //TODO: based on users answers we get a question
  @action
  void finishvideo(){
    state = question_ask;
    started = false;
    selectedquestion = selectedgame.questions[0];
  }

  void getMaxAnswered(User user){
    if(user.answeredquestions[selectedgame.cod] == null){
      user.answeredquestions[selectedgame.cod] = answeredquestions.length;
    } 
    
    if(user.answeredquestions[selectedgame.cod] <= answeredquestions.length){
      
      user.answeredquestions[selectedgame.cod] = answeredquestions.length;
      max = true;
      
      if(user.answeredquestions[selectedgame.cod] == selectedgame.questions.length && user.userProgression.gameposition == selectedgame.position){
        user.userProgression.gameposition++;
      }

      repository.updateUser(user:user);
    }
  }

  @action
  void userAnswer(int answer, User u) {
    selectedanswer = answer;
    success = selectedquestion.isValid(answer);
    state = question_answered;

    if(success){
      answeredquestions.add(true);
      if(answeredquestions.length  == selectedgame.questions.length){
        getMaxAnswered(u);
        Future.delayed(
          Duration(seconds: 2),
          (){
            state = finished;
          }
        );
      }else{
        var index = selectedgame.questions.indexOf(selectedquestion);

        Future.delayed(
          Duration(seconds: 2),
          (){
            state = question_ask;
            selectedquestion = selectedgame.questions[++index];
          }
        );
      }
    }else{
      getMaxAnswered(u);
      Future.delayed(
        Duration(seconds: 2),
        (){
          state = finished;
        }
      );
    }
  }
  //todo. ask question ??
}
