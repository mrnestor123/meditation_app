import 'dart:convert';

import 'package:meditation_app/domain/entities/meditation_entity.dart';

class MeditationModel extends Meditation {

  MeditationModel(
      {String cod,
      String title,
      Duration duration,
      recording,
      day,
      String type,
      image,
      int stagenumber,
      String coduser,
      content,
      int position
      })
      : super(
            cod: cod,
            title: title,
            coduser: coduser,
            duration: duration,
            recording: recording,
            content: content,
            day: day,
            type: type,
            image: image,
            stagenumber: stagenumber,
            position: position);

  factory MeditationModel.fromRawJson(String str) =>
      MeditationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MeditationModel.fromJson(Map<String, dynamic> json) =>
      MeditationModel(
          cod: json["cod"] == null ? null : json["cod"],
          title: json["title"] == null ? null : json["title"],
          duration:json["duration"] == null ? null : json['duration'] is String ? parseDuration(json['duration']) : Duration(minutes: json['duration']),
          day: json["day"] == null ? null : DateTime.parse(json["day"]),
          recording: json["recording"] == null ? null : json["recording"],
          type: json["type"] == null ? null : json["type"],
          image: json["image"] == null ? null : json['image'],
          stagenumber: json['stagenumber'] == null ? null : json['stagenumber'],
          position: json['position'] == null ? null : json['position'],
          coduser: json['coduser'] == null ? null : json['coduser'],
          content: json['content'] == null ? null: json['content']
          //userId: json["userId"] == null ? null : json["userId"],
          );

  Map<String, dynamic> toJson() => { 
       // "codmed": this.codmed == null ? null : this.codmed,
        "coduser":this.coduser == null ? null : this.coduser,
        //"title": this.title == null ? null : this.title,
        "duration": this.duration == null ? null : duration.inMinutes,
        //"recording": this.recording == null ? null : this.recording,
        "day": this.day == null ? null : day.toIso8601String(),
       // "type": this.type == null ? null : type,
       // "image": this.image == null ? null : image,
       // "stagenumber": this.stagenumber == null ? null : stagenumber
        
        // "userId": userId == null ? null : userId,
      };
}

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
