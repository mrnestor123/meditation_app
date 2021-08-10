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

//MIRAR DE REFACTORIZAR ESTA CLASE !!!!!
class User {
  String coduser, nombre, role, image, timemeditated;
  //USUARIO DE FIREBASE
  var user;
  int stagenumber, position, meditposition;
  Stage stage;
  //follows es cuando un usuario TE SIGUE!!
  bool classic, follows;

  //para el modal de progreso
  Progress progress;

  //estadísticas
  UserStats userStats;

  //passed objectives también deberia estar en stats
  Map<String, dynamic> passedObjectives = new Map();
  //cuanto le queda por pasar de etapa
  int percentage;

  // HAY MUCHAS LISTAS !!! :( MIRAR DE REFACTORIZAR ESTO !!!
  List<UserAction> todayactions = new ObservableList();
  List<UserAction> thisweekactions = new ObservableList() ;
  List<UserAction> lastactions = new ObservableList();


  //códigos de los usuarios a los que sigue el usuario
  List<dynamic> followedcods = new List.empty(growable: true);
  List<dynamic> followsyoucods = new List.empty(growable: true);

  //esto no lo guardaría en caché sino que lo sacaría cada vez del getData
  final ObservableList<UserModel> following = new ObservableList();
  final ObservableList<UserModel> notfollowing = new ObservableList();
  final ObservableList<UserModel> followsyou = new ObservableList();
  //LIST OF USERS SORTED 
  final ObservableList<UserModel> allusers = new ObservableList();

  final ObservableList<Meditation> totalMeditations = new ObservableList();
  //hacemos week meditations??? 
  final ObservableList<Meditation> weekMeditations = new ObservableList();
  final ObservableList<Meditation> guidedMeditations = new ObservableList();

  //List with the lessons that the user has learned
  final ObservableList<Lesson> lessonslearned = new ObservableList();
  Map<dynamic,dynamic> answeredquestions = new Map();

  User({this.coduser, this.nombre, this.user, this.position, 
        this.image, @required this.stagenumber,this.stage, 
        this.role,this.classic,this.meditposition,this.userStats, 
        this.answeredquestions  }) {
   
    if(userStats != null){
      var time = this.userStats.total.timemeditated;
      if (time > 1440) {
        timemeditated = (time / (60 * 24)).toStringAsFixed(1) + ' d';
      } else if (time > 60) {
        timemeditated = (time / 60).toStringAsFixed(0) + ' h';
      } else {
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
    if(this.userStats != null && this.userStats.streak > 0) {
      var lastmeditated = DateTime.parse(this.userStats.lastmeditated);
      if(lastmeditated.day != DateTime.now().day && lastmeditated.day != DateTime.now().subtract(Duration(days: 1)).day){
        userStats.streak = 0;
      }
    } 

    if(this.stage != null){
      setPercentage();
    }
  }

  /* 
    @override List<Object> get props => [coduser, nombre, mail, usuario, password, stagenumber];
  */

  //HAY QUE QUITAR COSAS DE AQUÍII!!!!!
  ObservableList<Lesson> getLessonsLearned() => lessonslearned;
  int getStageNumber() => this.stagenumber;

  //checks if user answered the question
  bool answeredGame(String cod){
    return this.answeredquestions.length > 0 && this.answeredquestions[cod] != null;
  }

  //returns if user has read a lesson
  bool readLesson(String codlesson){
    return false;
  }

  //how much up to 6 the user has passed the lessons
  int lessonsPercentage(){
    if(this.userStats == 0){
      return 0;
    }else{
      return ((this.userStats.stage.lessons / this.stage.stobjectives.lecciones)*6).round();
    }
  }


  void setAction(String type, {dynamic attribute}) {
    UserAction a = new UserAction(type: type, action: attribute, username: this.nombre, time: DateTime.now().toLocal(), coduser: this.coduser);
    a.userimage = this.image;

    if(this.todayactions.length > 0 && type != 'meditation' && type != 'lesson'){
      for(UserAction a in this.todayactions) {
        if(a.time.difference(DateTime.now()).inMinutes < 30 && type == a.type){
          a.setAction(attribute);
          a.userimage = this.image;
          a.time = DateTime.now().toLocal();
          return;
        }
      }
      this.todayactions.add(a);
    }else{
      this.todayactions.add(a);
    }

    this.lastactions.add(a);

    //this.thisweekactions.add(a);
  }

  void addMeditation(MeditationModel m) => totalMeditations.add(m);
  void setLearnedLessons(List<LessonModel> l) => lessonslearned.addAll(l);
  void setMeditations(List<MeditationModel> m) => totalMeditations.addAll(m);
  void setActions(json, isToday) {
    for(var action in json){ 
      action['userimage'] = this.image;
      if(isToday) {
        todayactions.add(UserAction.fromJson(action));
      }else{
        thisweekactions.add(UserAction.fromJson(action));   
      }
    }
    /*
    // ya no hace falta esto !!
    DateTime today = DateTime.now();
    var dayOfWeek = 1;
    DateTime monday = today.subtract(Duration(days: today.weekday - dayOfWeek));

    if(isToday) {
      todayactions = new ObservableList();
      if(json != null && json.length > 0 ) { 
        for(var action in json){ 
          var day = DateTime.parse(action["time"]);
          if(day.day == DateTime.now().day && day.month == DateTime.now().month){
            action['userimage'] = this.image;
            todayactions.add(UserAction.fromJson(action));
          } else if(day.compareTo(monday) >= 0 && day.compareTo(monday.add(Duration(days: 7))) < 0) {
            action['userimage'] = this.image;
            thisweekactions.add(UserAction.fromJson(action));
          }
        }
      }
    } else {
      thisweekactions = new ObservableList();
      if(json != null && json.length > 0){ 
        for(var action in json){
           var day = DateTime.parse(action["time"]);
            if(day.compareTo(monday) >= 0 && day.compareTo(monday.add(Duration(days: 7))) < 0){
              action['userimage'] = this.image;
              thisweekactions.add(UserAction.fromJson(action));
          }
        }
      }
    }*/
  }

  void setFollowedUsers(List<dynamic> u) => followedcods.addAll(u);
  void setFollowsYou(List<dynamic> u )=>  followsyoucods.addAll(u);

  void addfollow(User u) { u.follows = true;  following.add(u); allusers.add(u);}  
  void addFollower(User u) { followsyou.add(u); }
  void addUnfollower(User u ) { u.follows = false; notfollowing.add(u); allusers.add(u);}
  
  //se le podrán dar parámetros... por etapa, por tiempo meidtado total, por tiempo meditado en la etapa
  void sortFollowers() {
    this.allusers.sort((a,b) => b.userStats.total.timemeditated - a.userStats.total.timemeditated);
    this.following.sort((a,b) => b.userStats.total.timemeditated - a.userStats.total.timemeditated);
    this.notfollowing.sort((a,b) => b.userStats.total.timemeditated - a.userStats.total.timemeditated);
  }
  
  void follow(User u) {
    for(User user in allusers){
      if(user.coduser == u.coduser){
        user.follows = true;
      }
    }

    if(!following.contains(u)){
      setAction("follow", attribute: [u.nombre != null ? u.nombre : 'Anónimo']);
      following.add(u);
    }

    u.followsyoucods.add(this.coduser);
  }

  void unfollow(User u) {     
    for(User user in allusers){
      if(user.coduser == u.coduser){
        user.follows = false;
      }
    }

    if(following.contains(u)){
      setAction("unfollow", attribute: [u.nombre != null ? u.nombre : 'Anónimo']);
      following.remove(u);
    }

    if(u.followsyoucods.contains(this.coduser)){
      u.followsyoucods.remove(this.coduser);
    }
  }

  void updateStage(DataBase data) {
    this.stagenumber +=1;

    data.stages.forEach((element) {
      if (element.stagenumber == this.stagenumber) {
        this.stage = element;
      }
    });

    this.progress = null;
    this.stagenumber = this.stage.stagenumber;
    this.percentage = 0;
    this.position = 0;
    userStats.reset();

    setPercentage();
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

  void setPercentage() {
    Stage s = this.stage;

    var objectiveCheck = {
      'totaltime': userStats.stage.timemeditated ,
      'meditation': userStats.stage.timemeditations ,
      'streak': userStats.stage.maxstreak,
      'lecciones': userStats.stage.lessons,
      'meditguiadas': userStats.stage.guidedmeditations 
    };

    var percentageCheck = {
      'Total time': () => userStats.stage.timemeditated / s.stobjectives.totaltime ,
      s.stobjectives.freemeditationlabel : () => userStats.stage.timemeditations / s.stobjectives.meditationcount,
      'Streak': () => userStats.stage.maxstreak / s.stobjectives.streak,
      'Lessons': () => userStats.stage.lessons / s.stobjectives.lecciones,
      'Guided meditations': () => userStats.stage.guidedmeditations / s.stobjectives.meditguiadas
    };

    var objectives =  s.stobjectives.getObjectives();

    // HAY QUE VER DE GUARDARSE SI EL USUARIO SE LO HA PASADO O NO EN EL PROPIO STAGEOBJECTIVES
    objectives.forEach((key,value) { 
         passedObjectives[value] = s.stobjectives.checkPassedObjective(objectiveCheck[key], key);
    });

    double passedcount = 0;

    passedObjectives.forEach((key, value) { 
      if(value == true) {
        passedcount += 1;
      } else {
        var passed = percentageCheck[key]();
        passedcount += passed < 1 ?  passed : 0;
      }
    });

    this.percentage = ((passedcount / objectives.length) * 100).floor();
  }

  void takeLesson(Lesson l, [DataBase d]) {
    if (l.stagenumber == this.stagenumber 
        && this.position <= l.position 
        && (
          this.userStats.lastread.length == 0 
        || this.userStats.lastread.where((c) => c['cod'] == l.cod).length == 0
        )
      ) {
      this.userStats.takeLesson();
      this.progress = Progress(
        done: this.userStats.stage.lessons,
        total: this.stage.stobjectives.lecciones, 
        what: ' Lessons'
      );
      setPercentage();

      if (this.stage.path.where((c) => c.position == this.position).length <= this.userStats.lastread.length + 1) {
        this.position += 1;
        this.userStats.lastread.clear();
      } else {
        this.userStats.lastread.add({'cod': l.cod});
      }
    }
    

    if (this.percentage >= 100) {
      this.updateStage(d);
    }

    setAction('lesson', attribute: l.title);

  }

  //se puede refactorizar esto !!! COMPROBAR SI EL MODELO DE DATOS ESTÁ DE LA MEJOR FORMA
  bool takeMeditation(Meditation m,[DataBase d]) {
    m.coduser = this.coduser;
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

    // si la meditación es free no tiene título !!
    if (m.title == null) {
      if (this.stage.stobjectives.meditationfreetime != 0 && this.stage.stobjectives.meditationfreetime <= m.duration.inMinutes) {
        this.userStats.stage.timemeditations++;
        progress = Progress(
          done: this.userStats.stage.timemeditations,
          total: this.stage.stobjectives.meditationcount, 
          what: this.stage.stobjectives.freemeditationlabel
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
          total: this.stage.stobjectives.meditguiadas, 
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
