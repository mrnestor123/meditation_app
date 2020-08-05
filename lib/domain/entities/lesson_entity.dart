import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Lesson extends Equatable {
  String codlesson;
  //to unlock the lesson whenever the user is at a given level
  final int requiredlevel;
  final String title;
  final String slider;
  final String group;
  final String description;
  final String text;
  final int stagenumber;
  final int xp;

  Lesson({
    this.codlesson,
    @required this.title,
    this.requiredlevel,
    this.group,
    this.slider,
    @required this.description,
    @required this.text,
    @required this.stagenumber,
    @required this.xp
  }) {
    if (this.codlesson == null) {
      var uuid = Uuid();
      this.codlesson = uuid.v1();
    }
  }

  @override
  List<Object> get props =>
      [title, codlesson, slider, description, text, stagenumber,xp];
}
