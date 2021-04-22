import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';

class Lesson extends Content {
  List<dynamic> text;
 
  Lesson(
      {cod,
      @required title,
      image,
      stagenumber,
      type,
      position,
      @required description,
      @required this.text})
      : super(
            cod: cod,
            title: title,
            type: type,
            image: image,
            stagenumber: stagenumber,
            description: description,
            position: position);

//  @override
  //List<Object> get props =>
  //  [title, codlesson, slider, description, text, xp];
}
