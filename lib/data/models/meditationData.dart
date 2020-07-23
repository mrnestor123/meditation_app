import 'dart:convert';

import 'package:meditation_app/domain/entities/meditation_entity.dart';

class MeditationModel extends Meditation {
  final String codmed,  recording, title;

  final Duration duration;
  final DateTime day;

  MeditationModel({
    this.codmed,
    this.title,
    this.duration,
    this.recording,
    this.day
  }) : super(
          codmed: codmed,
          duration: duration,
          recording: recording,
          day:day
        );

  factory MeditationModel.fromRawJson(String str) =>
      MeditationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MeditationModel.fromJson(Map<String, dynamic> json) =>
      MeditationModel(
        codmed: json["codmed"] == null ? null : json["codmed"],
        title: json["title"] == null ? null : json["title"],
        duration: json["duration"] == null ? null : json["duration"],
        recording: json["recording"] == null ? null : json["recording"],
        //userId: json["userId"] == null ? null : json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "codmed": codmed == null ? null : codmed,
        "title": title == null ? null : title,
        "duration": duration == null ? null : duration,
        "recording": recording == null ? null : recording,
       // "userId": userId == null ? null : userId,
      };
}
