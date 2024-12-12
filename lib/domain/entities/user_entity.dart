import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/milestone_entity.dart';
import 'package:meditation_app/domain/entities/notification_entity.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/domain/entities/stats_entity.dart';
import 'package:meditation_app/domain/entities/user_settings_entity.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';
import 'meditation_entity.dart';
import 'action_entity.dart';

// MIRAR DE REFACTORIZAR ESTA CLASE !!!!!
// HAY QUE CREAR SUBCLASES,
// TEACHER , ADMIN , MEDITATOR , BASEUSER = usuario del que no sacamos ninguna información

class User {
  String coduser, nombre, role, image, timemeditated, email, timeMeditatedMonth;

  //USUARIO DE FIREBASE
  var user;
  int stagenumber, percentage, version, milestonenumber;


  Stage stage;
  TeacherInfo teacherInfo;
  TeacherSettings teacherSettings;

  Milestone milestone;
  UserProgression userProgression;
  UserSettings settings;
  //estadísticas
  UserStats userStats;

  //follows es cuando un usuario TE SIGUE!!
  bool offline, stageupdated;

  List<Content> addedcontent = new List.empty(growable:true);
  List<Section> addedsections = new List.empty(growable:true);

  // HAY MUCHAS LISTAS !!! :( MIRAR DE REFACTORIZAR ESTO !!!
  // LAS ACCIONES LAS AÑADIMOS  ??
  List<UserAction> actions = new ObservableList();
  List<UserAction> actionsToUpload = new ObservableList();

  //LISTA DE CÓDIGOS DE USUARIOS
  List<Notify> notifications = new List.empty(growable:true);
  List<MeditationPreset> presets = new List.empty(growable:true);
  List<DoneContent> contentDone =  new List.empty(growable:true);

  // MIRAR DE QUITAR ESTAS LISTAS TAMBIEN
  final ObservableList<Meditation> totalMeditations = new ObservableList();
  //hacemos week meditations??? 

  //HACE FALTA ESTO ???
  Map<dynamic,dynamic> answeredquestions = new Map();
  
  User({
    this.coduser, this.nombre, this.user,  
    this.image, this.stagenumber = 1,this.stage, 
    this.role, this.userStats, this.offline = false,
    this.answeredquestions , this.settings, 
    this.teacherInfo, this.userProgression,
    this.email, this.milestonenumber
  }) {
      
    if(userStats != null){
      timemeditated  = getTimeMeditatedString(
        time: this.userStats.timeMeditated != null ? this.userStats.timeMeditated : 0
      );
      timeMeditatedMonth = getTimeMeditatedString(
        time: this.userStats.meditatedThisMonth != null  ? this.userStats.meditatedThisMonth : 0
      );

    } else {
      this.userStats = UserStats.empty();
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

    if(milestonenumber == null){
      milestonenumber = 0;    
    }

  }

  int checkStreak(){
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

      return streak;
    } 
  }

  //Para comprobar que la racha de meditaciones funcione bien. En el futuro hará más cosas
  void inituser({bool checkingStreak = false}) {
    // SOLO LA COMPROBAMOS SI ERES EL USUARIO DE LA APP ??
    if(this.stage != null && this.userStats.streak > 0 || checkingStreak){
      //setPercentage();
      this.userStats.streak = checkStreak();

      //checkStage();
    }
  }

  void checkStage({Stage stage}){
    if(this.stage != null){
      if(stage.checkPercentage(this) >= 100 && this.stagenumber == stage.stagenumber){
        this.stagenumber++;
      }
    }
  }
  /* 
    @override List<Object> get props => [coduser, nombre, mail, usuario, password, stagenumber];
  */

  //HAY QUE QUITAR COSAS DE AQUÍII!!!!!
  int getStageNumber() => this.stagenumber;

  //checks if user answered the question
  bool answeredGame(String cod) => this.answeredquestions.length > 0 && this.answeredquestions[cod] != null;
  

  bool isBlocked(Meditation meditation){
    return !this.settings.unlocksMeditation() && 
    (
      meditation.position != null &&  
      this.userProgression.meditposition[meditation.stagenumber] < meditation.position &&  
      this.stagenumber <= meditation.stagenumber 
    );
  }

  bool isNormalProgression()=> settings.getProgression() == 'casual';
  
  bool isGameBlocked(Game g) =>  this.userProgression.gameposition < g.position;
  
  bool isLessonBlocked(Content l){
    return !settings.unlocksLesson() 
    && (
      this.userProgression.lessonposition[l.stagenumber] < l.position 
      && this.userProgression.stageshown <= l.stagenumber 
    );
  }

  bool isStageBlocked(Stage s) => s.blocked;

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

  bool isAdmin()=> this.role == 'admin';
  bool isTeacher() => this.role =='teacher';
  void setVersion(int version) => this.version = version;
  void setImage(String image) => this.image = image;

  void setMilestone(Milestone m) => this.milestone = m;

  //ESTOS METODOS SON BUENOS ?????
  void setAction(String type, {dynamic attribute}) {
    UserAction a = new UserAction(type: type, action: attribute, username: this.nombre, time: DateTime.now().toLocal(), coduser: this.coduser);
    a.userimage = this.image;
    a.user = this;

    actions.add(a);
    actionsToUpload.add(a);

    
    // YO HARÍA ALGO AQUÍ !!!!!!
    // SUBIRÍA LAS ACTIONS AQUI
    // ????
  }
  

  void setActions(json, isToday) {
    for(var action in json){ 
      if(action['userimage'] == null){
        action['userimage'] = this.image;
      }

      actions.add(UserAction.fromJson(action));

    }
  }


  // CAMBIAR LOS MAPS A CLASES !!!!
  // HACER ESTO MÁS SENCILLO !!!
  void checkMileStone({Milestone milestone}) {
    int passedCount = 0;
    int totalCount = 0;

    for(Objective o in milestone.objectives){
      if(o.type == 'streak'){
        o.completed = this.userStats.maxStreak;
      } else if(o.type == 'reportMetric' || o.type == 'timeMetric'){
        o.completed = this.userStats.metricsPassed[o.name] != null ? this.userStats.metricsPassed[o.name] : 0;
      }else if(o.type == 'totaltime'){
        // TIME MEDITATED SON MINUTOS !!
        o.completed = this.userStats.timeMeditated;
      }

      if(o.completed == null){ 
        o.completed = 0;
      }

      passedCount += o.completed;
      totalCount += o.toComplete;
    }

    milestone.passedPercentage = passedCount == 0 && totalCount == 0 ? 0 : (passedCount / totalCount * 100).round();

    if(milestone.passedPercentage >= 100){
      // ESTO NO FUNCIONARÁ CUANDO SE PASE A SERVER
      this.milestonenumber += 1;
    }
  }

  // CUANDO UN USUARIO TERMINA UN CONTENIDO !!!
  void takeLesson(Content l, [DataBase d]) {
    // HAY QUE AÑADIR  LAS READLESSONS A DONECONTENT !!!
    if(l.stagenumber != null) {
      if(this.contentDone.where((element)=> l.cod == element.cod && element.timesFinished != null).isEmpty){

        this.userProgression.lessonposition[l.stagenumber] += 1;
        this.userStats.lastread.clear();
        this.userStats.takeLesson();
      
      }
    }

    setAction(l.isVideo() ? 'video':'lesson', attribute: l.title);
  }



  String getTimeMeditatedString({int time}){
    // SE PUEDE SACAR DEL TOTAL DE  MEDITACIONES
    var t = time != null ?  time  : this.userStats.timeMeditated  != null ? this.userStats.timeMeditated : 0;
    int hours = t ~/ 60; 
    String timemeditated ='';

    if(hours > 24){
      print('HOURS: $hours');

      int days = hours ~/ 24;
      int remaininghours = hours % 24;

      if(days > 7){
        int weeks = days ~/ 7;
        int remainingdays = days%7;
        
        timemeditated = weeks.toString() + 'w ' +  remainingdays.toString() + 'd';
      }else{
        timemeditated = days.toString() + 'd ' + remaininghours.toString() + 'h';
      }
    } else {
      if(hours >= 1){
        timemeditated = hours.toString() + 'h';
      } else {
        int minutes = t % 60;
        timemeditated = minutes.toString() + 'm';
      }
    }
    return timemeditated;
  }

  
  // cambiar content por recording !!
  // LO AÑADE  A LA LISTA DE CONTENTDONE !!
  // ESTO FUERA????
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
  // hay que hacer esta función más sencilla !!!
  bool takeMeditation(Meditation m,[DataBase d, bool offline = false, earlyFinish = false, bool onlyActions = false]) {
    
    // PORQUE HAY ONLYACTIONS, ES  NECESARIO ???
    if(!onlyActions){
      m.coduser = this.coduser;
      m.day = DateTime.now().subtract(m.duration);
      
      // esto en offline no funcionará 
      if(!earlyFinish && m.stagenumber != null && !totalMeditations.contains(m)){
        
        int currentposition = this.userProgression.meditposition[m.stagenumber];

        if(m.position == null || currentposition == m.position){
          this.userProgression.meditposition[m.stagenumber] += 1;
        }
      }

      // check if user has meditated this month and then add to his time
      if(this.userStats.lastmeditated != null && this.userStats.lastmeditated.month == DateTime.now().month){
        this.userStats.meditatedThisMonth += m.duration.inMinutes;
      } else {
        this.userStats.meditatedThisMonth = m.duration.inMinutes;
      }

      // check if user has meditated this week and then add to his time
      DateTime monday = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1 ));

      if(this.userStats.lastmeditated != null && this.userStats.lastmeditated.isAfter(monday)){
        this.userStats.meditatedThisWeek += m.duration.inMinutes;
      } else {
        this.userStats.meditatedThisWeek = m.duration.inMinutes;
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
      // RECHEQUEAMOS LA RACHA, POR SI FALLA !!
      int auxstreak = checkStreak();

      if(auxstreak != this.userStats.streak && auxstreak > this.userStats.streak){
        this.userStats.streak = auxstreak;
      }

      this.userStats.meditate(m);
      timemeditated = getTimeMeditatedString();
      timeMeditatedMonth = getTimeMeditatedString(time: this.userStats.meditatedThisMonth);

      // PARA MOSTRAR OTRA ETAPA AL USUARIO !!
      if(!offline && this.stagenumber == m.stagenumber){
        this.percentage = d.stages.firstWhere((element) => element.stagenumber == this.stagenumber).checkPercentage(this);

        if (this.percentage >= 100) {
          this.userProgression.stageshown++;
        }
      }

      // we check milestone objectives
      if(!offline){
        for(Objective o in milestone.objectives){
          if(o.type == 'timeMetric' && o.metricValue <= m.duration.inMinutes){
            if(this.userStats.metricsPassed[o.name] == null){
              this.userStats.metricsPassed[o.name] = 0;
            }

            this.userStats.metricsPassed[o.name] += 1;
          }
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













class TeacherInfo {
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

    u.lessonposition = new List.filled(11, 0);
    u.meditposition = new List.filled(11, 0);


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