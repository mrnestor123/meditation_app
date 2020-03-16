import 'dart:convert';

class MeditationModel {
  final int codmed;
  final String duration;
  final String recording;
  final int guided;

  MeditationModel({
    this.codmed,
    this.duration,
    this.recording,
    this.guided,
  });

  factory MeditationModel.fromRawJson(String str) =>
      MeditationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MeditationModel.fromJson(Map<String, dynamic> json) =>
      MeditationModel(
        codmed: json["codmed"] == null ? null : json["codmed"],
        duration: json["duration"] == null ? null : json["duration"],
        recording: json["recording"] == null ? null : json["recording"],
        guided: json["guided"] == null ? null : json["guided"],
      );

  Map<String, dynamic> toJson() => {
        "codmed": codmed == null ? null : codmed,
        "duration": duration == null ? null : duration,
        "recording": recording == null ? null : recording,
        "guided": guided == null ? null : guided,
      };
}
