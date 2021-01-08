import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/data/models/mission_model.dart';
import 'package:meditation_app/data/models/stageData.dart';
import 'package:meditation_app/domain/entities/mission.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:observable/observable.dart';
import 'package:uuid/uuid.dart';
import 'lesson_entity.dart';
import 'level.dart';
import 'meditation_entity.dart';

class User {
  //Nombre es el nombre de pila y usuario es el nombre en la aplicación. ESTO HAY QUE QUITARLO
  String coduser;
  String nombre;
  // !!!!
  FirebaseUser user;
  int stagenumber, position;
  StageModel stage;
  String role;
  //May be a string with 1 hour, 30 sec, 20 min ...
  String timeMeditated = "";

  Map<String, dynamic> stats = {};

  //A list with the meditations
  final ObservableList<MeditationModel> totalMeditations = new ObservableList();

  //List with the lessons that the user has learned
  final ObservableList<LessonModel> lessonslearned = new ObservableList();

  User(
      {this.coduser,
      this.nombre,
      this.user,
      this.position,
      @required this.stagenumber,
      this.stage,
      this.role,
      this.stats}) {
    if (coduser == null) {
      var uuid = Uuid();
      this.coduser = uuid.v1();
    } else {
      this.coduser = coduser;
    }
  }

  /* @override List<Object> get props => [coduser, nombre, mail, usuario, password, stagenumber];
  */

  ObservableList<Lesson> getLessonsLearned() => lessonslearned;

  int getStageNumber() => this.stagenumber;

  void addMeditation(MeditationModel m) => totalMeditations.add(m);
  void setLearnedLessons(List<LessonModel> l) => lessonslearned.addAll(l);
  void setMeditations(List<MeditationModel> m) => totalMeditations.addAll(m);
  void setStage(StageModel s) => this.stage = s;

  // JUNTAR TAKEMEDITATION Y TAKELESSON EN UN MÉTODO
  bool takeLesson(Lesson l) {
    List<Lesson> lessons = new List<Lesson>();

    print(this.stage.path);

    if(this.stage.path[position.toString()].firstWhere((element) => element.cod == l.codlesson)!= null && l.stagenumber == this.stagenumber){
      if (this.stage.path[position.toString()].length == this.stats['ultimosleidos'].length + 1) {
        position++;
        this.stats['ultimosleidos'] = [];
        return true;
      } else {
        this.stats['ultimosleidos'].add({'cod': l.codlesson});
        return false;
      }
    }
    return false;
  }

  //Este método se tendrá que refinar. Devuelve null o una misión cuando se pase una el usuario
  List<Mission> takeMeditation(Meditation m) {
    List<Mission> result = new List<Mission>();
    this.totalMeditations.add(m);
/*
    if (meditationstreak == 0) {
      meditationstreak++;
    } else {
      var lastMeditation = totalMeditations[totalMeditations.length - 1].day;
      if (lastMeditation != null) {
        //comprobamos la streak
        if (lastMeditation.add(Duration(days: 1)).day == m.day.day) {
          meditationstreak++;
        } else if (lastMeditation.day != m.day.day ||
            lastMeditation.month != m.day.month) {
          meditationstreak = 1;
        }
      } else {
        meditationstreak = 1;
      }
    }

    minutesMeditated += m.duration.inMinutes;
    timeMeditated = minutesMeditated.toString() + ' minutes meditated';
*/
    return result;

    //minutesMeditated += m.duration.inMinutes;
    //setTimeMeditated();
  }
}
