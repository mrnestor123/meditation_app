import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';




/*
*
* ALL THE CLASSES CONTENT IN THE APP IS IN THIS FILE
*
*/
class Content {
  String cod, title, description, image, type, category, group;
  int stagenumber, position;
  bool blocked, isNew, tmi;
  Map<String,dynamic> createdBy = new Map<String,dynamic>();

  Content({cod, @required this.stagenumber,this.isNew = false, this.title,
    this.createdBy, this.description, this.image, this.type, this.position = 0, this.blocked,
    this.category, this.group, this.tmi
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

  IconData getCategoryIcon(){
    if(category == 'mind'){
      return Icons.psychology;
    } else if(category == 'philosophy'){
      return Icons.history_edu;
    } else if(category == 'meditation'){
      return Icons.self_improvement;
    }
  
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
      category: json['category'],
      tmi: json['tmi'] !=null ? json['tmi'] : false
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
    group,
    this.file,
    this.total
  }) : super(
    cod: cod, 
    group: group,
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
      group: json['group'],
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


// AÑADIMOS AQUÍ MEDITACIONES, JUEGOS Y LECCIONES


// HAY QUE CREAR LA CLASE RECORDING !!!!
class Recording extends Content {


}


/*
*
* LESSON
*
*/

class Lesson extends Content {
  List<dynamic> text;
 
  Lesson({
    cod,
    @required title,
    image,
    stagenumber,
    type,
    position,
    createdBy,
    file,
    blocked,
    isNew,
    category,
    group,
    tmi,
    @required description,
    @required this.text
  }) : 
  super(
    isNew:isNew,
    group: group,
    tmi: tmi,
    category: category,
    cod: cod,
    title: title,
    blocked:blocked,
    type: type,
    image: image,
    stagenumber: stagenumber,
    description: description,
    createdBy:createdBy,
    position: position
  );
}




/*
*
* GAMES
*
*/
class Game extends Content {
  final List<Question> questions = new List.empty(growable: true);

  String video;

  Game({cod, @required title, image, stagenumber,
    type, position, @required description, this.video }) : 
    super(cod: cod, title: title, type: type, image: image,
      stagenumber: stagenumber, description: description, position: position);


  void setQuestions(json) {
    for(var question in json){
      questions.add(Question.fromJson(question));
    }
  }
}

class Question {
  String question, key;
  
  List<dynamic> options;
  int answer;

  Question({this.question,this.options,this.answer, this.key});

  bool isValid(int ans){
    return ans == this.answer;
  }  

  factory Question.fromJson(Map<String, dynamic> json) => Question(
      answer: json["answer"] == null ? 0 : json['answer'] is String ? int.parse(json["answer"]) : json['answer'],
      options: json['options'] == null ? [] : json['options'],
      question: json['question'] == null ? null : json['question'],
      key: json['key'] == null ?null : json['key']
    );

  Map<String, dynamic> toJson() => {
      "answer": answer == null ? null : answer,
      "options":options == null ? null : options,
      "question": question == null ? null : question,
      'key': key == null ? null : key
  };

}



