import 'dart:convert';

import 'package:meditation_app/domain/entities/meditation_entity.dart';

class MeditationModel extends Meditation {
  String codmed, recording, title, type;
  final Duration duration;
  final DateTime day;
  
  MeditationModel(
      {this.codmed, this.title, this.duration, this.recording, this.day,this.type})
      : super(
            codmed: codmed, duration: duration, recording: recording, day: day, type: type);

  factory MeditationModel.fromRawJson(String str) =>
      MeditationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MeditationModel.fromJson(Map<String, dynamic> json) =>
      MeditationModel(
        codmed: json["codmed"] == null ? null : json["codmed"],
        title: json["title"] == null ? null : json["title"],
        duration:json["duration"] == null ? null : parseDuration(json["duration"]),
        day: json["day"] == null ? null : DateTime.parse(json["day"]),
        recording: json["recording"] == null ? null : json["recording"],
        type: json["type"] == null ? null : json["type"],
        //userId: json["userId"] == null ? null : json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "codmed": this.codmed == null ? null : this.codmed,
        "title": this.title == null ? null : this.title,
        "duration": this.duration == null ? null : duration.toString(),
        "recording": this.recording == null ? null : this.recording,
        "day": this.day == null ? null : day.toIso8601String(),
        "type": this.type == null ? null : type
        // "userId": userId == null ? null : userId,
      };
}

Duration parseDuration(String s) {
  int hours = 0;
  int minutes = 0;
  int seconds=0;
  List<String> parts = s.split(':');
  if (parts.length > 2) {
    hours = int.parse(parts[parts.length - 3]);
  }
  if (parts.length > 1) {
    minutes = int.parse(parts[parts.length - 2]);
  }
  seconds = int.parse(parts[parts.length - 1].substring(0,2));
  return Duration(hours: hours, minutes: minutes, seconds: seconds);
}
