

import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/data/models/meditationData.dart';

import 'content_entity.dart';


/// CAMBIAR EL NOMBRE DE PATH !!!!!
class Course  {
  String cod,title,description,image, createdBy;
  bool isNew;

  List<Content> content = new List.empty(growable: true);

  Course({this.title,this.description,this.image, this.isNew = false,this.cod});

  //  para que hace falta el user  ???
  factory Course.fromJson(json, [user]){
    Course p = Course(
      cod: json['cod'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      isNew: json['isNew'] != null ? json['isNew']: false
    );

    if(json['content'] != null && json['content'].isNotEmpty){
      for(var content in json['content']){
        if(content['type'] == 'meditation-practice'){
          p.content.add(MeditationModel.fromJson(content));
        }else if(content['type']=='video' || content['type'] == 'recording'){
          p.content.add(Content.fromJson(content));
        }else{
          p.content.add(LessonModel.fromJson(content));
        }
      }

      p.content.sort((a,b)=> (a.position  != null ? a.position : 100) - (b.position != null ? b.position : 100));

    }

    return p;
  }

}