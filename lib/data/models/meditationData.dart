import 'dart:convert';

import 'package:meditation_app/domain/entities/meditation_entity.dart';

import '../../domain/entities/content_entity.dart';
import 'helpers.dart';

class MeditationModel extends Meditation {

  MeditationModel(
      {String cod,
      String title,
      Duration duration,
      day,
      String type,
      image,
      description,
      int stagenumber,
      String coduser,
      content,
      int position,
      file,
      followalong,
      createdBy,
      total,
      isNew
      })
      : super(
      cod: cod,
      total:total,
      title: title,
      coduser: coduser,
      duration: duration,
      content: content,
      description: description,
      createdBy:createdBy,
      day: day,
      type: type,
      image: image,
      isNew:isNew,
      file: file,
      stagenumber: stagenumber,
      followalong: followalong,
      position: position
    );

  factory MeditationModel.fromRawJson(String str) => MeditationModel.fromJson(json.decode(str), false);

  String toRawJson() => json.encode(toJson());

  @override
  factory MeditationModel.fromJson(Map<String, dynamic> json, [isShort = false]) {
    // LAS MEDITACIONES HECHAS POR EL USUARIO SOLO TIENEN CÓDIGO Y 
    MeditationModel model = medorLessfromJson(json, true);
      
    if(!isShort){ 
      model.content =  json['content'] == null ? null : json['content'];
      model.followalong = json['followalong'] == null ? null : json['followalong'];
    }else{
      model = new MeditationModel();
    }

    model.duration = json["duration"] == null ? null : json['duration'] is String ? Duration(minutes: int.parse(json['duration'])) : Duration(minutes: json['duration']);

    model.day = json["day"] == null ? null : json['day'] is String ?  DateTime.parse(json["day"]).toLocal() :
      DateTime.fromMillisecondsSinceEpoch(json['day']).toLocal();

    model.coduser = json['coduser'] == null ? null : json['coduser'];

    return model;
  }

  @override 
  Map<String,dynamic> toJson(){
    Map<String,dynamic> json = new Map();
    json.addAll(super.toJson());
    // FALTA AÑADIR CONTENIDO ESPECIAL DE LA MEDITACIÓN
    return json;
  } 
}

// ESTO SE UTILIZA ???? 
Duration parseDuration(String s) {
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  List<String> parts = s.split(':');
  if (parts.length > 2) {
    hours = int.parse(parts[parts.length - 3]);
  }
  if (parts.length > 1) {
    minutes = int.parse(parts[parts.length - 2]);
  }
  seconds = int.parse(parts[parts.length - 1].substring(0, 2));

  return Duration(hours: hours, minutes: minutes, seconds: seconds);
}
