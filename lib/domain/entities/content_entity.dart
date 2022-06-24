import 'package:flutter/material.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/presentation/pages/commonWidget/file_helpers.dart';
import 'package:uuid/uuid.dart';

class Content {
  String cod, title, description, image, type,file;
  User createdBy;
  int stagenumber, position;
  bool blocked;

  Content({cod, @required this.stagenumber, this.title,this.createdBy, this.description, this.image, this.type, this.position, this.blocked, this.file = ''}) {
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
      'createdBy':createdBy.coduser,
      'type':type,
      'file':file,
      'position':position,
      'blocked':blocked
    };
  }

  IconData getIcon(){
    if(this.file.isNotEmpty){
      return isAudio(this.file) ? Icons.audiotrack : Icons.browse_gallery;
    }else {
      return Icons.abc;
    }
  }

  String getText(){
    if(this.file.isNotEmpty){
      return isAudio(this.file) ? 'Audio' : 'Video';
    }else {
      return 'Text';
    }
  }




}