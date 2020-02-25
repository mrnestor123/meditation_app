import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/domain/model/userModel.dart';
import 'package:observable/observable.dart';

import 'lessonModel.dart';

class Stage {
  //The stageNumber is used as a unique ID
  int stageNumber;
  String description;
  ObservableList<Lesson> lessons = new ObservableList();
  ObservableList<User> users = new ObservableList();

  Stage({@required this.stageNumber, description});

  // If there are users in these stage they are added to that one.
  void addLesson(Lesson l) {
    for (User u in users) {
      u.addLesson(l);
    }
    this.lessons.add(l);
  }

  ObservableList<Lesson> getLessons() => lessons;

  void addPerson(User u) => users.add(u);
}
