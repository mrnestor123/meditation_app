import 'dart:convert';

import 'package:meditation_app/domain/entities/stage_entity.dart';

class StageModel extends Stage{
  final int stagenumber;
  final String description;

  StageModel({
    this.stagenumber,
    this.description,
  });

  factory StageModel.fromRawJson(String str) =>
      StageModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StageModel.fromJson(Map<String, dynamic> json) => StageModel(
        stagenumber: json["stagenumber"] == null ? null : json["stagenumber"],
        description: json["description"] == null ? null : json["description"],
      );

  Map<String, dynamic> toJson() => {
        "stagenumber": stagenumber == null ? null : stagenumber,
        "description": description == null ? null : description,
      };
}
