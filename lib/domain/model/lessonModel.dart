import 'package:flutter/material.dart';
import 'package:meditation_app/domain/model/stageModel.dart';
import 'package:meditation_app/domain/model/userModel.dart';
import 'package:meditation_app/domain/services/databaseService.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
/**
// Lesson class for tracking the lessons. A lesson would be instantiated as Lesson(explanation:"the description");
class Lesson {
  String id;
  Image slider;
  //VideoElement videodescription;
  String quickdescription, explanation;
  //for getting the stage
  int stageNumber;

  var uuid = new Uuid();
  //We create a lesson and add it to the stage.
  Lesson({
    id,
    @required this.quickdescription,
    @required this.stageNumber,
    this.explanation,
    this.slider,
  }) {
    id = uuid.v1();
    connectDB();
  }
//Every time we create a lesson. This lesson gets added to the database. Maybe used when creating an administrator mode.
  void connectDB() {
    DataBaseConnection.addLesson(this);
  }

  int getStageNumber() => this.stageNumber;
}
**/
