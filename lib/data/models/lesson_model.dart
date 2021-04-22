// To parse this JSON data, do
//
//     final stage = stageFromJson(jsonString);

import 'dart:convert';

import 'package:meditation_app/domain/entities/lesson_entity.dart';

class LessonModel extends Lesson {
  LessonModel(
      {String title,
      String cod,
      image,
      String description,
      text,
      type,
      int stagenumber,
      int position})
      : super(
            title: title,
            cod: cod,
            image: image,
            description: description,
            type: type,
            text: text,
            stagenumber: stagenumber,
            position: position);

  factory LessonModel.fromRawJson(String str) =>
      LessonModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LessonModel.fromJson(Map<String, dynamic> json) => LessonModel(
      cod: json["cod"] == null ? json['codlesson'] : json["cod"],
      position: json['position'] == null ? null : json['position'],
      title: json["title"] == null ? null : json["title"],
      image: json["image"] == null ? null : json["image"],
      description: json["description"] == null ? null : json["description"],
      text: json["text"] == null ? null : json["text"],
      type: json["type"] == null ? null : json["type"],
      stagenumber: json["stagenumber"] == null ? null : json["stagenumber"]);

  Map<String, dynamic> toJson() => {
        "cod": cod == null ? null : cod,
        "title": title == null ? null : title,
        "slider": image == null ? null : image,
        "description": description == null ? null : description,
        "text": text == null ? null : text,
        "type": type == null ? null : type,
        "stagenumber": stagenumber == null ? null : stagenumber
      };
}
