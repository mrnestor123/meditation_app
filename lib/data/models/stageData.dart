import 'dart:convert';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/data/models/mission_model.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:observable/observable.dart';

class StageModel extends Stage {
  int stagenumber, userscount;
  String description, image, goals, obstacles, skills, mastery;
  Map<String, dynamic> objectives;

  StageModel(
      {this.stagenumber,
      this.userscount,
      this.description,
      this.image,
      this.goals,
      this.obstacles,
      this.skills,
      this.mastery,
      this.objectives})
      : super(
            stagenumber: stagenumber,
            userscount: userscount,
            description: description,
            image: image,
            goals: goals,
            obstacles: obstacles,
            skills: skills,
            mastery: mastery,
            objectives: objectives);

  factory StageModel.fromRawJson(String str) =>
      StageModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StageModel.fromJson(Map<String, dynamic> json) {
    int count = 0;
    int meditationcount = 0;
    StageModel s = new StageModel(
        stagenumber: json["stagenumber"] == null ? null : json["stagenumber"],
        description: json["description"] == null ? null : json["description"],
        userscount: json['userscount'] == null ? null : json['userscount'],
        image: json["image"] == null ? null : json["image"],
        goals: json["goals"] == null ? null : json["goals"],
        obstacles: json["obstacles"] == null ? null : json["obstacles"],
        skills: json["skills"] == null ? null : json["skills"],
        mastery: json["mastery"] == null ? null : json["mastery"],
        objectives: json['objectives'] == null ? null : json['objectives']);

    if (s.objectives == null) {
      s.objectives = new Map();
    }
    s.objectives['lecciones'] = 0;
    s.objectives['meditguiadas'] = 0;

   /* if (json['path'] != null) {
      while (json['path'][count.toString()] != null) {
        for (var content in json['path'][count.toString()]) {
          if (s.path[count.toString()] == null) {
            s.path[count.toString()] = new ObservableList<Content>();
          }
          s.objectives['lecciones']++;
          s.path[count.toString()].add(new LessonModel.fromJson(content));
        }
        count++;
      }
    }*/

    if (json['meditations'] != null) {
      while (json['meditations'][meditationcount.toString()] != null) {
        for (var content in json['meditations'][meditationcount.toString()]) {
          if (s.meditpath[meditationcount.toString()] == null) {
            s.meditpath[meditationcount.toString()] = new ObservableList<MeditationModel>();
          }
          s.objectives['meditguiadas']++;
          s.meditpath[meditationcount.toString()].add(new MeditationModel.fromJson(content));
        }
        meditationcount++;
      }
    }

    return s;
  }

  Map<String, dynamic> toJson() => {
        "stagenumber": stagenumber == null ? null : stagenumber,
        "description": description == null ? null : description,
        "userscount": userscount == null ? null : userscount,
        "image": image == null ? null : image,
        "goals": goals == null ? null : goals,
        "obstacles": obstacles == null ? null : obstacles,
        "skills": skills == null ? null : skills,
        "mastery": mastery == null ? null : mastery,
        "path": path == null ? null : path,
        'objectives': objectives == null ? null : objectives
      };
}
