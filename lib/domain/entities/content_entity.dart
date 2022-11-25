import 'package:flutter/material.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/presentation/pages/commonWidget/file_helpers.dart';
import 'package:uuid/uuid.dart';

class Content {
  String cod, title, description, image, type,file, doneBy;
  int stagenumber, position;
  bool blocked, isNew;
  Map<String,dynamic>  createdBy = new Map<String,dynamic>();
  
  Duration done, total;

  Content({cod, @required this.stagenumber,this.isNew, this.done, this.doneBy, this.total, this.title,this.createdBy, this.description, this.image, this.type, this.position, this.blocked, this.file}) {
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

  bool isRecording(){
    return type =='recording';
  }

  bool isVideo(){
    return type =='video';
  }
  
  bool isLesson() {
    return type =='lesson' || type == 'meditation';
  }

  Map<String,dynamic> toJson(){
    return {
      'cod': cod,
      'stagenumber':stagenumber,
      'title':title,
      'description':description,
      'type':type,
      // ESTO NO DEBERÍA DE ESTAR AQUI !!!
      'done':done != null  ? done.inMinutes : 0,
      'total':total != null ? total.inMinutes: 0,
      'doneBy': doneBy
    };
  }

  Map<String,dynamic> toFullJson(){
    return {
      'cod': cod,
      'stagenumber': stagenumber,
      'title': title,
      'description': description,
      'type': type,
      // ESTO NO DEBERÍA DE ESTAR AQUI !!! O
      'done': done != null  ? done.inMinutes : 0,
      'total': total != null ? total.inMinutes: 0,
      "file": file != null ? file : '',
      'doneBy': doneBy,
      "image": image != null ? image :''
    };
  }

  IconData getIcon(){
    return isRecording() ? Icons.audiotrack :
      isVideo() ? Icons.ondemand_video : 
      isMeditation() ? Icons.self_improvement
      : Icons.book;
  }

  String getText(){
    if(this.file.isNotEmpty){
      return isAudio(this.file) ? 'Audio' : 'Video';
    }else {
      return 'Text';
    }
  }

  factory Content.fromJson(json){
    return Content(
      cod: json['cod'],
      stagenumber: json['stagenumber'] == null || json['stagenumber'] is String  ? null : json['stagenumber'],
      title: json['title'],
      createdBy: json['createdBy'] != null && json['createdBy'] is Map && json['createdBy'].entries.length > 0  ? json['createdBy'] : null,
      description: json['description'],
      image: json['image'],
      type: json['type'],
      done: json['done'] != null ? json['done'] is String ? Duration(minutes: int.parse(json['done'])) : Duration(minutes: json['done']) : null,
      // ESTO NO DEBERÍA ESTAR AQUÍ!!!
      total: json['duration'] != null ?  json['duration'] is String ? Duration(minutes: int.parse(json['duration'])) : Duration(minutes: json['duration']): null,
      file: json['file'] == null ? '' : json['file'],
      position: json['position']
    );
  }
}


// HAY QUE CREAR LA CLASE RECORDING !!!!
class Recording extends Content {


}



