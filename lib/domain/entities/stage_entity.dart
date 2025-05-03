import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:mobx/mobx.dart';

import 'meditation_entity.dart';

class Stage {
  int stagenumber, userscount, percentage, prevmilestone;
  String description, image, goals, obstacles, skills, title,
    mastery, longimage,  shortimage, shorttext, layout,
    longdescription, practiceSummary, whenToAdvance;

  bool blocked;
  // EN EL  FUTURO UNA LISTA SOLO CON CONTENT
  // PATH SERÁ EL THEORY Y MEDITPATH EL DE  MEDITATIONS  !!
  ObservableList<Content> path = new ObservableList();
  ObservableList<Meditation> meditpath = new ObservableList();
  ObservableList<Game> games = new ObservableList();
  List<Content> videos = new List.empty(growable: true);


  Stage({
    @required this.stagenumber,
    this.description,
    this.title,
    this.shorttext,
    @required this.image,
    this.longimage,
    this.goals,
    this.layout,
    this.blocked = false,
    this.prevmilestone = 0,
    this.obstacles,
    this.skills,
    this.shortimage,
    this.mastery,
    this.userscount,
    this.longdescription,
    this.whenToAdvance,
    this.practiceSummary,
    this.percentage
  });


  void addLesson(Content l){
    path.add(l);
    path.sort((a, b) => a.position - b.position);
  }

  void addMeditation(Meditation m){
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

  void addVideo(Content v){
    videos.add(v);
    videos.sort((a, b) => a.position - b.position);
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

  int checkPercentage(User user){
    List<Content> done = user.contentDone.where((element) => 
      element.stagenumber == this.stagenumber && 
      element.timesFinished != null 
      && element.timesFinished >= 1
    ).toList();


    List<Content> allContent = path + meditpath;

    // PERCENTAGE OF CONTENT DONE
    double doublepercentage = (done.length / (allContent.length == 0 ? 1 : allContent.length)) * 100;

    this.percentage = doublepercentage.toInt();
    return doublepercentage.toInt();
  }
}