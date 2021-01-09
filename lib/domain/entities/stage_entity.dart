import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';

class Stage {
  int stagenumber, userscount;
  String description, image, goals, obstacles, skills, mastery;
  Map<String, List<Content>> path = new Map();
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
}
