

import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:uuid/uuid.dart';

class Retreat {
  DateTime startDate,endDate;
  TimeOfDay startTime,endTime;
  String cod, name, description, image;
  List<User> users = new List.empty(growable: true);


  List<Activity> activities = new List.empty(growable: true);


  Retreat({this.cod, this.startDate, this.endDate, this.startTime,this.endTime, this.name, this.description, this.image}){

    if (cod == null) {
      var uuid = Uuid();
      this.cod = uuid.v1();
    } else {
      this.cod = cod;
    }
  }

  Map<String,dynamic> toJson(){
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'startTime': timeToString(startTime),
      'endTime': timeToString(endTime),
      'name': name,
      'description': description,
      'image': image,
      'users': users.map((e)=> e.coduser).toList(),
      'activities': activities.map((e)=>e.toJson()).toList()
    };
  }


  factory Retreat.fromJson(Map<String, dynamic> json) {
    Retreat r = new Retreat(
      cod: json['cod'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      startTime: json['startTime'],
      endTime: json['endTime'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      //users: json['users'].map<User>((e) => User.fromJson(e)).toList(),
      //activities: json['activities'].map<Activity>((e) => Activity.fromJson(e)).toList(),
    );


    if(json['activities'] != null){
      json['activities'].forEach((v){
        r.activities.add(new Activity.fromJson(v));
      });
    }

    return r;
  }


}


class Activity {
  String name, image;
  TimeOfDay startTime, endTime;

  Activity({ this.name, this.image, this.startTime, this.endTime});

  Map<String,dynamic> toJson(){
    return {
      'name': name,
      'image': image,
      'startTime':timeToString(startTime),
      'endTime':timeToString(endTime),
    };
  }

  // metodo fromJson 
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      name: json['name'],
      image: json['image'],
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }
}

String timeToString(TimeOfDay time){

  String hour = time.hour.toString();
  String minute = time.minute.toString();

  if(time.hour < 10){
    hour = '0' + hour;
  }

  if(time.minute < 10){
    minute = '0' + minute;
  }

  return hour + ':' + minute;
}