
// Para las acciones que hace el usuario
import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';

class UserAction {
  IconData icono;
  String username, message, type, hour;
  User user;
  dynamic action;
  DateTime time;

  UserAction({this.type, this.time, this.action, this.user}){
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
      hour = DateTime.now().hour.toString() + ':' + DateTime.now().minute.toString();
    }else{
      hour = time.hour.toString() + ':' + time.minute.toString();
    }
    this.username = user.nombre;
    this.message = types[type]();    
    this.icono = icons[type];
  }
  
  Map<String, dynamic> toJson() => {
      "time": time == null ? null : time.toIso8601String(),
      'message': message == null ? null : message,
      'hour': hour == null ? null : hour
  };

}