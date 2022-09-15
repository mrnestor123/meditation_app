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
      createdBy,
      file,
      blocked,
      isNew,
      @required description,
      @required this.text})
      : super(
          isNew:isNew,
          cod: cod,
          title: title,
          blocked:blocked,
          type: type,
          image: image,
          stagenumber: stagenumber,
          description: description,
          createdBy:createdBy,
          position: position,
          file: file);

//  @override
  //List<Object> get props =>
  //  [title, codlesson, slider, description, text, xp];
}
