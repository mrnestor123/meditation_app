

import 'dart:convert';

import 'package:meditation_app/domain/entities/game_entity.dart';

class GameModel extends Game {
  GameModel(
      {String title,
      String cod,
      String video,
      image,
      String description,
      text,
      type,
      int stagenumber,
      int position})
      : super(
            title: title,
            cod: cod,
            video:video,
            image: image,
            description: description,
            type: type,
            stagenumber: stagenumber,
            position: position);

  factory GameModel.fromRawJson(String str) => GameModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());


  // hay que hacer aqui lo del content tambien;;;
  factory GameModel.fromJson(Map<String, dynamic> json) { 
    
    GameModel g = GameModel(
      cod: json["cod"] == null ? json['codlesson'] : json["cod"],
      position: json['position'] == null ? null : json['position'],
      title: json["title"] == null ? null : json["title"],
      image: json["image"] == null ? null : json["image"],
      video: json['video'] == null ? null : json['video'],
      description: json["description"] == null ? null : json["description"],
      text: json["text"] == null ? null : json["text"],
      type: json["type"] == null ? null : json["type"],
      stagenumber: json["stagenumber"] == null ? null : json["stagenumber"]);

    g.setQuestions(json['questions']);

    return g;
  }

  Map<String, dynamic> toJson() => {
      "cod": cod == null ? null : cod,
      "title": title == null ? null : title,
      "slider": image == null ? null : image,
      "description": description == null ? null : description,
      "type": type == null ? null : type,
      "stagenumber": stagenumber == null ? null : stagenumber
    };
}