import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:mobx/mobx.dart';

import 'game_entity.dart';
import 'meditation_entity.dart';

class Stage {
  int stagenumber, userscount;
  String description, image, goals, obstacles, skills, mastery, longimage;
  ObservableList<Content> path = new ObservableList();
  ObservableList<Meditation> meditpath = new ObservableList();
  ObservableList<Game> games = new ObservableList();
  //hay que empezar a utilizar stobjectives!!
  StageObjectives stobjectives; 

  Stage(
      {@required this.stagenumber,
      this.description,
      @required this.image,
      this.longimage,
      this.goals,
      this.obstacles,
      this.skills,
      this.mastery,
      this.userscount,
      this.stobjectives});

  void addContent(Content c){
    if(c.type== 'meditation' || c.type =='lesson'){
      stobjectives.lecciones++;
      path.add(c);
      path.sort((a, b) => a.position - b.position);
    } else if(c.type =='meditation-practice') {
      stobjectives.meditguiadas++;
      meditpath.add(c);
      meditpath.sort((a, b) => a.position - b.position);
    }else {
      games.add(c);
    }
  }
}



///POR HACER !!!!!
class StageObjectives {
  int totaltime, streak, lecciones, meditguiadas, meditationcount, meditationfreetime;
  String freemeditationlabel;

  StageObjectives({this.totaltime,this.meditationcount,this.streak,this.lecciones,this.meditguiadas, this.meditationfreetime, this.freemeditationlabel});

  factory StageObjectives.fromJson(Map<String, dynamic> json) =>
    StageObjectives(
      totaltime: json['totaltime'] == null ? 0 : json['totaltime'],
      streak: json['racha'] == null ? 0 : json['racha'],
      meditationcount: json['meditation'] == null ? 0 : json['meditation']['count'],
      freemeditationlabel: json['meditation'] == null ? 0 : json['meditation']['count'].toString() + ' min meditations ',
      meditationfreetime: json['meditation'] == null ? 0 : json['meditation']['time'],
      meditguiadas: json['meditguiadas'] == null ? 0 : json['meditguiadas'],
      lecciones: json['lessons'] == null ? 0 : json['lessons']
    );  

  
  factory StageObjectives.empty() => 
  StageObjectives(
      totaltime: 0 ,
      streak: 0 ,
      meditationcount:  0,
      freemeditationlabel: '0 min',
      meditationfreetime:  0 ,
      meditguiadas:  0 ,
      lecciones: 0);
  

  Map<String, dynamic> toJson() => {
    "totaltime": totaltime == null ? null : totaltime,
    "streak": streak == null ? 0 : streak,
    'meditation': {'count': meditationcount, 'time': meditationfreetime},
    "meditguiadas": meditguiadas == null ? null : meditguiadas,
    "lecciones": lecciones == null ? [] : lecciones
  };

  Map<String,dynamic> getObjectives() {
    Map<String,dynamic> objectives = {};

    print(this);
    
    if(freemeditationlabel != null) {
      objectives ['meditation'] = freemeditationlabel;
    }

    if(totaltime != null) {
      objectives['totaltime'] = 'Total time';
    }

    if(streak != null){
      objectives['streak'] = 'Streak';
    }


    if(lecciones != null){
      objectives['lecciones'] = 'Lessons';
    }

    if(meditguiadas != null){
      objectives['meditguiadas'] = 'Guided meditations';
    }

    return objectives;
  }


  dynamic checkPassedObjective(int value, String objective){
     var labels = {
      'totaltime':totaltime,
      'streak':streak,
      'meditation':meditationcount,
      'meditguiadas':meditguiadas,
      'lecciones': lecciones
    };

    if(value >= labels[objective]){
      return true;
    }else{
      return value.toString() +'/' + labels[objective].toString();
    }
  }
}
