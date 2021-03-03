import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';

class Lesson extends Content {
  String cod, title, image, description, type;
  List<dynamic> text;
  int stagenumber,position;
  Map<String, String> lessontext = new Map();

  Lesson(
      {this.cod,
      @required this.title,
      this.image,
      this.stagenumber,
      this.type,
      this.position,
      @required this.description,
      @required this.text})
      : super(
            cod: cod,
            title: title,
            type: type,
            image: image,
            stagenumber: stagenumber,
            description: description,
            position: position);

//  @override
  //List<Object> get props =>
  //  [title, codlesson, slider, description, text, xp];
}
