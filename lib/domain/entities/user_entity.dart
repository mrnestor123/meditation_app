
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
class User {
  String coduser, nombre, role, image, timemeditated;
  //USUARIO DE FIREBASE
  var user;
  int stagenumber, position, meditposition, gameposition, percentage;
  Stage stage;
  //follows es cuando un usuario TE SIGUE!!
  bool classic, followed, stageupdated;

  //para el modal de progreso
  Progress progress;

  UserSettings settings;
  


  //estadísticas
  UserStats userStats;

  //passed objectives también deberia estar en stats
  Map<String, dynamic> passedObjectives = new Map();

  // HAY MUCHAS LISTAS !!! :( MIRAR DE REFACTORIZAR ESTO !!!
  List<UserAction> todayactions = new ObservableList();
  List<UserAction> thisweekactions = new ObservableList() ;
  List<UserAction> lastactions = new ObservableList();

  //LISTA DE CÓDIGOS DE USUARIOS
  List<dynamic> following = new List.empty(growable: true);
  List<dynamic> followers = new List.empty(growable: true);

  List<Notify> notifications = new List.empty(growable:true);

  //MIRAR DE QUITAR ESTAS LISTAS TAMBIEN
  final ObservableList<Meditation> totalMeditations = new ObservableList();
  //hacemos week meditations??? 

  //List with the lessons that the user has learned
  final ObservableList<Lesson> lessonslearned = new ObservableList();
  //HACE FALTA ESTO ???
  Map<dynamic,dynamic> answeredquestions = new Map();

  User({this.coduser, this.nombre, this.user, this.position = 0, 
        this.image, this.stagenumber = 1,this.stage, 
        this.role,this.classic = false,this.meditposition= 0,this.userStats, this.followed,
        this.answeredquestions,this.gameposition = 0, this.settings}) {
   
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
        //userStats.streak = 0;
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

  //En el futuro sería  si contains la lista de lessons
  //returns if user has read a lesson
  bool readLesson(Content  c){
    return c.position < this.position || 
    c.stagenumber < this.stagenumber || 
    this.userStats.lastread != null && this.userStats.lastread.where((d) => d['cod'] == c.cod).length > 0;
  }

  bool isBlocked(Meditation meditation){
    return !this.settings.unlocksMeditation() && (this.meditposition < meditation.position &&  this.stagenumber == meditation.stagenumber || this.stagenumber < meditation.stagenumber);
  }
  
  bool isGameBlocked(Game g){
    return this.gameposition < g.position;
  }

  bool isLessonBlocked(Lesson l){
    return !settings.unlocksLesson() || (this.position < l.position && this.stagenumber <= l.stagenumber );
  }

  bool isStageBlocked(Stage s){
    return !settings.unlocksLesson() && this.stagenumber < s.stagenumber;
  }


  bool isAdmin(){
    return this.role == 'admin';
  }

  //how much up to 6 the user has passed the lessons
  int lessonsPercentage(){
    if(this.userStats == 0){
      return 0;
    }else{
      return ((this.userStats.stage.lessons / this.stage.stobjectives.lecciones)*6).round();
    }
  }


  //ESTOS METODOS SON BUENOS ?????
  void setAction(String type, {dynamic attribute}) {
    UserAction a = new UserAction(type: type, action: attribute, username: this.nombre, time: DateTime.now().toLocal(), coduser: this.coduser);
    a.userimage = this.image;

    //MIRAR QUE TYPES SON LOS QUE SE RECUPERAN FOLLOW Y UNFOLLOW ?
    /*if(this.todayactions.length > 0 && type != 'meditation' && type != 'lesson' && type != 'updatestage' &&  type !='guided_meditation'){
      for(UserAction a in this.todayactions) {
        if(a.time.difference(DateTime.now()).inMinutes < 30 && type == a.type){
          a.setAction(attribute);
          a.userimage = this.image;
          a.time = DateTime.now().toLocal();
          return;
        }
      }
      this.todayactions.add(a);
    }else{*/
      this.todayactions.add(a);
    /*}*/
    
    this.lastactions.add(a);

    //this.thisweekactions.add(a);
  }
  
  void setActions(json, isToday) {
    for(var action in json){ 
      if(action['userimage'] == null){
        action['userimage'] = this.image;
      }
      //action['userimage'] = this.image;
      if(isToday) {
        todayactions.add(UserAction.fromJson(action));
      }else{
        thisweekactions.add(UserAction.fromJson(action));   
      }
    }
  }

  
  void follow(User u) {
    u.followed = true;

    if(!following.contains(u.coduser)){
      // QUE la accion de seguir solo notifique a los que les han seguido!!
      //setAction("follow", attribute: [u.nombre != null ? u.nombre : 'Anónimo']);
      following.add(u.coduser);
    }

    u.followers.add(this.coduser);
  }

  void unfollow(User u) {   
    u.followed = false;

    if(following.contains(u.coduser)){
     // setAction("unfollow", attribute: [u.nombre != null ? u.nombre : 'Anónimo']);
      following.remove(u.coduser);
    }

    if(u.followers.contains(this.coduser)){
      u.followers.remove(this.coduser);
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
    this.position = 0;
    this.meditposition = 0;
    userStats.reset();
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

    var objectives =  s.stobjectives.getObjectives();
    if(objectives.length > 0){
      passedObjectives = new Map();

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
    }else{
      this.percentage = 100;
    }
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
        this.progress = Progress(
          done: this.userStats.stage.timemeditations,
          total: this.stage.stobjectives.meditationcount, 
          what: this.stage.stobjectives.freemeditationlabel
        ); 
      }
      setAction('meditation', attribute: [m.duration.inMinutes]);
    } else {
      //no se si esto funcionará bien
      if (!totalMeditations.contains(m)) {
        this.userStats.stage.guidedmeditations++;
        this.meditposition++;
        totalMeditations.add(m);
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
