import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Lesson {
  String codlesson;
  //to unlock the lesson whenever the user is at a given level
  final String precedinglesson;
  final String title;
  final String slider;
  final String group;
  final String description;
  final Map<String,dynamic> text;
  final int xp;
  final Map<String,String> lessontext= new Map();
  bool blocked;
  bool seen;

  Lesson({
    this.codlesson,
    @required this.title,
    this.precedinglesson,
    this.group,
    this.slider,
    @required this.description,
    @required this.text,
    @required this.xp,
    this.blocked,
    @required this.seen
  }) {
    if (this.codlesson == null) {
      var uuid = Uuid();
      this.codlesson = uuid.v1();
    }
  }

//  @override
  //List<Object> get props =>
    //  [title, codlesson, slider, description, text, xp];
}
