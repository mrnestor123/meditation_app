
/*
  types can be: classrequest, text ?

*/
import 'package:meditation_app/data/models/userData.dart';


// TIPES  PUEDEN SER 
// text: mensaje normal 1 a 1
// request: para pedir una clase
// broadcast: mensaje para todo el mundo


class Message{
  String username,text,type,sender;
  DateTime date;
  dynamic receiver;
  bool confirmed, read, deleted;
  UserModel user;

  Message({this.sender, this.date,this.receiver, this.username,this.type,this.text,this.read = false, this.deleted = false});


  Map<String,dynamic> toJson(){
    return {
      'username': username,
      'text':text,
      'date':date.toIso8601String(),
      'sender':sender,
      'receiver': receiver is List ? receiver.map((std)=> std.coduser).toList() : receiver,
      'type':type,
      'read':read
    };
  }

  factory Message.fromJson(json){
    return Message(
      sender: json['sender'],
      receiver: json['receiveer'],
      date: DateTime.parse(json['date']).toLocal(),
      username: json['username'],
      type: json['type'],
      text: json['text'],
      read: json['read'] != null  ? json['read']: false
      //user: json['user'] != null ? UserModel.fromJson(json['user']) : null
    );
  }
}