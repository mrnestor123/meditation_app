
/*
  for accessing user stats 
*/
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
      stage: json['etapa'] == null ? null : StageStats.fromJson(json['etapa']),
      total: json['total'] == null ? null : TotalStats.fromJson(json['total']),
      streak: json['racha'] == null ? 0 : json['racha'],
      meditationtime: json['meditationtime'] == null ? null : json['meditationtime'],
      lastmeditated: json['lastmeditated'] == null ? null : json['lastmeditated'],
      lastread: json['lastread'] == null ? null : json['lastread']
    );  

  Map<String, dynamic> toJson() => {
    "stage": stage == null ? null : stage.toJson(),
    "total": total == null ? null : total.toJson(),
    "streak": streak == null ? 0 : streak,
    "meditationtime": meditationtime== null ? null: meditationtime,
    "lastmeditated": lastmeditated == null ? null : lastmeditated,
    "lastread": lastread == null ? [] : lastread
  };
}

//timemeditations son meditaciones por encima de x tiempo establecido
class Stats{
  int timemeditated, lessons, maxstreak, guidedmeditations, timemeditations;

  Stats({this.timemeditated,this.lessons,this.maxstreak,this.guidedmeditations,this.timemeditations});

}

//estadísticas de la etapa y estadísticas del total !!! PARA HACER
class StageStats extends Stats{
    int timemeditated, lessons, maxstreak, guidedmeditations, timemeditations;

    StageStats({this.timemeditated,this.lessons,this.maxstreak,this.guidedmeditations,this.timemeditations}) : 
    super(timemeditated:timemeditated, lessons: lessons, maxstreak: maxstreak, guidedmeditations: guidedmeditations, timemeditations: timemeditations );

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
      "lessons":lessons == null ? null : lessons,
      "timemeditated":timemeditated == null ? null : timemeditated
    };    
}

class TotalStats extends Stats{
  int timemeditated, lessons, maxstreak, guidedmeditations;


  TotalStats({this.timemeditated,this.lessons,this.maxstreak,this.guidedmeditations}) : 
  super(timemeditated:timemeditated, lessons: lessons, maxstreak: maxstreak, guidedmeditations: guidedmeditations);



  factory TotalStats.fromJson(Map<String, dynamic> json) =>
    TotalStats(
        timemeditated: json["tiempo"] == null ? null : json["tiempo"],
        lessons: json['lecciones'] == null ? null : json['lecciones'],
        maxstreak: json['maxstreak'] == null ? null : json['maxstreak'],
        guidedmeditations: json['meditguiadas'] == null ? null : json['meditguiadas']
    );
  

  Map<String, dynamic> toJson() => {
    "meditguiadas": guidedmeditations == null ? null : guidedmeditations,
    "maxstreak": maxstreak == null ? null : maxstreak,
    "lessons":lessons == null ? null : lessons,
    "timemeditated":timemeditated == null ? null : timemeditated
  };
}