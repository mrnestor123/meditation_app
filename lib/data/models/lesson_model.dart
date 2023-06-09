// To parse this JSON data, do
//
//     final stage = stageFromJson(jsonString);

import 'dart:convert';

import 'package:meditation_app/domain/entities/lesson_entity.dart';

import '../../domain/entities/content_entity.dart';
import 'helpers.dart';

class LessonModel extends Lesson {
  LessonModel(
    {
      String title,
      String cod,
      image,
      String description,
      text,
      type,
      int stagenumber,
      createdBy,
      file,
      blocked,
      isNew,
      int position
    })
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
      position: position,
      isNew: isNew
    );

  factory LessonModel.fromRawJson(String str) =>
      LessonModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  @override
  factory LessonModel.fromJson(Map<String, dynamic> json) {
   // LessonModel model = Content.fromJson(json);
    LessonModel model =  medorLessfromJson(json, false);
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
