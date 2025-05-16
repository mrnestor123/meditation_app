import 'dart:convert';
import 'package:meditation_app/data/models/game_model.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/data/models/meditation_model.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:mobx/mobx.dart';

class StageModel extends Stage {
  
  StageModel({
    int stagenumber,
    userscount,
    description,
    image,
    String goals,
    String obstacles,
    String skills,
    String mastery,
    String longimage,
    String shortimage,
    String longdescription,
    String title,
    String layout,
    practiceSummary,
    shorttext,
    whenToAdvance,
    blocked,
    prevmilestone,
    stobjectives
  }): super(
    stagenumber: stagenumber,
    userscount: userscount,
    layout: layout,
    description: description,
    practiceSummary: practiceSummary,
    whenToAdvance: whenToAdvance,
    title: title,
    image: image,
    goals: goals,
    obstacles: obstacles,
    skills: skills,
    mastery: mastery,
    longimage: longimage,
    shorttext: shorttext,
    longdescription: longdescription,
    shortimage: shortimage,
    prevmilestone: prevmilestone,
    blocked: blocked
  );

  factory StageModel.fromRawJson(String str) =>
    StageModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StageModel.fromJson(Map<String, dynamic> json) {
    StageModel s = new StageModel(
      stagenumber: json["stagenumber"] == null ? null : json["stagenumber"],
      description: json["description"] == null ? null : json["description"],
      userscount: json['userscount'] == null ? null : json['userscount'],
      longimage: json['longimage']== null ? null : json['longimage'],
      image: json["image"] == null ? null : json["image"],
      layout: json["layout"] == null ?  null : json["layout"],
      goals: json["goals"] == null ? null : json["goals"],
      shortimage: json["shortimage"] == null ? null : json["shortimage"],
      longdescription: json['longdescription'] == null ? null : json['longdescription'],
      obstacles: json["obstacles"] == null ? null : json["obstacles"],
      skills: json["skills"] == null ? null : json["skills"],
      title: json['title'] != null ? json['title']: 'Stage ${json["stagenumber"].toString()}',
      blocked: json["blocked"] == null ? false : json["blocked"],
      shorttext: json['shorttext'] == null ? null : json['shorttext'],
      practiceSummary: json['practiceSummary'] == null ? null : json['practiceSummary'],
      whenToAdvance: json['whenToAdvance'] == null ? null : json['whenToAdvance'],
      mastery: json["mastery"] == null ? null : json["mastery"],
      prevmilestone: json["prevmilestone"] == null ? 0 : json["prevmilestone"],
    );

    if(json['lessons'] != null){
      s.setLessons(json['lessons'].map((l) => new LessonModel.fromJson(l)).toList());
    }
    
    if(json['meditations'] != null && json['meditations'] is List){
      s.setMeditations(json['meditations'].map((m) => new MeditationModel.fromJson(m)).toList());
    }
    
    if(json['games'] != null){
      s.setGames(json['games'].map((g) => new GameModel.fromJson(g)).toList());
    }

    // ESTO SE AÑADE AL LESSONS  !!!!
    if(json['videos'] != null && json['videos'].length > 0){
      for(var video in json['videos']){
        s.addLesson(FileContent.fromJson(video));
      }
    }
    
    return s;
  }

  Map<String, dynamic> toJson() => {
    "stagenumber": stagenumber == null ? null : stagenumber,
    "description": description == null ? null : description,
    "userscount": userscount == null ? null : userscount,
    "longimage": longimage == null ? null: longimage,
    "image": image == null ? null : image,
    "goals": goals == null ? null : goals,
    "obstacles": obstacles == null ? null : obstacles,
    "skills": skills == null ? null : skills,
    "mastery": mastery == null ? null : mastery,
    "path": path == null ? null : path
  };
}
