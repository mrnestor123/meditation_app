
/*
  for accessing user stats 
*/
import 'package:meditation_app/domain/entities/meditation_entity.dart';

import 'lesson_entity.dart';

//Hacer un método para añadir a meditation time
//agrupa todas las estadísticas del usuario
class UserStats {
  StageStats stage;
  TotalStats total;
  List<dynamic> lastread = new List.empty(growable: true);
  int streak;
  String lastmeditated;
  Map<String,dynamic> meditationtime;

  UserStats({this.stage,this.total,this.lastread,this.streak,this.lastmeditated,this.meditationtime});
    
  factory UserStats.empty() => UserStats(
     stage: StageStats.empty(),
     total: TotalStats.empty() ,
     streak: 0,
     meditationtime:  new Map(),
    );

  factory UserStats.fromJson(Map<String, dynamic> json) =>
    UserStats(
      stage: json['etapa'] == null ? StageStats.empty() : StageStats.fromJson(json['etapa']),
      total: json['total'] == null ? TotalStats.empty() : TotalStats.fromJson(json['total']),
      streak: json['racha'] == null ? 0 : json['racha'],
      meditationtime: json['meditationtime'] == null ? new Map() : json['meditationtime'],
      lastmeditated: json['lastmeditated'] == null ? null : json['lastmeditated'],
      lastread: json['lastread'] == null ? [] : json['lastread']
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

    if (this.total.maxstreak < this.streak) {
      this.total.maxstreak = this.streak;
    }
  }

  void meditate(Meditation m){
    //debería de ser una string ????
    this.lastmeditated = m.day != null ? m.day.toIso8601String() : DateTime.now().toIso8601String();    
    this.stage.timemeditated += m.duration.inMinutes;
    this.total.timemeditated += m.duration.inMinutes;
    this.total.meditations++;

    if (this.meditationtime.isNotEmpty && this.meditationtime[m.day.day.toString() + '-' + m.day.month.toString()] != null) {
      this.meditationtime[m.day.day.toString() + '-' + m.day.month.toString()] += m.duration.inMinutes;
    } else {
      this.meditationtime[m.day.day.toString() + '-' + m.day.month.toString()] =  m.duration.inMinutes;
    }
  }

  void reset() {
    this.stage.timemeditated = 0;
    this.stage.lessons = 0;
    this.stage.maxstreak = 0;
    this.stage.guidedmeditations = 0;
    this.stage.timemeditations = 0;
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