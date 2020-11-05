import 'dart:convert';

import 'package:meditation_app/data/models/mission_model.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';

class StageModel extends Stage {
  int stagenumber,userscount;
  String description, image, goals, obstacles, skills, mastery;

  StageModel(
      {this.stagenumber,
      this.userscount,
      this.description,
      this.image,
      this.goals,
      this.obstacles,
      this.skills,
      this.mastery}):
      super(
        stagenumber:stagenumber,
        userscount:userscount,
        description: description,
        image: image,
        goals:goals,
        obstacles:obstacles,
        skills:skills,
        mastery:mastery
        );

  factory StageModel.fromRawJson(String str) =>
      StageModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());


  factory StageModel.fromJson(Map<String, dynamic> json) {
    int count = 1;
    StageModel s = new StageModel(
        stagenumber: json["stagenumber"] == null ? null : json["stagenumber"],
        description: json["description"] == null ? null : json["description"],
        userscount: json['userscount'] == null ? null :json['userscount'],
        image: json["image"] == null ? null : json["image"],
        goals: json["goals"] == null ? null : json["goals"],
        obstacles: json["obstacles"] == null ? null : json["obstacles"],
        skills: json["skills"] == null ? null : json["skills"],
        mastery: json["mastery"] == null ? null : json["mastery"]);
    
      if(json['missions'] != null){ while(json['missions'][count.toString()] != null){
        s.missions.add(new MissionModel.fromJson(json['missions'][(count++).toString()]));
      }}

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
        "mastery": mastery == null ? null : mastery
      };
}
