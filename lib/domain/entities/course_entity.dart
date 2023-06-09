

import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';

import 'content_entity.dart';


/// CAMBIAR EL NOMBRE DE PATH !!!!!
class Course  {
  String cod,title,description,longdescription, image, createdBy;
  int price;
  bool isNew,  showStudents, allowChat;

  DateTime startDate, endDate;

  List<Content> content = new List.empty(growable: true);
  List<User> students = new List.empty(growable: true);
  List<Announcement> announcements = new List.empty(growable: true);

  Course({
    this.title,this.description,this.image, this.isNew = false,this.cod, 
    this.showStudents = false, this.allowChat = false, this.longdescription = '', 
    this.price=0, this.startDate, this.endDate
  });

  //  para que hace falta el user  ???
  factory Course.fromJson(json, [user]){
    Course p = Course(
      cod: json['cod'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      showStudents: json['showStudents'] != null ? json['showStudents']: false,
      allowChat: json['allowChat'] != null ? json['allowChat']: false,
      longdescription: json['longdescription'] != null ? json['longdescription']: '',
      isNew: json['isNew'] != null ? json['isNew']: false,
      price: json['price'] != null ? json['price']: 0,
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']):null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']):null,
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

    if(json['Announcements'] != null){
      for(var announcement in json['Announcements']){
        p.announcements.add(Announcement.fromJson(announcement));
      }
    }

    return p;
  }
}



class Announcement {

  DateTime startDate, endDate;
  String title, description, image, cod;

  Announcement({this.startDate,this.endDate,this.title,this.description,this.image,this.cod});


  factory Announcement.fromJson(json){
    Announcement e = Announcement(
      cod: json['cod'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']):null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']):null
    );

    return e;
  }
}