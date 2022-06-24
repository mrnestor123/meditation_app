

import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';

import '../../domain/entities/content_entity.dart';
import 'lesson_model.dart';

Content medorLessfromJson(json, bool isMeditation){
  // es el mismo código repetido !!!! NO SE COMO NO DESREPETIRLO :(
  if(isMeditation){
    return MeditationModel(
      cod: json['cod'],
      stagenumber: json['stagenumber'] == null || json['stagenumber'] is String  ? null : json['stagenumber'],
      title: json['title'],
      createdBy: json['createdBy'] != null && json['createdBy'] is User ? UserModel.fromJson(json['createdBy'],false) : null,
      description: json['description'],
      image: json['image'],
      type: json['type'],
      file: json['file'] == null ? '' : json['file'],
      position: json['position']
    );
  }else {
    return LessonModel(
      cod: json['cod'],
      stagenumber: json['stagenumber'] == null || json['stagenumber'] is String  ? null : json['stagenumber'],
      title: json['title'],
      description: json['description'],
      createdBy: json['createdBy'] != null && json['createdBy'] is User ? UserModel.fromJson(json['createdBy'],false) : null,

    //  createdBy: json['createdBy'] != null ? UserModel.fromJson(json['createdBy'],false) : null,
      image: json['image'],
      type: json['type'],
      file: json['file'] == null ? '' : json['file'],
      position: json['position']
    );
  }
}