import 'package:flutter/material.dart';
import 'package:meditation_app/domain/model/feedModel.dart';
import 'package:meditation_app/domain/model/lessonModel.dart';

import 'package:meditation_app/domain/model/meditationModel.dart';
import 'package:meditation_app/domain/model/stageModel.dart';
import 'package:meditation_app/domain/services/databaseService.dart';
import 'package:observable/observable.dart';
import 'package:uuid/uuid.dart';
/**
enum UserState {
  available,
  meditating,
  learning,
}

class User {
  String nombrepila, mail, userName, id;
  UserState state;
  Feed feed;
  int assignedStage;
  //Id of current Meditation?
  String currentMeditation;

  //A list with the meditations ids
  ObservableList<String> totalMeditations = new ObservableList();

  //two lists with the lessons ids
  ObservableList<String> lessonslearned = new ObservableList();
  ObservableList<String> remainingLessons = new ObservableList();

  var uuid = new Uuid();

  //Constructor for creating a user. Later in the service we assign the lessons to it and add it to the feed.
  User(
      {id,
      @required this.nombrepila,
      @required this.mail,
      @required this.userName,
      @required this.assignedStage,
      this.currentMeditation}) {
    this.id = uuid.v1();
    this.state = UserState.available;
    connectToDB();
  }

//For adding user to the DB. Its lists are populated in the service.
  void connectToDB() {
    DataBaseConnection.addUser(this);
  }

  ObservableList<String> getRemainingLessons() => this.remainingLessons;

  ObservableList<String> getTotalMeditations() => this.totalMeditations;

  int getStageNumber() => assignedStage;

  void setState(UserState s) => this.state = s;

  void setId(String id) => this.id = id;

  void setFeed(Feed f) {
    this.feed = f;
    f.userLoggedin(id);
  }

  void addLesson(String l) => this.remainingLessons.add(l);

  // When we start to Meditate. At the moment we only contemplate when we have a recording. We return a meditation object to use it in the stopMeditation method.
  Meditation startMeditation(Duration d,
      [String recording, String ambientSong, String reminderBell]) {
    Meditation m;
    if (recording != null)
      m = new GuidedMeditation(
          userId: this.id, duration: d, recording: recording);
    else {
      m = new NonGuidedMeditation(userId: this.id, duration: d);
    }
    currentMeditation = m.id;
    DataBaseConnection.userStartedMeditating(this, m);
    return m;
  }

  void stopMeditation(Meditation m, bool finished) {
    currentMeditation = null;
    if (finished) {
      this.totalMeditations.add(m.id);
    }

    DataBaseConnection.userStoppedMeditating(this, m, finished);
  }
}**/
