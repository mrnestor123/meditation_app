// To parse this JSON data, do
//
//     final stage = stageFromJson(jsonString);

import 'dart:convert';

import 'package:meditation_app/domain/entities/lesson_entity.dart';

class LessonModel extends Lesson {
  final String codlesson;
  final String title;
  final String slider;
  final String description;
  final String text;
  final int stagenumber;

  LessonModel({
    this.title,
    this.codlesson,
    this.slider,
    this.description,
    this.text,
    this.stagenumber,
  }): super(
    title:title,
    codlesson: codlesson,
    slider: slider,
    description: description,
    text: text,
    stagenumber:stagenumber
  );

  factory LessonModel.fromRawJson(String str) => LessonModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LessonModel.fromJson(Map<String, dynamic> json) => LessonModel(
        codlesson: json["codlesson"] == null ? null : json["codlesson"],
        title: json["title"] == null ? null : json["title"],
        slider: json["slider"] == null ? null : json["slider"],
        description: json["description"] == null ? null : json["description"],
        text: json["text"] == null ? null : json["text"],
        stagenumber: json["stagenumber"] == null ? null : json["stagenumber"],
      );

  Map<String, dynamic> toJson() => {
        "codlesson": codlesson == null ? null : codlesson,
        "title": title ==null ? null : title,
        "slider": slider == null ? null : slider,
        "description": description == null ? null : description,
        "text": text == null ? null : text,
        "stagenumber": stagenumber == null ? null : stagenumber,
      };
}