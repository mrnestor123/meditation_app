import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/game_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';
import 'package:meditation_app/domain/usecases/user/answer_question.dart';
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

  @observable
  String state = 'before';

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
    if(selectedgame ==  g){
      selectedgame = null;
    }else{
      started = false;
      selectedgame = g;
    }
  }

  
  @action 
  void startgame(){
    answeredquestions.clear();
    max = false;
    state = 'video';
  }

  //TODO: based on users answers we get a question
  @action
  void finishvideo(){
    state = 'question';
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
      
      if(user.answeredquestions[selectedgame.cod] == selectedgame.questions.length && user.gameposition == selectedgame.position){
        user.gameposition++;
      }

      repository.updateUser(user:user);
    }
  }

  @action
  void userAnswer(int answer, User u) {
    selectedanswer = answer;
    success = selectedquestion.isValid(answer);
  
    if(success){
      answeredquestions.add(true);
      if(answeredquestions.length  == selectedgame.questions.length){
        getMaxAnswered(u);

        state = 'answer';
      }else{
        var index = selectedgame.questions.indexOf(selectedquestion);
        selectedquestion = selectedgame.questions[++index];
      }
    }else{
      getMaxAnswered(u);
      state = 'answer';
    }
  }
  //todo. ask question ??
}
