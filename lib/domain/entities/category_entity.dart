

import 'package:meditation_app/domain/entities/content_entity.dart';

class AppCategory {
  String title,  description, image;

  List<Content> content = new List.empty(growable: true);


  AppCategory({this.title, this.description, this.image, this.content});


  AppCategory.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    image = json['image'];
    
    if (json['content'] != null) {
      content = new List<Content>.empty(growable: true);
      json['content'].forEach((v) {
        content.add(new Content.fromJson(v));
      });
    }
  }

}