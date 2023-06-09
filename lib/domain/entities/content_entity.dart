import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';


// AQUI DEBERÍAN DE ESTAR TODAS LAS CLASES DE CONTENT !!
class Content {
  String cod, title, description, image, type, category;
  int stagenumber, position;
  bool blocked, isNew;
  Map<String,dynamic> createdBy = new Map<String,dynamic>();

  Content({cod, @required this.stagenumber,this.isNew = false, this.title,
    this.createdBy, this.description, this.image, this.type, this.position = 0, this.blocked,
    this.category
  }) {
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
    return type =='lesson' || type == 'meditation' || type =='brain' || type == 'mind';
  }

  bool isTechnique(){
    return type == 'technique';
  }

  Map<String,dynamic> toJson(){
    return {
      'cod': cod,
      'stagenumber':stagenumber,
      'title':title,
      'description':description,
      'type':type,
    };
  }

  Map<String,dynamic> toFullJson(){
    return {
      'cod': cod,
      'stagenumber': stagenumber,
      'title': title,
      'description': description,
      'type': type,
      "image": image != null ? image :''
    };
  }

  IconData getIcon(){
    return isRecording() ? Icons.multitrack_audio :
      isVideo() ? Icons.ondemand_video : 
      isMeditation() ? Icons.self_improvement
      : this.type =='brain' ?
      Icons.psychology : Icons.book;
  }

  String getText(){
    if(isRecording()){
      return 'Audio';
    }else if(isVideo()){
      return 'Video';
    }else if(isMeditation()){
      return 'Meditation';
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
      position: json['position'],
      category: json['category']
    );
  }
}



//  A CONTENT DONE BY USER
class DoneContent extends Content {
  String doneBy;
  Duration total, done;
  DateTime date;
  int timesFinished = 0;

  DoneContent({
    cod,
    this.doneBy, 
    this.total,
    this.date,
    this.done, 
    this.timesFinished,
    @required stagenumber,
    isNew = false, 
    title,
    createdBy, 
    description, 
    image, 
    type, 
    position, 
    blocked,
    file
  }) : super(
    cod: cod, 
    stagenumber: stagenumber, 
    isNew: isNew, 
    title: title,
    createdBy: createdBy, 
    description: description, 
    image: image, 
    type: type, 
    position: position, 
    blocked: blocked 
  );

  // TO JSON
  Map<String,dynamic> toJson(){
    return {
      'cod': cod,
      'stagenumber':stagenumber,
      'date': DateTime.now().millisecondsSinceEpoch,
      'type':type,
      'doneBy':doneBy,
      'total':total != null ? total.inSeconds: 0,
      'done':done != null ? done.inSeconds  : 0,
      'timesFinished':timesFinished
    };
  }

  // FROM JSON
  factory DoneContent.fromJson(json){
    return DoneContent(
      cod: json['cod'],
      stagenumber: json['stagenumber'] == null || json['stagenumber'] is String  ? null : json['stagenumber'],
      title: json['title'],
      createdBy: json['createdBy'] != null && json['createdBy'] is Map && json['createdBy'].entries.length > 0  ? json['createdBy'] : null,
      description: json['description'],
      image: json['image'],
      type: json['type'],
      file: json['file'] == null ? '' : json['file'],
      position: json['position'],
      doneBy: json['doneBy'],
      total: json['total'] == null ? Duration(seconds: 0) : Duration(seconds: json['total']),
      done: json['done'] == null ? Duration(seconds: 0) : Duration(seconds: json['done']),
      date: json['date'] == null ? DateTime.now() : DateTime.fromMillisecondsSinceEpoch(json['date']),
      timesFinished: json['timesFinished'] == null ? 0 : json['timesFinished']
    );
  }
  
}



// FILECONTENT HAS A FILE, AND A DURATION !!
class FileContent extends Content {
  String file;
  Duration total;

  FileContent({
    cod,
    @required stagenumber,
    isNew = false, 
    title,
    createdBy, 
    description, 
    image, 
    type, 
    position, 
    blocked,
    this.file,
    this.total
  }) : super(
    cod: cod, 
    stagenumber: stagenumber, 
    isNew: isNew, 
    title: title,
    createdBy: createdBy, 
    description: description, 
    image: image, 
    type: type, 
    position: position, 
    blocked: blocked 
  );

  // FROM JSON METHOD
  factory FileContent.fromJson(json){ 
    return FileContent(
      cod: json['cod'],
      stagenumber: json['stagenumber'] == null || json['stagenumber'] is String  ? null : json['stagenumber'],
      title: json['title'],
      createdBy: json['createdBy'] != null && json['createdBy'] is Map && json['createdBy'].entries.length > 0  ? json['createdBy'] : null,
      description: json['description'],
      image: json['image'],
      type: json['type'],
      file: json['file'] == null ? '' : json['file'],
      position: json['position'],
      // GUARDAMOS MINUTOS!! DEBERÍAMOS GUARDAR SEGUNDOS
      total: json['total'] == null ? 
        json['duration'] != null ?
          json['duration'] is String ? Duration(minutes: int.parse(json['duration'])) 
          : Duration(minutes: json['duration'])
        : Duration(seconds: 0) 
        : Duration(minutes: json['total'])
    
    
    );
  }





}

// HAY QUE CREAR LA CLASE RECORDING !!!!
class Recording extends Content {


}



