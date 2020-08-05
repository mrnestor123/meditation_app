import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/domain/entities/mission.dart';
import 'package:observable/observable.dart';
import 'package:uuid/uuid.dart';

import 'lesson_entity.dart';
import 'level.dart';
import 'meditation_entity.dart';

class User extends Equatable {
  //Nombre es el nombre de pila y usuario es el nombre en la aplicación
  String coduser;
  final String nombre, usuario, password;

  final String mail;
  final int stagenumber;
  final double experience;
  final Level level;

  //May be a string with 1 hour, 30 sec, 20 min ...
  String timeMeditated = "";
  int minutesMeditated = 0;
  int secondsMeditated = 0;
  int hoursMeditated = 0;
  int daysMeditated = 0;

  //A list with the meditations
  final ObservableList<MeditationModel> totalMeditations = new ObservableList();

  //two lists with the lessons. At the beginning the user has no lessons learned and all the remaining lessons for each stage
  final ObservableList<LessonModel> lessonslearned = new ObservableList();

  final ObservableList<Mission> missions = new ObservableList();

  User(
      {this.coduser,
      this.nombre,
      this.experience,
      @required this.level,
      @required this.mail,
      @required this.usuario,
      @required this.password,
      @required this.stagenumber}) {
    if (this.coduser == null) {
      var uuid = Uuid();
      this.coduser = uuid.v1();
    }
  }

  @override
  List<Object> get props =>
      [coduser, nombre, mail, usuario, password, stagenumber];

  ObservableList<Lesson> getLessonsLearned() => lessonslearned;

  void setLearnedLessons(List<LessonModel> l) => lessonslearned.addAll(l);
  void setMeditations(List<MeditationModel> m) => totalMeditations.addAll(m);

  void setTimeMeditated(int days, int hours, int minutes, int seconds) {
    if (days > 0) {
      this.timeMeditated = daysMeditated.toString() +
          " day" +
          (hoursMeditated > 0 ? hoursMeditated.toString() + " h " : "");
    } else if (hours > 0) {
      this.timeMeditated = hours.toString() +
          " h " +
          (minutes > 0 ? minutes.toString() + " m" : "");
    } else if (minutes > 0) {
      this.timeMeditated = minutes.toString() +
          " m" +
          (seconds > 0 ? seconds.toString() + " s" : "");
    } else {
      this.timeMeditated = seconds.toString() + " s";
    }
  }

  void takeLesson(Lesson l) {
    this.lessonslearned.add(l);
    this.level.addXP(l.xp);
  }

  void takeMeditation(Meditation m) {
    this.totalMeditations.add(m);
    this.level.addXP(m.xp);

    hoursMeditated += m.duration.inHours;
    if (hoursMeditated > 24) {
      daysMeditated += 1;
      hoursMeditated -= 24;
    }
    minutesMeditated += m.duration.inMinutes - m.duration.inHours * 60;
    if (minutesMeditated >= 60) {
      hoursMeditated += 1;
      minutesMeditated -= 60;
    }

    secondsMeditated += m.duration.inSeconds -
        m.duration.inMinutes * 60 -
        m.duration.inHours * 3600;
    if (secondsMeditated >= 60) {
      minutesMeditated += 1;
      secondsMeditated -= 60;
    }

    setTimeMeditated(
        daysMeditated, hoursMeditated, minutesMeditated, secondsMeditated);
  }
}
