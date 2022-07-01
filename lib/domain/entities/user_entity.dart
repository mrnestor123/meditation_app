
import 'dart:io';

import 'package:meditation_app/domain/entities/message.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/notification_entity.dart';
import 'package:meditation_app/domain/entities/progress_entity.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/domain/entities/stats_entity.dart';
import 'package:meditation_app/domain/entities/user_settings_entity.dart';
import 'package:mobx/mobx.dart';
import 'package:uuid/uuid.dart';
import 'game_entity.dart';
import 'lesson_entity.dart';
import 'meditation_entity.dart';
import 'action_entity.dart';

//MIRAR DE REFACTORIZAR ESTA CLASE !!!!!
// HAY QUE CREAR SUBCLASES,
// TEACHER , ADMIN , MEDITATOR , BASEUSER = usuario del que no sacamos ninguna información
class User {
  String coduser, nombre, role, image, timemeditated, description, location, website, teachinghours;
  //USUARIO DE FIREBASE
  var user;
  int stagenumber, stagelessonsnumber, position, meditposition, gameposition, percentage, version;
  Stage stage;

  //follows es cuando un usuario TE SIGUE!!
  bool  followed, stageupdated, seenIntroCarousel;

  //para el modal de progreso
  Progress progress;
  UserSettings settings;

  //estadísticas
  UserStats userStats;

  List<User> students = new List.empty(growable: true);
  List<Content> addedcontent =  new List.empty(growable:true);

  List<dynamic> unreadmessages = new List.empty(growable: true);
  List<Message> messages = new List.empty(growable:true);

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

  //MIRAR DE QUITAR ESTAS LISTAS TAMBIEN
  final ObservableList<Meditation> totalMeditations = new ObservableList();
  //hacemos week meditations??? 

  //List with the lessons that the user has learned
  final ObservableList<dynamic> readlessons = new ObservableList();
  //HACE FALTA ESTO ???
  Map<dynamic,dynamic> answeredquestions = new Map();
  

  User({this.coduser, this.nombre, this.user, this.position = 0, 
        this.image, this.stagenumber = 1,this.stage, 
        this.role,this.meditposition= 0,this.userStats, this.followed,
        this.answeredquestions ,this.gameposition = 0, this.settings, this.version = 0,
        this.stagelessonsnumber = 1, this.unreadmessages,
        this.website,this.teachinghours,this.location,this.description, this.seenIntroCarousel = false
        }) {
          
    if(userStats != null){
      getTimeMeditatedString();
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
      
    // SE EJECUTA SIEMPRE
    inituser();
  }

  void checkStreak(){
     if(this.userStats != null && this.userStats.streak > 0 && this.userStats.lastmeditated != null){
      print('CHECKING streak');
      var lastmeditated = DateTime.parse(this.userStats.lastmeditated);
      var today = DateTime.now();
      print(lastmeditated.toIso8601String());
      if(lastmeditated.month != today.month || lastmeditated.day != today.day || lastmeditated.day != today.subtract(Duration(days: 1)).day){
        print('CHANGING STREAK');
        this.userStats.streak = 0;
      }
    } 
  }


  //Para comprobar que la racha de meditaciones funcione bien. En el futuro hará más cosas
  void inituser() {
   
    // SOLO LA COMPROBAMOS SI ERES EL USUARIO DE LA APP
    if(this.stage != null){
      setPercentage();
      checkStreak();
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
    return !this.settings.unlocksMeditation() && (meditation.position != null &&  this.meditposition < meditation.position &&  this.stagenumber == meditation.stagenumber || this.stagenumber < meditation.stagenumber);
  }

  bool isNormalProgression(){
    return settings.getProgression() == 'casual';
  }
  
  bool isGameBlocked(Game g){
    return this.gameposition < g.position;
  }

  bool isLessonBlocked(Lesson l){
    return !settings.unlocksLesson() && (this.position < l.position && this.stagelessonsnumber <= l.stagenumber );
  }

  bool isStageBlocked(Stage s){
    return !settings.unlocksLesson() && this.stagelessonsnumber < s.stagenumber;
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
    //SUBIRÍA LAS ACTIONS AQUI
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
  }

  void updateStage(DataBase data) {
    this.stagenumber +=1;    

    data.stages.forEach((element) {
      if (element.stagenumber == this.stagenumber) {
        this.stage = element;
      }
    });

    this.percentage = 0;
    if(this.stagenumber  > this.stagelessonsnumber){
      this.position = 0;
    }
    
    this.meditposition = 0;
    userStats.reset();

    if(this.readlessons != null && this.readlessons.length > 0){
      this.stage.path.where((l)=> l.stagenumber == this.stagenumber).toList().forEach((element) {
        if (this.readlessons.contains(element.cod)) {
          this.userStats.stage.lessons++;
        }
      });
    }

    this.stageupdated = true;

    this.progress = Progress(
      done: this.stagenumber,
      what: 'stage',
      stage: this.stage
    );

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


  //CAMBIAR LOS MAPS A CLASES !!!!
  void setPercentage() {
    Stage s = this.stage;

    var objectiveCheck = {
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
      this.percentage = 100;
    }
  }

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

  void takeLesson(Lesson l, [DataBase d]) {
    if(this.readlessons.where((element)=> l.cod == element).isEmpty){
      // EMPEZAR A UTILIZAR 
      if(l.stagenumber == this.stagenumber && this.userStats.stage.lessons < this.stage.stobjectives.lecciones){
        this.userStats.stage.lessons++;
        this.progress = Progress(
          done: this.userStats.stage.lessons,
          total: this.stage.stobjectives.lecciones, 
          what: ' Lessons'
        );

        setPercentage();
       
        if (this.percentage >= 100) {
          this.updateStage(d);
        }
      }

      // VAMOS A QUITAR ESTO !!!!!!!!!!
      // REVISAR QUE VA UNO DETRAS DE OTRO !!!
      if (this.stage.path.where((c) => c.position == this.position).length <= this.userStats.lastread.length + 1) {
        this.position += 1;
        this.userStats.lastread.clear();
      } else {
        this.userStats.lastread.add({'cod': l.cod});
      }

      this.readlessons.add(l.cod);


      bool updatestage = true;
     
      for(Lesson l in d.stages[l.stagenumber -1].path){
        if(!this.readlessons.contains(l.cod)){
          updatestage = false;
        }
      }
      
      if(updatestage){
        this.stagelessonsnumber++;
        this.position = 0;
      }

      this.userStats.takeLesson();
    }
  
    setAction('lesson', attribute: l.title);
  }

  void getTimeMeditatedString(){
    var time = this.userStats.total.timemeditated;

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
      if(hours > 1){
        timemeditated = hours.toString() + 'h';
      }else{
        int minutes = time % 60;
        timemeditated = minutes.toString() + 'm';
      }
    }
  }

  //se puede refactorizar esto !!! COMPROBAR SI EL MODELO DE DATOS ESTÁ DE LA MEJOR FORMA
  bool takeMeditation(Meditation m,[DataBase d]) {
    m.coduser = this.coduser;

    // HAY QUE QUITAR ESTO DE AQUI !!!
    if(m.day == null){
      m.day = DateTime.now();
    }

    if (m.title == null) {
      this.totalMeditations.add(m);
      if (
        this.stage.stobjectives.meditationfreetime != 0 && this.stage.stobjectives.meditationfreetime <= m.duration.inMinutes &&
        this.userStats.stage.timemeditations <   this.stage.stobjectives.meditationcount
        ) {
        this.userStats.stage.timemeditations++;
        this.progress = Progress(
          stage: this.stage,
          done: this.userStats.stage.timemeditations,
          total: this.stage.stobjectives.meditationcount, 
          what: this.stage.stobjectives.freemeditationlabel
        ); 
      }
    } else if (m.stagenumber != null && m.stagenumber == this.stagenumber && !totalMeditations.contains(m)) {
      this.userStats.stage.guidedmeditations++;
      this.meditposition++;
      totalMeditations.add(m);
      progress = Progress(
        stage: this.stage,
        done: this.userStats.stage.guidedmeditations,
        total: this.stage.stobjectives.meditguiadas, 
        what: ' guided meditations');
    }

    if (this.userStats.streak > 0 && this.userStats.lastmeditated != null) {
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

    getTimeMeditatedString();
  
    this.setPercentage();

    if (this.percentage >= 100) {
      this.updateStage(d);
    }

    if(m.title == null ){
      setAction('meditation', attribute: [m.duration.inMinutes]);
    }else{
      setAction("guided_meditation", attribute: [m.title, m.duration.inMinutes]);
    }
    

    return false;

    //minutesMeditated += m.duration.inMinutes;
    //setTimeMeditated();
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