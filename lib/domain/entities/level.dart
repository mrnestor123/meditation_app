import 'package:flutter/material.dart';

class Level {
  int totalxp;
  // in each level we start with 0 xp
  int levelxp;
  //the goal for each level. Its the added plus 1000
  int xpgoal;
  int level;
  
  //Each level is going to have 100 xp more. The first one has
  int added = 0;

  // the percentage is how close you are from the next level;
  int percentage;
  double continuity;

  //constructor for creating a level with xp,level and continuity. The added is an aggregate for each level.
  //When we create a level we assign it to level 1, xpgoal = 1000 and
  Level({this.levelxp, this.level, this.xpgoal, this.continuity}) {
   //cuando creamos un nivel vacío
    if (this.levelxp == null) {
      this.levelxp = 0;
      this.level = 1;
      this.xpgoal = 1000;
      this.continuity= 1;
      this.totalxp = 0;
    }

    this.percentage = this.levelxp ~/ this.xpgoal;
  }

  void addXP(int xp) {
    // this.xp += xp * continuity;
    this.levelxp += xp;
    if (this.levelxp >= this.xpgoal) {
      this.levelxp = 0;
      this.added += 100;
      this.xpgoal += added;
      this.level++;
      this.percentage = 0;
    }
    this.percentage = this.levelxp ~/this.xpgoal;
  }

  Map<String,dynamic> toJson() => {
      "level": level == null ? null : level,
      "levelxp": levelxp == null ? null : levelxp,
      "xpgoal": xpgoal == null ? null : xpgoal,
      "continuity" : continuity == null ? null : continuity
  };
}
