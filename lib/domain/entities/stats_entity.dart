
/*
  for accessing user stats 
*/
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/presentation/pages/commonWidget/date_tostring.dart';

import 'lesson_entity.dart';

//Hacer un método para añadir a meditation time
//agrupa todas las estadísticas del usuario
class UserStats {
  List<DateTime> daysMeditated = new List.empty(growable: true);
  DateTime lastmeditated;
  int streak, maxStreak, readLessons, doneMeditations, timeMeditated;

  List<dynamic> lastread = new List.empty(growable: true);
  // ESTO DEBERIA DE SER UNA FECHA !!!!!!
 // DateTime lastmeditated;
  Map<String,dynamic> meditationtime;
  
  UserStats({
    this.maxStreak,
    this.readLessons,
    this.doneMeditations,
    this.lastread,
    this.streak,
    this.lastmeditated,
    this.meditationtime,
    this.timeMeditated,
    this.daysMeditated
  });
    
  factory UserStats.empty() => UserStats(
     maxStreak: 0,
     doneMeditations: 0,
     timeMeditated: 0,
     readLessons: 0,
     streak: 0,
     daysMeditated: [],
     lastread: new List.empty(growable: true),
    );

  factory UserStats.fromJson(Map<String, dynamic> json) =>
    UserStats(
      streak: json['racha'] == null ? json['streak'] != null ? json['streak']: 0 : json['racha'],
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

      lastmeditated: json['lastmeditated'] == null ? null : 
        DateTime.parse(json['lastmeditated']),
        
      daysMeditated: json['daysMeditated'] != null ?
        (json['daysMeditated'] as List).map((i) => DateTime.parse(i)).toList() : 
        json['meditationTime'] != null  ? 
          (json['meditationTime'] as Map).keys.map((i) => DateTime.parse(i)).toList() : 
          [],

      lastread: json['lastread'] == null ? [] : json['lastread']
      
    );  

  Map<String, dynamic> toJson() => {
    "streak": streak == null ? 0 : streak,
    "meditationtime": meditationtime == null ? null: meditationtime,
    "timeMeditated": timeMeditated == null ? 0 : timeMeditated,
    "readLessons": readLessons == null ? 0 : readLessons,
    "doneMeditations": doneMeditations == null ? 0 : doneMeditations,
    "maxStreak": maxStreak == null ? 0 : maxStreak,
    //"daysMeditated": daysMeditated == null ? [] : daysMeditated.map((i) => datetoString(i)).toList(),
    "lastmeditated": lastmeditated == null ? null : datetoString(lastmeditated),
    "lastread": lastread == null ? [] : lastread
  };

  void takeLesson(){
    this.readLessons++;
  }

  void streakUp(){
    this.streak++;

    if(this.maxStreak <  this.streak){
      this.maxStreak = this.streak;
    }
  }

  void meditate(Meditation m){
    this.lastmeditated = m.day;    
    this.doneMeditations++;
    this.timeMeditated += m.duration.inMinutes;

    //this.daysMeditated.add(DateTime.parse(datetoString(m.day)));
    // CREO QUE ESTO NO HACE FALTA !!!!!
    

    /*if (this.meditationtime.isNotEmpty && this.meditationtime[m.day.day.toString() + '-' + m.day.month.toString()] != null) {
      this.meditationtime[m.day.day.toString() + '-' + m.day.month.toString()] += m.duration.inMinutes;
    } else {
      this.meditationtime[m.day.day.toString() + '-' + m.day.month.toString()] = m.duration.inMinutes;
    }*/
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

//estas dos deberían extender stats!!! lo quite!! hay que volverlo a meter
class StageStats {
    int timemeditated, lessons, maxstreak, guidedmeditations, timemeditations;

    StageStats({this.timemeditated,this.lessons,this.maxstreak,this.guidedmeditations,this.timemeditations});

    factory StageStats.empty() => 
      StageStats(
        timemeditated:0,
        lessons: 0,
        maxstreak:0,
        guidedmeditations: 0,
        timemeditations: 0
      );


    factory StageStats.fromJson(Map<String, dynamic> json) =>
      StageStats(
        timemeditated: json["tiempo"] == null ? 0 : json["tiempo"],
        lessons: json['lecciones'] == null ? 0 : json['lecciones'],
        maxstreak: json['maxstreak'] == null ? 0 : json['maxstreak'],
        guidedmeditations: json['meditguiadas'] == 0 ? 0 : json['meditguiadas'],
        timemeditations: json['medittiempo'] == 0 ? 0 : json['medittiempo']
      );
  

    Map<String, dynamic> toJson() => {
      "meditguiadas": guidedmeditations == null ? 0 : guidedmeditations,
      "medittiempo": timemeditations == null ? 0 : timemeditations,
      "maxstreak": maxstreak == null ? 0 : maxstreak,
      "lecciones": lessons == null ? 0 : lessons,
      "tiempo": timemeditated == null ? 0 : timemeditated
    };    

    
}

class TotalStats{
  int timemeditated, lessons, maxstreak, meditations;

  TotalStats({this.timemeditated,this.lessons,this.maxstreak,this.meditations});

  factory TotalStats.empty() => 
    TotalStats(
      timemeditated:0,
      lessons: 0,
      maxstreak:0,
      meditations: 0
    );


  factory TotalStats.fromJson(Map<String, dynamic> json) =>
    TotalStats(
        timemeditated: json["tiempo"] == null ? 0 : json["tiempo"],
        lessons: json['lecciones'] == null ? 0 : json['lecciones'],
        maxstreak: json['maxstreak'] == null ? 0 : json['maxstreak'],
        meditations: json['meditaciones'] == null ? 0 : json['meditaciones']
    );
  
  Map<String, dynamic> toJson() => {
    "meditaciones": meditations == null ? 0 : meditations,
    "maxstreak": maxstreak == null ? 0 : maxstreak,
    "lecciones": lessons == null ? 0 : lessons,
    "tiempo": timemeditated == null ? 0 : timemeditated
  };
}