import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';

//HAY QUE CREAR CLASE GUIDEDMEDITATION
class Meditation extends Content {
  String coduser;
  Duration duration;
  DateTime day;

  Map<dynamic, dynamic> content;

  Map<dynamic,dynamic> followalong;

  //for referencing the user.
  //final String userId;

  Meditation(
      {
      @required this.duration,
      this.day,
      this.coduser,
      this.content,
      this.followalong,
      recording,
      cod,
      type,
      stagenumber,
      description,
      image,
      title,
      position,
      //this.userId
      })
      : super(cod: cod,
            description: description,
            image: image,
            title: title,
            stagenumber: stagenumber,
            position: position,
            type: type) {
        day == null ? day = DateTime.now() : null;
      }

  void setDay(DateTime d) => this.day = d;
}


class GuidedMeditation extends Meditation{
  


}