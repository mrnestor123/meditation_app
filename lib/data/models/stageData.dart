import 'dart:convert';
import 'package:meditation_app/data/models/game_model.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/data/models/mission_model.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:mobx/mobx.dart';

class StageModel extends Stage {

  StageModel(
      {int stagenumber,
      userscount,
      description,
      image,
      String goals,
      String obstacles,
      String skills,
      String mastery,
      String longimage,
      String shortimage,
      stobjectives})
      : super(
            stagenumber: stagenumber,
            userscount: userscount,
            description: description,
            image: image,
            goals: goals,
            obstacles: obstacles,
            skills: skills,
            mastery: mastery,
            longimage: longimage,
            stobjectives: stobjectives,
            shortimage: shortimage
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
        goals: json["goals"] == null ? null : json["goals"],
        shortimage: json["shortimage"] == null ? null : json["shortimage"],
        obstacles: json["obstacles"] == null ? null : json["obstacles"],
        stobjectives: json['objectives'] == null ? StageObjectives.empty(): StageObjectives.fromJson(json['objectives']),
        skills: json["skills"] == null ? null : json["skills"],
        mastery: json["mastery"] == null ? null : json["mastery"]);

        if(json['lessons'] != null){
          s.setLessons(json['lessons'].map((l) => new LessonModel.fromJson(l)).toList());
        }
        
        if(json['meditations'] != null && json['meditations'] is List){
          s.setMeditations(json['meditations'].map((m) => new MeditationModel.fromJson(m)).toList());
        }
        
        if(json['games'] != null){
          s.setGames(json['games'].map((g) => new GameModel.fromJson(g)).toList());
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
        'objectives': stobjectives == null? null : stobjectives.toJson(),
        "mastery": mastery == null ? null : mastery,
        "path": path == null ? null : path
      };
}
