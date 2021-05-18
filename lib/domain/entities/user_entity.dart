import 'package:flutter/material.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/data/models/stageData.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/progress_entity.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/domain/entities/stats_entity.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';
import 'lesson_entity.dart';
import 'meditation_entity.dart';
import 'action_entity.dart';

class User {
  String coduser, nombre, role, image, timemeditated;
  var user;
  int stagenumber, position, meditposition;
  Stage stage;
  bool classic, follows;

  //para el modal de progreso
  Progress progress;

  //estadísticas
  UserStats userStats;

  //passed objectives también estará en stats
  Map<String, dynamic> passedObjectives = new Map();
  //cuanto le queda por pasar de etapa
  int percentage;

  // HAY MUCHAS LISTAS !!! :( MIRAR DE REFACTORIZAR ESTO !!!
  final List<UserAction> lastactions = new List.empty(growable: true);
  final List<UserAction> todayactions = new ObservableList();
  final List<UserAction> thisweekactions = new ObservableList();
  final ObservableList<UserAction> acciones = new ObservableList();

  //códigos de los usuarios a los que sigue el usuario
  final List<dynamic> followedcods = new List.empty(growable: true);
  //esto no lo guardaría en caché sino que lo sacaría cada vez del getData
  final ObservableList<UserModel> following = new ObservableList();
  final ObservableList<UserModel> followsyou = new ObservableList();
  final ObservableList<UserModel> allusers = new ObservableList();
  final ObservableList<Meditation> totalMeditations = new ObservableList();
  //hacemos week meditations??? 
  final ObservableList<Meditation> weekMeditations = new ObservableList();
  final ObservableList<Meditation> guidedMeditations = new ObservableList();

  //List with the lessons that the user has learned
  final ObservableList<Lesson> lessonslearned = new ObservableList();

  User({this.coduser, this.nombre, this.user, this.position, this.image, @required this.stagenumber,this.stage, this.role,this.classic,this.meditposition,this.userStats}) {
    if(userStats != null){
      var time = this.userStats.total.timemeditated;
      if (time > 1440) {
        timemeditated = (time / (60 * 24)).toStringAsFixed(1) + ' d';
      }else if (time > 60) {
        timemeditated = (time / 60).toStringAsFixed(0) + ' h';
      }else {
        timemeditated = time.toString() + ' m';
      }
    }
        
    if (coduser == null) {
      var uuid = Uuid();
      this.coduser = uuid.v1();
    } else {
      this.coduser = coduser;
    }
      
    // SE EJECUTA SIEMPRE
    inituser();
  }

  //Para comprobar que la racha de meditaciones funcione bien. En el futuro hará más cosas
  void inituser() {
    if(this.userStats.streak > 0) {
      var lastmeditated = DateTime.parse(this.userStats.lastmeditated);
      if(lastmeditated.day != DateTime.now().day && lastmeditated.day != DateTime.now().subtract(Duration(days: 1)).day){
        userStats.streak = 0;
      }
    } 

  }

  /* @override List<Object> get props => [coduser, nombre, mail, usuario, password, stagenumber];
  */

  ObservableList<Lesson> getLessonsLearned() => lessonslearned;
  int getStageNumber() => this.stagenumber;

  void setAction(String type, {dynamic attribute}) {
    UserAction a = new UserAction(type: type, action: attribute, username: this.nombre, time: DateTime.now().toLocal(), coduser: this.coduser);
    this.acciones.add(a);
    if(this.todayactions.length > 0 ){
      for(UserAction a in this.todayactions) {
        if(type !='meditation' && a.time.difference(DateTime.now()).inMinutes < 30 && type == a.type){
          a.setAction(attribute);
          a.time = DateTime.now().toLocal();
          return;
        }
      }
      
      this.todayactions.add(a);
    }else{
      this.todayactions.add(a);
    }

    this.thisweekactions.add(a);
    this.lastactions.add(a);
  }

  void addMeditation(MeditationModel m) => totalMeditations.add(m);
  void addFollower(User u) { u.follows = true; following.add(u); allusers.add(u);}
  void setLearnedLessons(List<LessonModel> l) => lessonslearned.addAll(l);
  void setMeditations(List<MeditationModel> m) => totalMeditations.addAll(m);
  void setActions(List<UserAction> a) { 
    acciones.addAll(a);
    DateTime today = DateTime.now();
    DateTime thismonday = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1, hours: today.hour));
    todayactions.addAll(this.acciones.where((a) => a.time.year == today.year && a.time.day == today.day && a.time.month == today.month).toList());
    thisweekactions.addAll(this.acciones.where((a) => thismonday.compareTo(a.time) <= 0).toList());
  }

  void setFollowedUsers(List<dynamic> u) => followedcods.addAll(u);
  void addAction(UserAction a) { 
    DateTime today = DateTime.now();
    DateTime thismonday = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1, hours: today.hour));

    if(today.day == a.time.day && today.month == a.time.month) {
      todayactions.add(a);
    }

    if(thismonday.compareTo(a.time) <= 0){
      thisweekactions.add(a);
    }

    acciones.add(a);
  }
  void addfollow(User u) => { following.add(u) };
  void addUnfollower(User u) { followsyou.add(u);}
  void setStage(StageModel s) {
    this.stage = s ;
    setPercentage();
  }

  //se le podrán dar parámetros... por etapa, por tiempo meditado total, por tiempo meditado en la etapa
  void sortFollowers() {
    this.allusers.sort((a,b) => b.userStats.total.timemeditated - a.userStats.total.timemeditated);
    this.following.sort((a,b) => b.userStats.total.timemeditated - a.userStats.total.timemeditated);
  }
  
  void follow(User u) {
    this.lastactions.clear();
   
    for(User user in allusers){
      if(user.coduser == u.coduser){
        user.follows = true;
      }
    }
    
    if(!following.contains(u)){
      setAction("follow", attribute: [u.nombre != null ? u.nombre : 'Anónimo']);
      following.add(u);
    }
  }

  void unfollow(User u) {
    this.lastactions.clear();
     
    for(User user in allusers){
      if(user.coduser == u.coduser){
        user.follows = false;
      }
    }

    if(following.contains(u)){
      setAction("unfollow", attribute: [u.nombre != null ? u.nombre : 'Anónimo']);
      following.remove(u);
    }
  }

  void updateStage(DataBase data) {
    data.stages.forEach((element) {
      if (element.stagenumber == (this.stagenumber + 1)) {
        this.stage = element;
      }
    });

    this.stagenumber = this.stage.stagenumber;
    this.position = 0;
    userStats.stage.reset();

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
  void setPercentage() {
    Stage s = this.stage;

    //en el momento que se cambie la nomenclatura estos métodos van a fallar !!!!! :(
    var labels = {
      'meditation': s.objectives['meditation']['time'].toString() + ' min meditations' ,
      'totaltime': 'Total time',
      'streak': 'Streak',
      'lecciones': 'Lessons',
      'meditguiadas':'Guided meditations'
    };

    var objectiveCheck = {
      'totaltime': () => userStats.stage.timemeditated >= s.objectives['totaltime'] ? true : userStats.stage.timemeditated.toString() + '/' + s.objectives['totaltime'].toString() ,
      'meditation': () => userStats.stage.timemeditations >= s.objectives['meditation']['count'] ? true : userStats.stage.timemeditations.toString() + '/' +  s.objectives['meditation']['count'].toString(),
      'streak': () => userStats.stage.maxstreak >= s.objectives['streak'] ? true : userStats.stage.maxstreak.toString() + '/' + s.objectives['streak'].toString() ,
      'lecciones': () => userStats.stage.lessons >= s.objectives['lecciones'] ? true : userStats.stage.lessons.toString() + '/' + s.objectives['lecciones'].toString(),
      'meditguiadas': () => userStats.stage.guidedmeditations >= s.objectives['meditguiadas'] ? true : userStats.stage.guidedmeditations.toString() + '/' + s.objectives['meditguiadas'].toString() 
    };

    var percentageCheck = {
      'Total time': () => userStats.stage.timemeditated / s.objectives['totaltime'] ,
       s.objectives['meditation']['time'].toString() + ' min meditations': () => userStats.stage.timemeditations / s.objectives['meditation']['count']  ,
      'Streak': () => userStats.stage.maxstreak / s.objectives['streak'],
      'Lessons': () => userStats.stage.lessons / s.objectives['lecciones'],
      'Guided meditations': () => userStats.stage.guidedmeditations / s.objectives['meditguiadas']   
    };

    double passedcount = 0;

    s.objectives.forEach((key, value) { 
      passedObjectives[labels[key]] = objectiveCheck[key](); 
    }); 

    passedObjectives.forEach((key, value) { 
      if(value == true) {
        passedcount += 1;
      } else {
        var passed = percentageCheck[key]();
        passedcount += passed < 1 ?  passed : 0;
      }
    });

    this.percentage = ((passedcount / s.objectives.length) * 100).floor();
  }

  bool takeLesson(Lesson l, DataBase d) {

    this.lastactions.clear();
    List<Lesson> lessons = List.empty(growable:true);

    if (l.stagenumber == this.stagenumber && this.position <= l.position) {
      this.userStats.takeLesson();
      this.progress = Progress(
        done: this.userStats.stage.lessons,
        total: this.stage.objectives['lecciones'], 
        what: ' Lessons'
      );
      setPercentage();

      if (this.stage.path.where((c) => c.position == this.position).length == this.userStats.lastread.length + 1) {
        this.position += 1;
        this.userStats.lastread.clear();
        return true;
      } else {
        this.userStats.lastread.add({'cod': l.cod});
        return false;
      }
    }
    

    if (this.percentage == 100) {
      this.updateStage(d);
    }

    setAction('lesson', attribute: l.title);

    return false;
  }

  //se puede refactorizar esto !!! COMPROBAR SI EL MODELO DE DATOS ESTÁ DE LA MEJOR FORMA
  bool takeMeditation(Meditation m,[DataBase d]) {
    m.coduser = this.coduser;
    
    this.lastactions.clear();
    this.totalMeditations.add(m);

    //comprobamos la racha
    if (this.userStats.streak > 0) {
      DateTime lastmeditation = DateTime.parse(this.userStats.lastmeditated);
      //si meditamos ayer
      if (lastmeditation.add(Duration(days: 1)).day == m.day.day) {
        this.userStats.streakUp();
      } else if (lastmeditation.day != m.day.day) {
        this.userStats.streak = 1;
      }
    } else {
      this.userStats.streakUp();
    }
    
    this.userStats.meditate(m);


    // si la meditación es free
    if (m.title == null) {
      if (this.stage.objectives['meditation'] != null && this.stage.objectives['meditation']['time'] != null && this.stage.objectives['meditation']['time'] <= m.duration.inMinutes) {
        this.userStats.stage.timemeditations++;
        progress = Progress(
          done: this.userStats.stage.timemeditations,
          total: this.stage.objectives['meditation']['count'], 
          what: this.stage.objectives['meditation']['time'].toString() + ' min meditations'
        );
      }
      setAction('meditation', attribute: [m.duration.inMinutes]);
    } else {
      //no se si esto funcionará bien
      if (!guidedMeditations.contains(m)) {
        this.userStats.stage.guidedmeditations++;
        this.meditposition++;
        guidedMeditations.add(m);
        progress = Progress(
          done: this.userStats.stage.guidedmeditations,
          total: this.stage.objectives['meditguiadas'], 
          what: ' guided meditations');
      }

      setAction("guided_meditation", attribute: [m.title, m.duration.inMinutes]);
    }

    this.setPercentage();

    if (this.percentage >= 100) {
      this.updateStage(d);
    }

    return false;

    //minutesMeditated += m.duration.inMinutes;
    //setTimeMeditated();
  }
}
