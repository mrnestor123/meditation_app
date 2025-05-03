

import 'dart:convert';

import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/domain/entities/technique_entity.dart';

import '../../domain/entities/content_entity.dart';
import 'lesson_model.dart';

// HAY QUE REVISAR ESTO BIEN !!
Content medorLessfromJson(json, [bool isMeditation = false]){
  // es el mismo código repetido !!!! NO SE COMO NO DESREPETIRLO :(
  if(isMeditation || json['type'] == 'meditation-practice'){
    return MeditationModel(
      cod: json['cod'],
      stagenumber: json['stagenumber'] == null || json['stagenumber'] is String  ? null : json['stagenumber'],
      title: json['title'],
      createdBy: json['createdBy'] != null && json['createdBy'] is Map ? json['createdBy'] : null,
      description: json['description'],
      group:json['group'],
      isNew: json['isNew'],
      image: json['image'],
      type: json['type'],
      file: json['file'] == null ? '' : json['file'],
      content: json['text'] != null ? Map.fromIterable(json['text'], key: (v) => v[0], value: (v) => v[1]):
      json['content'] == null ? {} : json['content'],
      total: json['duration'] != null 
      ? json['duration'] is String ? Duration(minutes: int.parse(json['duration'])) 
      : Duration(minutes: json['duration'])
      : null,
      position: json['position']
    );
  //  LA TECNICA REALMENTE E S UN CONTENIDO !! NO TIENE MÁS DATOS !!
  }else if(json['type'] == 'technique'){
    return Technique.fromJson(json);
  }else if(json['type'] == 'recording' ||  json['type']=='video') {
    return FileContent.fromJson(json);
  }else{
    return LessonModel(
      cod: json['cod'],
      group:json['group'],
      tmi: json['tmi'],
      category:json['category'],
      stagenumber: json['stagenumber'] == null || json['stagenumber'] is String  ? null : json['stagenumber'],
      title: json['title'],
      isNew: json['isNew'],
      description: json['description'],
      createdBy: json['createdBy'] != null && json['createdBy'] is Map ? json['createdBy'] : null,
      image: json['image'],
      type: json['type'],
      file: json['file'] == null ? '' : json['file'],
      text: json['text'] == null ? json['body'] !=  null ? [{'text':json['body']}] : null : json['text'],
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

