

import 'content_entity.dart';

class Path{
  String title,description,image;

  bool isNew;
  List<Content> content = new List.empty(growable: true);

  Path({this.title,this.description,this.image, this.isNew = false});

  factory Path.fromJson(json, [user]){
    Path p = Path(
      title: json['title'],
      description: json['description'],
      image: json['image'],
      isNew: json['isNew'] != null ? json['isNew']: false
    );

    if(json['content'] != null && json['content'].isNotEmpty){
      for(var content in json['content']){
        p.content.add(Content.fromJson(content));
      }

      p.content.sort((a,b)=> (a.position  != null ? a.position : 100) - (b.position != null ? b.position : 100));
    }

    return p;
  }

}