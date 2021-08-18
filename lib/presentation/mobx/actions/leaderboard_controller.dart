
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/game_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:mobx/mobx.dart';
import 'package:video_player/video_player.dart';

part 'leaderboard_controller.g.dart';

class LeaderBoardController extends _LeaderBoardController with _$LeaderBoardController {
  LeaderBoardController() : super();
}

abstract class _LeaderBoardController with Store {
  @observable 
  bool isSearching = false;

  @observable 
  String mode = 'all';

  @observable 
  List<User> totalusers;

  @observable 
  List<User> followedusers;

  @action 
  void search(){
    isSearching = !isSearching;
  }

  @action 
  void switchtab(){    
  }

  @action 
  void startsearch(String user) {


  }


  //todo. ask question ??
}