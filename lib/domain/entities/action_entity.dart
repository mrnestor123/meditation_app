
// Para las acciones que hace el usuario
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';

class UserAction {
  IconData icono;
  String username, userimage, message, type, hour, coduser, day;
  User user;
  dynamic action;
  DateTime time;

  String getAction(action) {
    String str = '';

    if(action is List){
      for(var a in action){
        str += a;
      }
    } else {
      str = action;
    }

    return str;
  }


  void setAction(action){ 
    if(this.action is List) {
      this.action.add(action[0]);
    }

    this.message += ', ' + action[0];
  }

  UserAction({this.type, this.time, this.action, this.username, this.coduser,this.message, this.userimage, this.user}){
    if(this.message == null){
   
    var types = {
      "follow": () => "followed " + getAction(action),
      "unfollow": () => "unfollowed " + getAction(action),
      "meditation": () => 'meditated for ' + action[0].toString() + ' min',
      "guided_meditation": () => "took " + action[0].toString() + ' for ' + action[1].toString() + ' min',
      "updatestage": () => "climbed up one stage to " + action,
      'game': () => 'played ',
      'lesson': () => 'read ' + getAction(action)
    };
    this.message = types[type]();   
    } 

    if(time == null){
      this.time = DateTime.now();
      hour = DateTime.now().hour.toString() + ':' + DateTime.now().minute.toString();
      day = DateTime.now().day.toString() + '-' + DateTime.now().month.toString();
    } else {
      var localdate = time.toLocal();
      hour = localdate.hour.toString() + ':' + (localdate.minute.toString().length > 1 ? localdate.minute.toString() : '0' + localdate.minute.toString() );
      day = localdate.day.toString() + '-' + localdate.month.toString();
    }

    if(user != null && userimage == null){
      this.userimage = user.image;
    } 

    var icons = {
      'follow' : Icons.person_add,
      'unfollow': Icons.person_remove,
      'meditation': Icons.self_improvement,
      'guided_meditation': Icons.self_improvement,
      'updatestage': Icons.landscape,
      'game': Icons.games,
      'lesson' : Icons.book
    };
    this.icono = icons[type];
    
  }

  //un pateo crear otra clase para estos dos
  Map<String, dynamic> toJson() => {
      "time": time == null ? null : time.millisecondsSinceEpoch,
      "type": type == null ? null: type,
      "username": username == null ? null : username,
      "action": action == null ? null : action,
      "message": message == null ? null : message,
      "coduser": coduser == null ? null: coduser
  };

  factory UserAction.fromJson(Map<String, dynamic> json) => UserAction(
      time: json["time"] == null ? null : DateTime.fromMillisecondsSinceEpoch(json["time"]),
      user: json['user'] == null ? null : UserModel.fromJson(json['user']),
      message: json['message'] == null ? null : json['message'],
      userimage: json['userimage'] == null ? null : json['userimage'],
      type: json["type"] == null ? null : json["type"],
      username: json["username"] == null ? null : json["username"],
      coduser: json['coduser'] == null ? null : json['coduser'],
      action: json['action'] == null ? null : json['action']);

}