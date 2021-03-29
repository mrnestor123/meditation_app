import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:mobx/mobx.dart';

import 'lesson_entity.dart';
import 'meditation_entity.dart';

class Stage {
  int stagenumber, userscount;
  String description, image, goals, obstacles, skills, mastery;
  ObservableList<Content> path = new ObservableList();
  ObservableList<Meditation> meditpath = new ObservableList();
  Map<String, dynamic> objectives = new Map();


  Stage(
      {@required this.stagenumber,
      this.description,
      @required this.image,
      this.goals,
      this.obstacles,
      this.skills,
      this.mastery,
      this.userscount,
      this.objectives});

  bool checkifPassedStage(User u) {
    var objectiveCheck = {
      'totaltime': () =>
          u.stats['etapa']['tiempo'] >= this.objectives['totaltime'],
      'meditation': () =>
          u.stats['etapa']['medittiempo'] >=
          this.objectives['meditation']['count'],
      'streak': () =>
          u.stats['etapa']['maxstreak'] >= this.objectives['streak'],
      'lecciones': () =>
          u.stats['etapa']['lecciones'] >= this.objectives['lecciones'],
      'meditguiadas': () =>
          u.stats['etapa']['meditguiadas'] >= this.objectives['meditguiadas']
    };

    for (var key in this.objectives.keys) {
      if (!objectiveCheck[key]()) {
        return false;
      }
    }

    return true;
  }



  void addContent(Content c){
    if(c.type== 'meditation' || c.type =='lesson'){
      if(this.objectives['lecciones'] == null) {this.objectives['lecciones'] = 0;}
      this.objectives['lecciones']++;
      path.add(c);
      path.sort((a, b) => a.position - b.position);
    } else {
       if(this.objectives['meditguiadas'] == null) {this.objectives['meditguiadas'] = 0;}
      this.objectives['meditguiadas']++;
      meditpath.add(c);
      
      meditpath.sort((a, b) => a.position - b.position);
    }
  }
}
