// To parse this JSON data, do
//
//     final stage = stageFromJson(jsonString);

import 'dart:convert';

import 'package:meditation_app/domain/entities/lesson_entity.dart';

import '../../domain/entities/content_entity.dart';
import 'helpers.dart';

class LessonModel extends Lesson {
  LessonModel(
      {String title,
      String cod,
      image,
      String description,
      text,
      type,
      int stagenumber,
      createdBy,
      file,
      blocked,
      int position})
      : super(
            title: title,
            cod: cod,
            createdBy:createdBy,
            image: image,
            description: description,
            type: type,
            text: text,
            file:file,
            blocked:blocked,
            stagenumber: stagenumber,
            position: position);

  factory LessonModel.fromRawJson(String str) =>
      LessonModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  @override
  factory LessonModel.fromJson(Map<String, dynamic> json) {
    LessonModel model =  medorLessfromJson(json, false);
    model.text = json['text'] == null ? null : json['text'];
    return model;
  }


  @override
  Map<String, dynamic> toJson() {
    Map<String,dynamic> json = new Map();
    json.addAll(super.toJson());

    //FALTA AÑADIR LO QUE QUEDA DE LA LECCIÓN


    return json;
  }
}
