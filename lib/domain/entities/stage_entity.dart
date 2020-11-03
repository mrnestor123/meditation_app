import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/data/models/mission_model.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/lesson_entity.dart';
import 'package:meditation_app/domain/entities/mission.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:observable/observable.dart';

class Stage {
  int stagenumber,userscount;
  String description,image,goals,obstacles,skills,mastery;
 
  //Lessons for each stage
  ObservableList<LessonModel> lessons = new ObservableList();

  //missions for each stage
  ObservableList<MissionModel> missions =new ObservableList();

  Stage({
    @required this.stagenumber,
    @required this.description,
    @required this.image
  });
}
