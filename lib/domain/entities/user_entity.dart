import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/data/models/stageData.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:observable/observable.dart';
import 'package:uuid/uuid.dart';
import 'lesson_entity.dart';
import 'level.dart';
import 'meditation_entity.dart';

class User {
  String coduser, nombre, role, image;
  FirebaseUser user;
  int stagenumber, position, meditposition;
  Stage stage;
  bool classic;

  Map<String, dynamic> stats = {};
  //para saber las acciones del usuario
  Map<String, dynamic> actions = new Map();

  final ObservableList<User> following = new ObservableList();
  final ObservableList<Meditation> totalMeditations = new ObservableList();
  final ObservableList<Meditation> guidedMeditations = new ObservableList();

  //List with the lessons that the user has learned
  final ObservableList<Lesson> lessonslearned = new ObservableList();

  User(
      {this.coduser,
      this.nombre,
      this.user,
      this.position,
      this.image,
      @required this.stagenumber,
      this.stage,
      this.role,
      this.classic,
      this.meditposition,
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

  void setAction(String type, {dynamic attribute}) {
    
    var types = {
      "follow": ()=> "followed " + attribute,
      "unfollow": ()=> "unfollowed " + attribute,
      "meditation": ()=> 'meditated for ' + attribute[0].toString() + ' min',
      "guided_meditation":()=> "took" + attribute[0].toString() + ' for ' + attribute[1].toString() + ' min',
      "update_stage":()=> "climbed up one stage to" + attribute,
      'game': ()=> 'played',
      'lesson': ()=> 'read ' + attribute
    };

    String date =
        DateTime.now().day.toString() + '-' + DateTime.now().month.toString();
    String hour = DateTime.now().hour.toString() + ':' + DateTime.now().minute.toString();
    String message = types[type]();

    if (this.actions[date] == null) {
      this.actions[date] = new List();
      this.actions[date].add({
        'message': message,
        'type': type,
        'user': this.nombre,
        'hour': hour
      });
    } else {
      this.actions[date].add({
        'message': message,
        'type': type,
        'user': this.nombre,
        'hour': hour
      });
    }
  }

  void addMeditation(MeditationModel m) => totalMeditations.add(m);
  void setLearnedLessons(List<LessonModel> l) => lessonslearned.addAll(l);
  void setMeditations(List<MeditationModel> m) => totalMeditations.addAll(m);
  void setStage(StageModel s) => this.stage = s;
  void follow(User u) {
    setAction("follow", attribute: u.nombre != null ? u.nombre : 'Anónimo');
    following.add(u);
  }

  void unfollow(User u) {
    setAction("unfollow", attribute: u.nombre != null ? u.nombre : 'Anónimo');
    following.remove(u);
  }

  void updateStage(DataBase data) {
    data.stages.forEach((element) {
      if (element.stagenumber == (this.stagenumber + 1)) {
        this.stage = element;
      }
    });

    this.stagenumber = this.stage.stagenumber;
    this.position = 0;
    this.stats['etapa'].forEach((key, value) => {this.stats['etapa'][key] = 0});

    setAction("updatestage", attribute: this.stagenumber);
  }

  bool lessoninStage(Lesson l) {
    for (Content c in this.stage.path) {
      if (c.cod == l.cod) {
        return true;
      }
    }
    return false;
  }

  // JUNTAR TAKEMEDITATION Y TAKELESSON EN UN MÉTODO
  bool takeLesson(Lesson l, DataBase d) {
    List<Lesson> lessons = new List<Lesson>();
    try {
      if (l.stagenumber == this.stagenumber && lessoninStage(l)) {
        this.stats['etapa']['lecciones']++;
        this.stats['total']['lecciones']++;
        if (this.stage.path[position] == this.stats['ultimosleidos'].length + 1) {
          this.position += 1;
          this.stats['ultimosleidos'] = [];
          return true;
        } else {
          this.stats['ultimosleidos'].add({'cod': l.cod});
          return false;
        }
      }
    } catch (Exception) {}

    if (this.stage.checkifPassedStage(this)) {
      this.updateStage(d);
    }

    setAction('lesson', attribute: l.title);

    return false;
  }

  bool takeMeditation(Meditation m, DataBase d) {
    this.totalMeditations.add(m);

    if (this.stats['racha'] > 0) {
      DateTime lastmeditation = DateTime.parse(this.stats['lastmeditated']);

      //si meditamos ayer
      if (lastmeditation.add(Duration(days: 1)).day == m.day.day) {
        this.stats['racha']++;
      } else if (lastmeditation.day != m.day.day) {
        this.stats['racha'] = 1;
      }
    } else {
      this.stats['racha'] = 1;
    }

    this.stats['lastmeditated'] = m.day.toIso8601String();
    this.stats['etapa']['tiempo'] += m.duration.inMinutes;
    this.stats['total']['tiempo'] += m.duration.inMinutes;

    if (this.stats['etapa']['maxstreak'] < this.stats['racha']) {
      this.stats['etapa']['maxstreak'] = this.stats['racha'];
    }

    if (this.stats['total']['maxstreak'] < this.stats['racha']) {
      this.stats['total']['maxstreak'] = this.stats['racha'];
    }

    // si la meditación es free
    if (m.title == null) {
      if (this.stage.objectives['meditation']['time'] <= m.duration.inMinutes) {
        this.stats['etapa']['medittiempo']++;
      }
      setAction('meditation', attribute: [m.duration.inMinutes]);
    } else {
      //no se si esto funcionará bien
      if (!guidedMeditations.contains(m)) {
        this.stats['etapa']['meditguiadas']++;
        guidedMeditations.add(m);
      }

      setAction("guided_meditation", attribute: [m.title, m.duration.inMinutes]);
    }

    if (this.stage.checkifPassedStage(this)) {
      this.updateStage(d);
    }

    return false;

    //minutesMeditated += m.duration.inMinutes;
    //setTimeMeditated();
  }
}
