// To parse this JSON data, do
//
//     final stage = stageFromJson(jsonString);

import 'dart:convert';

import 'package:meditation_app/domain/entities/lesson_entity.dart';

class LessonModel extends Lesson {
  String codlesson;
  final String title;
  final String slider;
  final String group;
  final String description;
  final Map<String, dynamic> text;
  final String precedinglesson;
  final int xp;
  bool blocked;

  LessonModel(
      {this.title,
      this.codlesson,
      this.slider,
      this.description,
      this.group,
      this.xp,
      this.text,
      this.precedinglesson,
      this.blocked})
      : super(
            title: title,
            codlesson: codlesson,
            slider: slider,
            description: description,
            text: text,
            xp: xp,
            group: group,
            precedinglesson: precedinglesson,
            blocked: blocked);

  factory LessonModel.fromRawJson(String str) =>
      LessonModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LessonModel.fromJson(Map<String, dynamic> json) => LessonModel(
      codlesson: json["codlesson"] == null ? null : json["codlesson"],
      title: json["title"] == null ? null : json["title"],
      slider: json["slider"] == null ? null : json["slider"],
      description: json["description"] == null ? null : json["description"],
      text: json["text"] == null ? null : json["text"],
      group: json["group"] == null ? null : json["group"],
      precedinglesson: json["precedinglesson"] == null ? null : json["precedinglesson"],
      blocked: json["blocked"] == null ? null : json["blocked"]);

  Map<String, dynamic> toJson() => {
        "codlesson": codlesson == null ? null : codlesson,
        "title": title == null ? null : title,
        "slider": slider == null ? null : slider,
        "description": description == null ? null : description,
        "text": text == null ? null : text,
        "group": group == null ? null : group,
        "precedinglesson": precedinglesson == null ? null : precedinglesson,
        "blocked": blocked == null ? null : blocked
      };
}
