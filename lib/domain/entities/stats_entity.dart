
/*
  for accessing user stats 
*/
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/presentation/pages/commonWidget/date_tostring.dart';

//Hacer un método para añadir a meditation time
//agrupa todas las estadísticas del usuario
class UserStats {
  List<DateTime> daysMeditated = new List.empty(growable: true);
  // LO PODEMOS VER CON ESTO ??
  DateTime lastmeditated;
  int streak, maxStreak, readLessons, doneMeditations, timeMeditated;
  int meditatedThisMonth, meditatedThisWeek;

  List<dynamic> lastread = new List.empty(growable: true);
  Map<String,dynamic> meditationtime;

  Map<String,dynamic> metricsPassed;
  
  UserStats({
    this.maxStreak,
    this.readLessons,
    this.doneMeditations,
    this.lastread,
    this.streak = 0,
    this.lastmeditated,
    this.meditationtime,
    this.timeMeditated,
    this.daysMeditated,
    this.meditatedThisMonth,
    this.meditatedThisWeek,
    this.metricsPassed 
  });
    
  factory UserStats.empty() => UserStats(
    maxStreak: 0,
    doneMeditations: 0,
    timeMeditated: 0,
    meditatedThisMonth: 0,
    meditatedThisWeek: 0,
    readLessons: 0,
    streak: 0,
    daysMeditated: [],
    metricsPassed: new Map(),
    lastread: new List.empty(growable: true),
  );

  factory UserStats.fromJson(Map<String, dynamic> json) =>
    UserStats(
      streak: json['streak'] != null ? json['streak'] :
      json['racha'] != null ? json['racha']: 0,
      
      meditationtime: json['meditationtime'] == null ? new Map() : json['meditationtime'],
      
      timeMeditated: json['timeMeditated'] !=  null 
        ? json['timeMeditated'] : 
        json['total'] != null && json['total']['tiempo'] != null 
        ? json['total']['tiempo'] : 0,

      readLessons: json['readLessons'] !=  null 
        ? json['readLessons'] : 
        json['total'] != null && json['total']['lecciones'] != null 
        ? json['total']['lecciones'] : 0,

      doneMeditations: json['doneMeditations'] !=  null 
        ? json['doneMeditations'] :
        json['total'] != null && json['total']['meditaciones'] != null
        ? json['total']['meditaciones'] : 0,

      maxStreak: json['maxStreak'] !=  null ? 
        json['maxStreak'] :
        json['total'] != null && json['total']['maxstreak'] != null
        ? json['total']['maxstreak'] : 0,

      lastmeditated: json['lastMeditated'] != null ?
        DateTime.parse(json['lastMeditated']):
        json['lastmeditated'] != null ? DateTime.parse(json['lastmeditated']) : 
        null,
        
      daysMeditated: json['daysMeditated'] != null ?
        (json['daysMeditated'] as List).map((i) => DateTime.parse(i)).toList() : 
        json['meditationTime'] != null  ? 
          (json['meditationTime'] as Map).keys.map((i) => DateTime.parse(i)).toList() : 
          [],

      lastread: json['lastRead'] != null ? json['lastRead'] : json['lastread'] == null ? [] : json['lastread'],
      meditatedThisMonth: json['meditatedThisMonth'] == null ? 0 : json['meditatedThisMonth'],

      meditatedThisWeek: json['meditatedThisWeek'] == null ? 0 : json['meditatedThisWeek'],
      metricsPassed: json['metricsPassed'] == null ? new Map() : json['metricsPassed']
    );  

  
  Map<String, dynamic> toJson() => {
    "streak": streak == null ? 0 : streak,
    "meditationtime": meditationtime == null ? null: meditationtime,
    "timeMeditated": timeMeditated == null ? 0 : timeMeditated,
    "readLessons": readLessons == null ? 0 : readLessons,
    "doneMeditations": doneMeditations == null ? 0 : doneMeditations,
    "maxStreak": maxStreak == null ? 0 : maxStreak,
    "meditatedThisMonth": meditatedThisMonth == null ? 0 : meditatedThisMonth,
    "meditatedThisWeek": meditatedThisWeek == null ? 0 : meditatedThisWeek,
    "lastMeditated": lastmeditated == null ? null : datetoString(lastmeditated),
    "metricsPassed": metricsPassed == null ? new Map() : metricsPassed,
    "lastRead": lastread == null ? [] : lastread
  };

  void takeLesson() => this.readLessons++;

  void streakUp(){
    this.streak++;

    if(this.maxStreak <  this.streak){
      this.maxStreak = this.streak;
    }
  }

  void meditate(Meditation m){
    
    this.doneMeditations++;
    this.timeMeditated += m.duration.inMinutes;

    if(this.lastmeditated != null && this.lastmeditated.isBefore(firstDayMonth(DateTime.now()))){
      this.meditatedThisMonth = 0;
    }

    this.meditatedThisMonth +=m.duration.inMinutes;

    this.lastmeditated = m.day;    
    

  }

  void reset() {
    this.lastread.clear();
  }
}

//timemeditations son meditaciones por encima de x tiempo establecido
class Stats{
  int timemeditated, lessons, maxstreak, guidedmeditations, timemeditations;

  Stats({this.timemeditated,this.lessons,this.maxstreak,this.guidedmeditations,this.timemeditations});
}



class MetricsPassed {
  int total, passed;

  MetricsPassed({this.total, this.passed});

  factory MetricsPassed.fromJson(Map<String, dynamic> json) => MetricsPassed(
    total: json['total'],
    passed: json['passed']
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "passed": passed
  };

}


