import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Content {
  String cod, title, description, image, type,file, createdBy;
  int stagenumber, position;
  bool blocked;

  Content({cod, @required this.stagenumber, this.title,this.createdBy, this.description, this.image, this.type, this.position, this.blocked, this.file}) {
    if (cod == null) {
      var uuid = Uuid();
      this.cod = uuid.v1();
    } else {
      this.cod = cod;
    }
  }

  bool isMeditation(){
    return type == 'meditation-practice';
  }

  Map<String,dynamic> toJson(){
    return {
      'cod': cod,
      'stagenumber':stagenumber,
      'title':title,
      'description':description,
      'image':image,
      'createdBy':createdBy,
      'type':type,
      'file':file,
      'position':position,
      'blocked':blocked
    };
  }

  factory Content.fromJson(json){
    return Content(
      cod: json['cod'],
      stagenumber: json['stagenumber'],
      title: json['title'],
      description: json['description'],
      createdBy: json['createdBy'],
      image: json['image'],
      type: json['type'],
      file: json['file'],
      position: json['position'],
      blocked: json['blocked']
    );
  }

  // funciones ?? 
  //takecontent ????
  // edit ????



}
