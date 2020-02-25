import 'package:flutter/material.dart';
import 'package:meditation_app/domain/model/lessonModel.dart';
import 'package:meditation_app/domain/model/meditationModel.dart';
import 'package:meditation_app/domain/model/userModel.dart';
import 'package:meditation_app/domain/services/databaseService.dart';
import 'package:observable/observable.dart';

class Feed {
  //Stores the users ids that are connected
  ObservableList<int> usersonline = new ObservableList();
  //Stores the meditations that are currently being made.
  List<String> meditationsinProgress = new ObservableList();

  ObservableMap<int, String> usersMeditating = new ObservableMap();

  int numberofpeopleMeditating;

  Feed() {
    this.numberofpeopleMeditating = meditationsinProgress.length;
  }

  ObservableList<int> getUsers() => usersonline;

  void userLoggedin(int id) => usersonline.add(id);

  void userLoggedout(int id) => usersonline.remove(id);

  void incrMeditations(String m) {
    meditationsinProgress.add(m);
    numberofpeopleMeditating++;
  }

  void decrMeditations(String m) {
    meditationsinProgress.remove(m);
    numberofpeopleMeditating--;
  }
}
