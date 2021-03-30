import 'package:flutter/material.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/data/models/stageData.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';
import 'lesson_entity.dart';
import 'meditation_entity.dart';
import 'action_entity.dart';

class User {
  String coduser, nombre, role, image;
  var user;
  int stagenumber, position, meditposition;
  Stage stage;
  bool classic;

  Map<String, dynamic> stats = {};

  Map<String, dynamic> passedObjectives = new Map();
  //cuanto le queda por pasar de etapa
  int percentage;

  final List<UserAction> lastactions = new List.empty(growable: true);

  final ObservableList<User> following = new ObservableList();
  final ObservableList<Meditation> totalMeditations = new ObservableList();
  //hacemos week meditations??? 
  final ObservableList<Meditation> weekMeditations = new ObservableList();
  final ObservableList<Meditation> guidedMeditations = new ObservableList();

  
  final ObservableList<UserAction> acciones = new ObservableList();

  //List with the lessons that the user has learned
  final ObservableList<Lesson> lessonslearned = new ObservableList();

  User({this.coduser, this.nombre,this.user,this.position, this.image, @required this.stagenumber,
      this.stage, this.role,this.classic,this.meditposition,this.stats}) {
        
    if (coduser == null) {
      var uuid = Uuid();
      this.coduser = uuid.v1();
    } else {
      this.coduser = coduser;
    }

    inituser();
  }

  //Para comprobar que la racha de meditaciones funcione bien. En el futuro hará más cosas
  void inituser() {
    if(this.stats['racha'] > 0) {
      var lastmeditated = DateTime.parse(this.stats['lastmeditated']);
      if(lastmeditated.day != DateTime.now().day && lastmeditated.day != DateTime.now().subtract(Duration(days: 1)).day){
        this.stats['racha'] = 0;
      }
    } 
  }

  /* @override List<Object> get props => [coduser, nombre, mail, usuario, password, stagenumber];
  */

  ObservableList<Lesson> getLessonsLearned() => lessonslearned;
  int getStageNumber() => this.stagenumber;

  void setAction(String type, {dynamic attribute}) {
    UserAction a = new UserAction(type: type, action: attribute, username: this.nombre, time: DateTime.now(), coduser: this.coduser);
    this.acciones.add(a);
    this.lastactions.add(a);
  }

  void addMeditation(MeditationModel m) => totalMeditations.add(m);
  void setLearnedLessons(List<LessonModel> l) => lessonslearned.addAll(l);
  void setMeditations(List<MeditationModel> m) => totalMeditations.addAll(m);
  void setActions(List<UserAction> a) => acciones.addAll(a);
  void addAction(UserAction a) => acciones.add(a);
  void setStage(StageModel s) {
    this.stage = s ;
    setPercentage(s);
  }
  
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

    setAction("updatestage", attribute: this.stagenumber.toString());
  }

  bool lessoninStage(Lesson l) {
    for (Content c in this.stage.path) {
      if (c.cod == l.cod) {
        return true;
      }
    }
    return false;
  }

  //este método se repite en la etapa también ... Moverlo todo aquí.
  //!!!! REFACTORIZAR !!!!
  void setPercentage(Stage s) {
    var labels = {
      'meditation': 'Meditaciones',
      'totaltime': 'Tiempo total',
      'streak': 'Racha',
      'lecciones': 'Lecciones',
      'meditguiadas':'Meditaciones guiadas'
    };

    var objectiveCheck = {
      'totaltime': () => this.stats['etapa']['tiempo'] >= s.objectives['totaltime'] ? true : this.stats['etapa']['tiempo'].toString() + '/' + s.objectives['totaltime'].toString() ,
      'meditation': () => this.stats['etapa']['medittiempo'] >= s.objectives['meditation']['count'] ? true : this.stats['etapa']['medittiempo'].toString() + '/' +  s.objectives['meditation']['count'].toString(),
      'streak': () => this.stats['etapa']['maxstreak'] >= s.objectives['streak'] ? true : this.stats['etapa']['maxstreak'].toString() + '/' + s.objectives['streak'].toString() ,
      'lecciones': () => this.stats['etapa']['lecciones'] >= s.objectives['lecciones'] ? true : this.stats['etapa']['lecciones'].toString() + '/' + s.objectives['lecciones'].toString(),
      'meditguiadas': () => this.stats['etapa']['meditguiadas'] >= s.objectives['meditguiadas'] ? true : this.stats['etapa']['meditguiadas'].toString() + '/' + s.objectives['meditguiadas'].toString() 
    };

    var percentageCheck = {
      'Tiempo total': () =>  s.objectives['totaltime'] / this.stats['etapa']['tiempo'],
      'Meditaciones': () => s.objectives['meditation']['count'] / this.stats['etapa']['medittiempo'],
      'Racha': () => s.objectives['streak'] / this.stats['etapa']['maxstreak'],
      'Lecciones': () => s.objectives['lecciones'] / this.stats['etapa']['lecciones'],
      'Meditaciones guiadas': () => s.objectives['meditguiadas'] / this.stats['etapa']['meditguiadas']  
    };

    double passedcount = 0;

    s.objectives.forEach((key, value) { 
      passedObjectives[labels[key]] = objectiveCheck[key]();
    });

    passedObjectives.forEach((key, value) { 
      if(value == true) {
        passedcount += 1;
      }else {
        var passed = percentageCheck[key]();
        passedcount += passed != double.infinity ?  passed : 0;
     }
    });

    this.percentage = ((passedcount / s.objectives.length) * 100).floor();
  }

  bool takeLesson(Lesson l, DataBase d) {
    List<Lesson> lessons = List.empty(growable:true);

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

  //se puede refactorizar esto !!! COMPROBAR SI EL MODELO DE DATOS ESTÁ DE LA MEJOR FORMA
  bool takeMeditation(Meditation m,[DataBase d]) {
    Meditation aux = new Meditation(title: m.title, duration: m.duration, day: DateTime.now());
    this.totalMeditations.add(m);

    if (this.stats['racha'] > 0) {
      DateTime lastmeditation = DateTime.parse(this.stats['lastmeditated']);
      //si meditamos ayer
      if (lastmeditation.add(Duration(days: 1)).day == aux.day.day) {
        this.stats['racha']++;
         if (this.stats['etapa']['maxstreak'] < this.stats['racha']) {
            this.stats['etapa']['maxstreak'] = this.stats['racha'];
          }
          if (this.stats['total']['maxstreak'] < this.stats['racha']) {
            this.stats['total']['maxstreak'] = this.stats['racha'];
          }
      } else if (lastmeditation.day != aux.day.day) {
        this.stats['racha'] = 1;
      }
    } else {
      this.stats['racha'] = 1;
    }
    
    this.stats['lastmeditated'] = DateTime.now().toIso8601String();
    
    this.stats['etapa']['tiempo'] += aux.duration.inMinutes;
    this.stats['total']['tiempo'] += aux.duration.inMinutes;
    this.stats['total']['meditaciones']++;

    if (this.stats['meditationtime'] == null) {
      this.stats['meditationtime'] = {};
    }

    if (this.stats['meditationtime'][aux.day.day.toString() + '-' + aux.day.month.toString()] == null) {
      this.stats['meditationtime'][aux.day.day.toString() + '-' + aux.day.month.toString()] = m.duration.inMinutes;
    } else {
      this.stats['meditationtime'][aux.day.day.toString() + '-' + aux.day.month.toString()] +=  m.duration.inMinutes;
    }

    // si la meditación es free
    if (aux.title == null) {
      if (this.stage.objectives['meditation'] != null && this.stage.objectives['meditation']['time'] != null && this.stage.objectives['meditation']['time'] <= aux.duration.inMinutes) {
        this.stats['etapa']['medittiempo']++;
      }
      setAction('meditation', attribute: [aux.duration.inMinutes]);
    } else {
      //no se si esto funcionará bien
      if (!guidedMeditations.contains(m)) {
        this.stats['etapa']['meditguiadas']++;
        guidedMeditations.add(m);
      }

      setAction("guided_meditation", attribute: [aux.title, aux.duration.inMinutes]);
    }

    if (this.stage.stagenumber != 10 && this.stage.checkifPassedStage(this)) {
      this.updateStage(d);
    }

    return false;

    //minutesMeditated += m.duration.inMinutes;
    //setTimeMeditated();
  }
}
