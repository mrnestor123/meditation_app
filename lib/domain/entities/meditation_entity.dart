import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';

class Meditation extends Content {
  String codmed, title, description, image, recording, type, coduser;
  int stagenumber, position;
  Duration duration;
  DateTime day;

  List<String> sentences;
  Map<dynamic, dynamic> content;

  //for referencing the user.
  //final String userId;

  Meditation(
      {this.codmed,
      this.duration,
      this.recording,
      this.day,
      this.type,
      this.stagenumber,
      this.description,
      this.image,
      this.title,
      this.position,
      this.coduser,
      this.content
      //this.userId
      })
      : super(
            cod: codmed,
            description: description,
            image: image,
            title: title,
            stagenumber: stagenumber,
            position: position,
            type: type);
}
