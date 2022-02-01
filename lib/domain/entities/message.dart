
/*
  types can be: classrequest, text ?

*/
import 'package:meditation_app/data/models/userData.dart';
import 'package:uuid/uuid.dart';


// TIPES  PUEDEN SER 
// text: mensaje normal 1 a 1
// request: para pedir una clase
// broadcast: mensaje para todo el mundo


class Message{
  String cod, username,text,type,sender;
  DateTime date;
  dynamic receiver;
  bool confirmed, read, deleted;
  UserModel user;

  Message({this.cod,this.sender, this.date,this.receiver, this.username, this.user,
    this.type,this.text,this.read = false, this.deleted = false}){
    if (cod == null) {
      var uuid = Uuid();
      this.cod = uuid.v1();
    } else {
      this.cod = cod;
    }
}


  Map<String,dynamic> toJson(){
    return {
      'cod':cod,
      'username': username,
      'text':text,
      'date':date.toIso8601String(),
      'sender':sender,
      'receiver': receiver is List ? receiver.map((std)=> std is String ? std : std.coduser).toList() : receiver,
      'type':type,
      'read':read,
      'deleted':deleted
    };
  }

  factory Message.fromJson(json){
    return Message(
      cod: json['cod'],
      sender: json['sender'],
      receiver: json['receiver'],
      date: DateTime.parse(json['date']).toLocal(),
      username: json['username'],
      type: json['type'],
      text: json['text'],
      deleted: json['deleted'],
      read: json['read'] != null  ? json['read']: false,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null
    );
  }
}