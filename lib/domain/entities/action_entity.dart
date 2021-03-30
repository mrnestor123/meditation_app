
// Para las acciones que hace el usuario
import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';

class UserAction {
  IconData icono;
  String username, message, type, hour, coduser;
  dynamic action;
  DateTime time;

  UserAction({this.type, this.time, this.action, this.username, this.coduser}){
    var icons = {
      'follow' : Icons.person_add,
      'unfollow': Icons.person_remove,
      'meditation': Icons.self_improvement,
      'guided_meditation': Icons.self_improvement,
      'updatestage': Icons.landscape,
      'game': Icons.games,
      'lesson' : Icons.book
    };
    var types = {
      "follow": () => "followed " + action,
      "unfollow": () => "unfollowed " + action,
      "meditation": () => 'meditated for ' + action[0].toString() + ' min',
      "guided_meditation": () => "took " + action[0].toString() + ' for ' + action[1].toString() + ' min',
      "updatestage": () => "climbed up one stage to " + action,
      'game': () => 'played ',
      'lesson': () => 'read ' + action
    };

    if(time == null){
      this.time = DateTime.now();
      hour = DateTime.now().hour.toString() + ':' + DateTime.now().minute.toString();
    }else{
      var localdate = time.toUtc().toLocal();
      hour = localdate.hour.toString() + ':' + localdate.minute.toString();
    }

    this.message = types[type]();    
    this.icono = icons[type];
  }
  
  //un pateo crear otra clase para estos dos
  Map<String, dynamic> toJson() => {
      "time": time == null ? null : time.toIso8601String(),
      "type": type == null ? null: type,
      "username": username == null ? null : username,
      "action": action == null ? null : action,
      "coduser": coduser == null ? null: coduser
  };

  factory UserAction.fromJson(Map<String, dynamic> json) => UserAction(
      time: json["time"] == null ? null : DateTime.parse(json["time"]),
      type: json["type"] == null ? null : json["type"],
      username: json["username"] == null ? null : json["username"],
      coduser: json['coduser'] == null ? null : json['coduser'],
      action: json['action'] == null ? null : json['action']);

}