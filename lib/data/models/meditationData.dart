import 'dart:convert';

import 'package:meditation_app/domain/entities/meditation_entity.dart';

class MeditationModel extends Meditation {
  final String codmed, recording, title;

  final Duration duration;
  final DateTime day;
  
  MeditationModel(
      {this.codmed, this.title, this.duration, this.recording, this.day})
      : super(
            codmed: codmed, duration: duration, recording: recording, day: day);

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
        //userId: json["userId"] == null ? null : json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "codmed": codmed == null ? null : codmed,
        "title": title == null ? null : title,
        "duration": duration == null ? null : duration.toString(),
        "recording": recording == null ? null : recording,
        "day": day == null ? null : day.toIso8601String()
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
