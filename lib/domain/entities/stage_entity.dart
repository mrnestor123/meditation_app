import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/lesson_entity.dart';
import 'package:mobx/mobx.dart';

import 'game_entity.dart';
import 'meditation_entity.dart';

class Stage {
  int stagenumber, userscount;
  String description, image, goals, obstacles, skills, mastery, longimage,  shortimage, shorttext, longdescription;
  ObservableList<Content> path = new ObservableList();
  ObservableList<Meditation> meditpath = new ObservableList();
  ObservableList<Game> games = new ObservableList();
  //hay que empezar a utilizar stobjectives!!
  StageObjectives stobjectives;
  //PARA EL FUTURO !!! 
  bool locked;

  Stage(
      {@required this.stagenumber,
      this.description,
      this.shorttext,
      @required this.image,
      this.longimage,
      this.goals,
      this.obstacles,
      this.skills,
      this.shortimage,
      this.mastery,
      this.userscount,
      this.stobjectives,
      this.longdescription,
      this.locked
      });

  void addLesson(Lesson l){
    if(stobjectives.lecciones == null){
      stobjectives.lecciones = 0;
    }
    stobjectives.lecciones++;
    path.add(l);
    path.sort((a, b) => a.position - b.position);
  }

  void addMeditation(Meditation m){
    if(stobjectives.meditguiadas == null){
      stobjectives.meditguiadas = 0;
    }
    
    stobjectives.meditguiadas++;
    meditpath.add(m);
    meditpath.sort((a, b) => a.position - b.position);
  }

  void addGame(Game g){
    games.add(g);
    games.sort((a, b) => a.position - b.position);
  }

  void setGames(List<dynamic> games){
    if(games.length > 0){
      for(var game in games){
        addGame(game);
      }
    }

  }

  void setMeditations(List<dynamic> meditations){
    if(meditations.length > 0){
      for(var meditation in meditations){
        addMeditation(meditation);
      }
    }

  }

  void setLessons(List<dynamic> lessons){
     if(lessons.length > 0){
      for(var lesson in lessons){
        addLesson(lesson);
      }
    }
  }
}


class StageObjectives {
  int totaltime, streak, lecciones, meditguiadas, meditationcount, meditationfreetime;
  String freemeditationlabel;

  StageObjectives({this.totaltime,this.meditationcount,this.streak,this.lecciones,this.meditguiadas, this.meditationfreetime, this.freemeditationlabel});

  factory StageObjectives.fromJson(Map<String, dynamic> json) =>
    StageObjectives(
      totaltime: json['totaltime'] == null ? 0 : json['totaltime'],
      streak: json['streak'] == null ? 0 : json['streak'],
      meditationcount: json['meditation'] == null ? 0 : json['meditation']['count'] == null ? 0 : json['meditation']['count'],
      freemeditationlabel: json['meditation'] == null  ? null :  json['meditation']['time'] == null ? null : json['meditation']['time'].toString() + ' min meditations ',
      meditationfreetime: json['meditation'] == null   ? 0 :  json['meditation']['time']  == null ? 0 :json['meditation']['time'],
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
    
    if(freemeditationlabel != null ) {
      objectives ['meditation'] = freemeditationlabel;
    }

    if(totaltime != null  && totaltime != 0) {
      objectives['totaltime'] = 'Total time';
    }

    if(streak != null && streak != 0){
      objectives['streak'] = 'Streak';
    }

    if(lecciones != null && lecciones != 0){
      objectives['lecciones'] = 'Lessons';
    }

    if(meditguiadas != null && meditguiadas != 0){
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
