
/*
  for accessing user stats 
*/
import 'package:meditation_app/domain/entities/meditation_entity.dart';

import 'lesson_entity.dart';

//Hacer un método para añadir a meditation time
//agrupa todas las estadísticas del usuario
class UserStats{
  StageStats stage;
  TotalStats total;
  List<dynamic> lastread;
  int streak;
  String lastmeditated;
  Map<String,dynamic> meditationtime;

  UserStats({this.stage,this.total,this.lastread,this.streak,this.lastmeditated,this.meditationtime});
    
  factory UserStats.fromJson(Map<String, dynamic> json) =>
    UserStats(
      stage: json['etapa'] == null ? StageStats.empty() : StageStats.fromJson(json['etapa']),
      total: json['total'] == null ? TotalStats.empty() : TotalStats.fromJson(json['total']),
      streak: json['racha'] == null ? 0 : json['racha'],
      meditationtime: json['meditationtime'] == null ? null : json['meditationtime'],
      lastmeditated: json['lastmeditated'] == null ? null : json['lastmeditated'],
      lastread: json['lastread'] == null ? null : json['lastread']
    );  

  Map<String, dynamic> toJson() => {
    "etapa": stage == null ? null : stage.toJson(),
    "total": total == null ? null : total.toJson(),
    "racha": streak == null ? 0 : streak,
    "meditationtime": meditationtime == null ? null: meditationtime,
    "lastmeditated": lastmeditated == null ? null : lastmeditated,
    "lastread": lastread == null ? [] : lastread
  };

  void takeLesson(){
    this.stage.lessons++;
    this.total.lessons++;
  }

  void streakUp(){
    this.streak++;
    if (this.stage.maxstreak < this.streak) {
      this.stage.maxstreak = this.streak;
    }

    if (this.total.maxstreak < this.total.maxstreak) {
      this.total.maxstreak = this.streak;
    }
  }

  void meditate(Meditation m){
    this.lastmeditated = DateTime.now().toIso8601String();    
    this.stage.timemeditated += m.duration.inMinutes;
    this.total.timemeditated += m.duration.inMinutes;
    this.total.meditations++;

    if (this.meditationtime.isNotEmpty && this.meditationtime[m.day.day.toString() + '-' + m.day.month.toString()] == null) {
      this.meditationtime[m.day.day.toString() + '-' + m.day.month.toString()] = m.duration.inMinutes;
    } else {
      this.meditationtime[m.day.day.toString() + '-' + m.day.month.toString()] +=  m.duration.inMinutes;
    }
  }

}

//timemeditations son meditaciones por encima de x tiempo establecido
class Stats{
  int timemeditated, lessons, maxstreak, guidedmeditations, timemeditations;

  Stats({this.timemeditated,this.lessons,this.maxstreak,this.guidedmeditations,this.timemeditations});
}

//estadísticas de la etapa y estadísticas del total !!! PARA HACER
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
        timemeditated: json["tiempo"] == null ? null : json["tiempo"],
        lessons: json['lecciones'] == null ? null : json['lecciones'],
        maxstreak: json['maxstreak'] == null ? null : json['maxstreak'],
        guidedmeditations: json['meditguiadas'] == null ? null : json['meditguiadas'],
        timemeditations: json['medittiempo'] == null ? null : json['medittiempo']
      );
  

    Map<String, dynamic> toJson() => {
      "meditguiadas": guidedmeditations == null ? null : guidedmeditations,
      "medittiempo": timemeditations == null ? null : timemeditations,
      "maxstreak": maxstreak == null ? null : maxstreak,
      "lecciones": lessons == null ? null : lessons,
      "tiempo": timemeditated == null ? null : timemeditated
    };    

    void reset() {
      timemeditated = 0;
      lessons = 0;
      maxstreak = 0;
      guidedmeditations = 0;
      timemeditations = 0;
    }
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
        timemeditated: json["tiempo"] == null ? null : json["tiempo"],
        lessons: json['lecciones'] == null ? null : json['lecciones'],
        maxstreak: json['maxstreak'] == null ? null : json['maxstreak'],
        meditations: json['meditaciones'] == null ? null : json['meditaciones']
    );
  
  Map<String, dynamic> toJson() => {
    "meditaciones": meditations == null ? null : meditations,
    "maxstreak": maxstreak == null ? null : maxstreak,
    "lecciones": lessons == null ? null : lessons,
    "tiempo": timemeditated == null ? null : timemeditated
  };
}