
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/message.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/notification_entity.dart';
import 'package:meditation_app/domain/entities/course_entity.dart';
import 'package:meditation_app/domain/entities/progress_entity.dart';
import 'package:meditation_app/domain/entities/retreat_entity.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/domain/entities/stats_entity.dart';
import 'package:meditation_app/domain/entities/user_settings_entity.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';
import 'game_entity.dart';
import 'lesson_entity.dart';
import 'meditation_entity.dart';
import 'action_entity.dart';

// MIRAR DE REFACTORIZAR ESTA CLASE !!!!!
// HAY QUE CREAR SUBCLASES,
// TEACHER , ADMIN , MEDITATOR , BASEUSER = usuario del que no sacamos ninguna información

class User {
  String coduser, nombre, role, image, timemeditated;

  //USUARIO DE FIREBASE
  var user;
  int stagenumber, percentage, version;


  Stage stage;
  TeacherInfo teacherInfo;
  TeacherSettings teacherSettings;
  UserProgression userProgression;
  UserSettings settings;
  //estadísticas
  UserStats userStats;

  //follows es cuando un usuario TE SIGUE!!
  bool offline, stageupdated;

  //para el modal de progreso
  Progress progress;

  // ESTO QUE ES ????
  DateTime meditationTime;

  List<User> students = new List.empty(growable: true);
  List<Content> addedcontent =  new List.empty(growable:true);
  List<Course> addedcourses = new List.empty(growable: true);

  List<dynamic> unreadmessages = new List.empty(growable: true);
  List<Message> messages = new List.empty(growable:true);

  List<Course> joinedcourses = new  List.empty(growable: true);

  //passed objectives también deberia estar en stats
  Map<String, dynamic> passedObjectives = new Map();

  // HAY MUCHAS LISTAS !!! :( MIRAR DE REFACTORIZAR ESTO !!!
  List<UserAction> todayactions = new ObservableList();
  List<UserAction> thisweekactions = new ObservableList() ;
  List<UserAction> lastactions = new ObservableList();

  //LISTA DE CÓDIGOS DE USUARIOS
  List<User> following = new List.empty(growable: true);

  List<User> followers = new List.empty(growable: true);
  List<Notify> notifications = new List.empty(growable:true);

  List<MeditationPreset> presets = new List.empty(growable:true);

  List<File> files = new List.empty(growable:true);

  List<DoneContent> contentDone =  new List.empty(growable:true);

  List<Retreat> retreats  = new List.empty(growable: true);


  //MIRAR DE QUITAR ESTAS LISTAS TAMBIEN
  final ObservableList<Meditation> totalMeditations = new ObservableList();
  //hacemos week meditations??? 

  //List with the lessons that the user has learned
  final ObservableList<dynamic> readlessons = new ObservableList();
  //HACE FALTA ESTO ???
  Map<dynamic,dynamic> answeredquestions = new Map();
  
  User({
    this.coduser, this.nombre, this.user,  
    this.image, this.stagenumber = 1,this.stage, this.offline = false,
    this.role, this.userStats, 
    this.answeredquestions , this.settings, this.version = 0,
    this.unreadmessages, this.meditationTime, 
    this.teacherInfo, this.userProgression
  }) {
      
    if(userStats != null){
      getTimeMeditatedString();
    }else{
      this.userStats = UserStats.empty();
    }

    if(unreadmessages == null){
      this.unreadmessages = new List.empty(growable: true);
    }
        
    if (coduser == null) {
      var uuid = Uuid();
      this.coduser = uuid.v1();
    } else {
      this.coduser = coduser;
    }

    if(answeredquestions == null){
      answeredquestions = new Map();
    }

    if(settings == null){
      settings = UserSettings.empty();
    }

    if(userStats == null){
      userStats = UserStats.empty();
    }
      
  }

  int checkStreak(changeData){
    int daysBetween(DateTime from, DateTime to) {
      from = DateTime(from.year, from.month, from.day);
      to = DateTime(to.year, to.month, to.day);
        
      return (to.difference(from).inHours / 24).round();
    }

    // ESTO PUEDE DAR ERROR !!!
    if(this.userStats != null && this.userStats.streak > 0 && this.totalMeditations.length > 0){
      DateTime now = DateTime.now();
      DateTime yesterday = now.subtract(Duration(days: 1));
      bool checkingStreak = true;
      bool meditatedToday = totalMeditations.where((element) => element.day.day == now.day && element.day.month == now.month && element.day.year == now.year).length >= 1;
      int streak = meditatedToday ? 1 : 0;


      List<Meditation> auxMeditations = 
        totalMeditations.where((element) => daysBetween(element.day, now) < this.userStats.streak + 5).toList();

      //DOUBLE CHECK DE LA  STREAK POR SI ACASO !!!!
      if(auxMeditations.length > 0){
        while(checkingStreak){
          if(auxMeditations.where((element) => element.day.day == yesterday.day && element.day.month == yesterday.month && element.day.year == yesterday.year).length == 0){
            checkingStreak = false;
          }else{
            streak++;
            yesterday = yesterday.subtract(Duration(days: 1));
          }
        }
      }

      if(changeData){
        this.userStats.streak = streak;
      }else{
        return streak;
      }
    } 
  }

  //Para comprobar que la racha de meditaciones funcione bien. En el futuro hará más cosas
  void inituser() {
   
    // SOLO LA COMPROBAMOS SI ERES EL USUARIO DE LA APP
    if(this.stage != null){
      //setPercentage();
      checkStreak(true);
    }
  }

  /* 
    @override List<Object> get props => [coduser, nombre, mail, usuario, password, stagenumber];
  */

  //HAY QUE QUITAR COSAS DE AQUÍII!!!!!
  ObservableList<Lesson> getLessonsLearned() => readlessons;
  int getStageNumber() => this.stagenumber;

  //checks if user answered the question
  bool answeredGame(String cod){
    return this.answeredquestions.length > 0 && this.answeredquestions[cod] != null;
  }

  //En el futuro sería  si contains la lista de lessons
  //returns if user has read a lesson
  bool readLesson(Content  c){
    return this.readlessons.contains(c.cod);
  }

  bool isBlocked(Meditation meditation){
    return !this.settings.unlocksMeditation() && 
    (
      meditation.position != null &&  
      this.userProgression.meditposition[meditation.stagenumber-1] < meditation.position &&  
      this.stagenumber <= meditation.stagenumber 
    );
  }

  bool isNormalProgression(){
    return settings.getProgression() == 'casual';
  }
  
  bool isGameBlocked(Game g){
    return this.userProgression.gameposition < g.position;
  }

  bool isLessonBlocked(Content l){
    return !settings.unlocksLesson() 
    && (
      this.userProgression.lessonposition[l.stagenumber-1] < l.position 
      && this.userProgression.stageshown <= l.stagenumber 
    );
  }

  bool isStageBlocked(Stage s){
    return !settings.unlocksLesson() && ((this.userProgression.stageshown +2) < s.stagenumber && this.stagenumber < s.stagenumber);
  }

  // UNIFICAR
  bool isContentBlocked(Content c){
    if(this.isAdmin() || this.isTeacher()){
      return false;
    }else if(c.position == null || c.stagenumber == null ) {
      return false;
    }else if(c.isMeditation()){
      return isBlocked(c);
    }else{
      return isLessonBlocked(c);
    }
  }

  bool isAdmin(){
    return this.role == 'admin';
  }

  bool isTeacher(){
    return this.role =='teacher';
  }
  
  void setVersion(int version) => this.version = version;
  void setImage(String image) => this.image = image;

  void setReadLessons(List<dynamic> lessons) {
    this.readlessons.clear();
    this.readlessons.addAll(lessons);
  }

  //ESTOS METODOS SON BUENOS ?????
  void setAction(String type, {dynamic attribute}) {
    UserAction a = new UserAction(type: type, action: attribute, username: this.nombre, time: DateTime.now().toLocal(), coduser: this.coduser);
    a.userimage = this.image;
    a.user = this;
    this.todayactions.add(a);
    this.lastactions.add(a);


    // YO HARÍA ALGO AQUÍ !!!!!!
    // SUBIRÍA LAS ACTIONS AQUI
    // ????
  }
  
  void setActions(json, isToday) {
    for(var action in json){ 
      if(action['userimage'] == null){
        action['userimage'] = this.image;
      }


      if(isToday) {
        todayactions.add(UserAction.fromJson(action));
      }else{
        thisweekactions.add(UserAction.fromJson(action));   
      }
    }
  }

  void uploadContent({Content c}){
    this.addedcontent.add(c);
  }

  Message sendMessage(String to, String type,[String msg]){
    var msgtypes= {
      'classrequest': nombre + ' wants to be your student', 
      'text': msg,
      'broadcast':msg
    };

    return Message(
      sender: this.coduser,
      receiver: to == null ? this.students : to,
      date: DateTime.now(),
      username: nombre, 
      text: msgtypes[type],
      type: type,
    );
  }

  //ACTUALIZAMOS EN LOS DOS SITIOS
  /*
    void follow(User u) {
    u.followed = true;

    if(following.where((element) => element.coduser == u.coduser).length == 0){
      // QUE la accion de seguir solo notifique a los que les han seguido!!
      //setAction("follow", attribute: [u.nombre != null ? u.nombre : 'Anónimo']);
      following.add(u);
    }

    u.followers.add(this);
  }

  void unfollow(User u) {   
    u.followed = false;

    int index =  this.following.indexWhere((element) => element.coduser == u.coduser);

    if(index != -1){
     // setAction("unfollow", attribute: [u.nombre != null ? u.nombre : 'Anónimo']);
      this.following.removeAt(index);
    }

    int index2 =  u.followers.indexWhere((element) => element.coduser == this.coduser);

    if(index2 != -1){
      u.followers.removeAt(index2);
    }
  }*/

  void updateStage(DataBase data) {
    this.stagenumber +=1;    

    data.stages.forEach((element) {
      if (element.stagenumber == this.stagenumber) {
        this.stage = element;
      }
    });

    this.percentage = 0;
    /*
    if(this.stagenumber  > this.userProgression.stageshown){
      this.position = 0;
    }*/
    
    //this.meditposition = 0;
    userStats.reset();

    if(this.readlessons != null && this.readlessons.length > 0){
      this.stage.path.where((l)=> l.stagenumber == this.stagenumber).toList().forEach((element) {
        if (this.readlessons.contains(element.cod)) {
          this.userStats.readLessons++;
        }
      });
    }

    this.stageupdated = true;

    this.progress = Progress(
      done: this.stagenumber,
      what: 'stage',
      stage: this.stage
    );

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



  //CAMBIAR LOS MAPS A CLASES !!!!
  // HACER ESTO MÁS SENCILLO !!!
  /*
  void setPercentage() {



    /*var objectiveCheck = {
      'totaltime': userStats.stage.timemeditated ,
      'meditation': userStats.stage.timemeditations ,
      'streak': userStats.stage.maxstreak,
      'lecciones': userStats.stage.lessons,
      'meditguiadas': userStats.stage.guidedmeditations 
    };

    // 0 / x == 0? 
    var percentageCheck = {
      'Total time': () => userStats.stage.timemeditated / s.stobjectives.totaltime ,
      s.stobjectives.freemeditationlabel : () => userStats.stage.timemeditations / s.stobjectives.meditationcount,
      'Streak': () => userStats.stage.maxstreak / s.stobjectives.streak,
      'Lessons': () => userStats.stage.lessons / s.stobjectives.lecciones,
      'Guided meditations': () => userStats.stage.guidedmeditations / s.stobjectives.meditguiadas
    };
   

    var objectives = s.stobjectives.getObjectives();
    
    if(objectives.length > 0){
      passedObjectives = new Map();

      // HAY QUE VER DE GUARDARSE SI EL USUARIO SE LO HA PASADO O NO EN EL PROPIO STAGEOBJECTIVES
      objectives.forEach((key,value) { 
        passedObjectives[value] = s.stobjectives.checkPassedObjective(objectiveCheck[key], key);
      });

      double passedcount = 0;

      passedObjectives.forEach((key, value) { 
        if(value ==  1 ) {
          passedcount += 1;
        } else {
          var passed = percentageCheck[key]();
          passedcount += passed < 1 ? passed : 0;
        }
      });
    

      this.percentage = ((passedcount / objectives.length) * 100).floor();
    }else{
       */
      this.percentage = 60;
    
  }*/

  Message acceptStudent(Message m, confirm){
    this.messages.removeWhere((element) => element.sender == m.sender);
    m.deleted = true;

    Message reply = new Message(
      username: this.nombre,
      sender: this.coduser,
      receiver: m.sender,
      date:DateTime.now(),
      type:'message',
    );

    if(m.user != null){
      if(confirm){
        this.students.add(m.user);
        reply.text = 'Your class request has been accepted';
        m.user.messages.add(reply);
      }else{
        reply.text = 'Your class request has been denied';
        m.user.messages.add(reply);
      }
    }

    return reply;
  }

  // CUANDO UN USUARIO TERMINA UN CONTENIDO !!!
  void takeLesson(Content l, [DataBase d]) {
    // HAY QUE AÑADIR  LAS READLESSONS A DONECONTENT !!!
    if(l.stagenumber != null) {
      if(this.contentDone.where((element)=> l.cod == element.cod && element.timesFinished != null).isEmpty){

        this.userProgression.lessonposition[l.stagenumber-1] += 1;

        // FALTARÁ COMPROBAR EL PORCENTAJE !!

        /*if(l.stagenumber == this.stagenumber && this.userStats.stage.lessons < this.stage.stobjectives.lecciones){
         

          setPercentage();
        
          if (this.percentage >= 100) {
            this.updateStage(d);
          }
        }*/

        this.userStats.lastread.clear();
        

        // IF YOU READ  ALL THE CONTENT OF STAGE 1 YOU UNLOCK STAGE 2
        if(d.stages[l.stagenumber-1].checkPercentage(this) >= 100 && l.stagenumber < d.stages.length){
          this.userProgression.stageshown ++;
        }

        this.userStats.takeLesson();

      }
    }

    setAction(l.isVideo() ? 'video':'lesson', attribute: l.title);
  }


  void getTimeMeditatedString({int time}){
    // SE PUEDE SACAR DEL TOTAL DE  MEDITACIONES
    var time = this.userStats.timeMeditated  != null ? this.userStats.timeMeditated : 0;
    int hours = time ~/ 60; 


    if(hours > 24){
      int days = hours ~/ 24;
      int remaininghours = hours % 24;

      if(days > 7){
        int weeks = days ~/ 7;
        int remainingdays = days%7;
        
        timemeditated = weeks.toString() + 'w ' +  remainingdays.toString() + 'd';
      }else{
        timemeditated = days.toString() + 'd ' + remaininghours.toString() + 'h';
      }
    }else{
      if(hours >= 1){
        timemeditated = hours.toString() + 'h';
      }else{
        int minutes = time % 60;
        timemeditated = minutes.toString() + 'm';
      }
    }
  }

  // cambiar content por recording !!
  // LO AÑADE  A LA LISTA DE CONTENTDONE !!
  DoneContent finishContent(Content c, [Duration done, Duration totalDuration]){

    //  ESTO LO DEBERÍAMOS DE GUARDAR ??????
    int index = this.contentDone.indexWhere((element) => element.cod == c.cod);

    DoneContent justDone = new DoneContent(
      cod: c.cod,
      type: c.type,
      stagenumber: c.stagenumber, 
      doneBy: this.coduser
    );
    
    if(c.isRecording() || c.isMeditation()  || c.isVideo()){
      if(c.isRecording()) setAction('recording', attribute: [c.title, c.description]);
    
      if(done != null && totalDuration != null && done.inSeconds >= totalDuration.inSeconds - 180){
        justDone.done = done;
        
        if(justDone.timesFinished == null){
          justDone.timesFinished = 0;
        }
        
        justDone.timesFinished += 1;

      }
    }

    if(index == -1){
      if(c.isLesson()){
        justDone.timesFinished = 1;
      }else if(done != null){
        justDone.done = done;
      }
      
      contentDone.add(justDone);

      return justDone;
    }else{
      if(c.isLesson()){
        justDone.timesFinished = contentDone[index].timesFinished + 1;
        contentDone[index] = justDone;
        return justDone;
      }else if(
        contentDone[index].done == null || 
        (
          contentDone[index].done != null && contentDone[index].done.inSeconds < done.inSeconds
         || (contentDone[index].timesFinished == null && justDone.timesFinished != null )
        )
      ){

        justDone.done = done;
        contentDone[index] = justDone;

        return justDone;
      }
    }

    return null;
  }



  //se puede refactorizar esto !!! COMPROBAR SI EL MODELO DE DATOS ESTÁ DE LA MEJOR FORMA
  bool takeMeditation(Meditation m,[DataBase d, bool offline = false, earlyFinish = false, bool onlyActions = false]) {
    
    if(!onlyActions){
      m.coduser = this.coduser;
      m.day = DateTime.now().subtract(m.duration);
      
      // esto en offline no funcionará 
      if(!earlyFinish && m.stagenumber != null && !totalMeditations.contains(m)){
        this.userProgression.meditposition[m.stagenumber-1]++;
      }

      this.totalMeditations.add(m);

      if (this.userStats.streak > 0 && this.userStats.lastmeditated != null) {
        final lastday = DateTime(
          this.userStats.lastmeditated.year, 
          this.userStats.lastmeditated.month, 
          this.userStats.lastmeditated.day + 1
        );

        //si meditamos ayer subimos la racha !
        if (lastday.day == m.day.day) {
          this.userStats.streakUp();
        } else if (this.userStats.lastmeditated.day != DateTime.now().day) {
          this.userStats.streak = 1;
        }
      } else {
        this.userStats.streakUp();
      }


      // ESTO EN EL MODO OFFLINE NO ESTÁ CLARO !!
      int auxstreak = checkStreak(false);

      if(auxstreak != this.userStats.streak && auxstreak > this.userStats.streak){
        this.userStats.streak = auxstreak;
      }


      this.userStats.meditate(m);

      getTimeMeditatedString();
      

      if(!offline && this.stagenumber == m.stagenumber){
        this.percentage = d.stages[this.stagenumber-1].checkPercentage(this);

        if (this.percentage >= 100) {
          this.userProgression.stageshown++;
        }
      }
    }

    if(m.title == null ){
      setAction('meditation', attribute: [m.duration.inMinutes]);
    }else{
      setAction("guided_meditation", attribute: [m.title, m.duration.inMinutes]);
    }

    //  PORQUE DEVOLVEMOS ALGO ???
    return false;
  }
  
}
// settings de cada profesor
class TeacherSettings {
  String description, website, location, teachinghours;

  List<User> students = new List.empty(growable: true);

  TeacherSettings({this.description,this.website,this.location,this.teachinghours});

  Map<String,dynamic> toJson(){
    return {
      'description':description,
      'website':website,
      'location':location,
      'teachinghours':teachinghours
    };
  }

  // HAY QUE SABER QUIEN ES QUIEN !!!
  factory TeacherSettings.fromJson(json){
    return TeacherSettings(
      description: json['description']!= null ? json['description']:'',
      website: json['website']!= null ? json['website']:'',
      location: json['location']!= null ? json['location']:'',
      teachinghours: json['teachinghours']!= null ? json['teachinghours']:'',
    );
  }
}


// WE NEED TO CREATE DIFFERENT CLASSES
class Teacher extends User {
  List<User> students = new List.empty(growable: true);
  List<Content> addedcontent =  new List.empty(growable:true);

}

// THE NORMAL USER
class Meditator extends User{

}


class Admin extends User {

}


class TeacherInfo{
  // INFORMACIÓN DEL PROFESOR !!!!
  String description, website, location, teachinghours;

  TeacherInfo({this.description,this.website,this.location,this.teachinghours});

  Map<String,dynamic> toJson(){
    return {
      'description':description,
      'website':website,
      'location':location,
      'teachinghours':teachinghours
    };
  }

  // fromJson
  factory TeacherInfo.fromJson(json){
    return TeacherInfo(
      description: json['description']!= null ? json['description']:'',
      website: json['website']!= null ? json['website']:'',
      location: json['location']!= null ? json['location']:'',
      teachinghours: json['teachinghours']!= null ? json['teachinghours']:'',
    );
  }

}

class UserProgression {
  // MÁXIMO 10 !!!
  List<int> lessonposition;
  List<int> meditposition;
  int gameposition;
  int stageshown = 1;

  UserProgression({this.lessonposition,this.meditposition,this.stageshown = 1, this.gameposition});


  // from json 
  factory UserProgression.fromJson(json){
    UserProgression u = new UserProgression(
      stageshown: json['stageShown'] != null ? json['stageShown'] : 
        json['stagelessonsnumber'] != null ? json['stagelessonsnumber'] :  
        1,
      gameposition: json['gamePosition'] != null ? json['gamePosition'] : 0
    );

    u.lessonposition = new List.filled(10, 0);
    u.meditposition = new List.filled(10, 0);


    if(json['lessonPosition'] !=  null){
      for(var i = 0; i < json['lessonPosition'].length; i++){
        u.lessonposition[i] =  json['lessonPosition'][i] is String ? int.parse(json['lessonPosition'][i]) : json['lessonPosition'][i];
      }
    }else if(json['position'] != null && json['stagenumber'] != null ){
      u.lessonposition[json['stagenumber']] = json['position'];
    }

    if(json['meditPosition'] !=  null){
      for(var i = 0; i < json['meditPosition'].length; i++){
        u.meditposition[i] = json['meditPosition'][i] is String ? int.parse(json['meditPosition'][i]) : json['meditPosition'][i];
      }
    }else if(json['meditposition'] != null && json['stagenumber'] != null){
      u.meditposition[json['stagenumber']] = json['meditposition'];
    } 

    return u;
  }


  // to json
  Map<String,dynamic> toJson(){
    return {
      'lessonPosition':lessonposition,
      'meditPosition':meditposition,
      'gamePosition':gameposition,
      'stageShown':stageshown
    };
  }
  
}