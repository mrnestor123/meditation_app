// To parse this JSON data, do
//
//     final stage = stageFromJson(jsonString);

import 'dart:convert';

import 'package:meditation_app/domain/entities/lesson_entity.dart';

class LessonModel extends Lesson {
  String codlesson, title, image, description, type;
  final List<dynamic> text;
  final int stagenumber;

  LessonModel(
      {this.title,
      this.codlesson,
      this.image,
      this.description,
      this.text,
      this.type,
      this.stagenumber})
      : super(
            title: title,
            codlesson: codlesson,
            image: image,
            description: description,
            type: type,
            text: text,
            stagenumber: stagenumber);

  factory LessonModel.fromRawJson(String str) =>
      LessonModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LessonModel.fromJson(Map<String, dynamic> json) => LessonModel(
      codlesson: json["codlesson"] == null ? null : json["codlesson"],
      title: json["title"] == null ? null : json["title"],
      image: json["image"] == null ? null : json["image"],
      description: json["description"] == null ? null : json["description"],
      text: json["text"] == null ? null : json["text"],
      type: json["type"] == null ? null : json["type"],
      stagenumber: json["stagenumber"] == null ? null : json["stagenumber"]);

  Map<String, dynamic> toJson() => {
        "codlesson": codlesson == null ? null : codlesson,
        "title": title == null ? null : title,
        "slider": image == null ? null : image,
        "description": description == null ? null : description,
        "text": text == null ? null : text,
        "type": type == null ? null : type,
        "stagenumber": stagenumber == null ? null : stagenumber
      };
}
