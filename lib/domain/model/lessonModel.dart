import 'package:flutter/material.dart';
import 'package:meditation_app/domain/model/stageModel.dart';
import 'package:meditation_app/domain/model/userModel.dart';
import 'package:meditation_app/domain/services/databaseService.dart';

// Lesson class for tracking the lessons. A lesson would be instantiated as Lesson(explanation:"the description");
class Lesson {
  Image slider;
  //VideoElement videodescription;
  String quickdescription, explanation;
  int stageNumber;

  //We create a lesson and add it to the stage.
  Lesson({
    @required this.quickdescription,
    @required this.stageNumber,
    this.explanation,
    this.slider,
  }) {
    connectDB();
  }

  void connectDB() {
    DataBaseConnection.addLesson(this);
  }

  int getStageNumber() => this.stageNumber;
}
