

import 'dart:convert';

import 'package:meditation_app/data/models/meditationData.dart';

import '../../domain/entities/content_entity.dart';
import 'lesson_model.dart';

Content medorLessfromJson(json, bool isMeditation){
  // es el mismo código repetido !!!! NO SE COMO NO DESREPETIRLO :(
  if(isMeditation){
    return MeditationModel(
      cod: json['cod'],
      stagenumber: json['stagenumber'] == null || json['stagenumber'] is String  ? null : json['stagenumber'],
      title: json['title'],
      createdBy: json['createdBy'] != null && json['createdBy'] is Map ? json['createdBy'] : null,
      description: json['description'],
      isNew: json['isNew'],
      image: json['image'],
      type: json['type'],
      file: json['file'] == null ? '' : json['file'],
      total: json['duration'] != null ?  json['duration'] is String ? Duration(minutes: int.parse(json['duration'])) : Duration(minutes: json['duration']): null,

      position: json['position']
    );
  }else {
    return LessonModel(
      cod: json['cod'],
      stagenumber: json['stagenumber'] == null || json['stagenumber'] is String  ? null : json['stagenumber'],
      title: json['title'],
      isNew: json['isNew'],
      description: json['description'],
      createdBy: json['createdBy'] != null ? json['createdBy'] : null,
      image: json['image'],
      type: json['type'],
      file: json['file'] == null ? '' : json['file'],
      position: json['position']
    );
  }
}

bool isJsonString(str) {
    try {
     json.decode(str);
    } catch (e) {
      return false;
    }
    return true;
}

