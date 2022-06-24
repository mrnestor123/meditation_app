
/*
  types can be: classrequest, text ?

*/
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:uuid/uuid.dart';


// TIPES  PUEDEN SER 
// text: mensaje normal 1 a 1
// request: para pedir una clase
// broadcast: mensaje para todo el mundo


class Message{
  String cod, username,text,type,sender, userImage;
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
      read: json['read'] != null  ? json['read'] : false,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null
    );
  }
}




class Chat{
  List<Message> messages = new List.empty(growable:true);
  String codchat,userimage,username, coduser;
  Message lastMessage;
  // en los casos de que el chat es nuevo, tenemos que saber algo !!!
  // User me, receiver;

  // AQUI SE GUARDAN LOS DOS USUARIOS DEL CHAT
  Map<String,dynamic> notMe = new Map();
  Map<String,dynamic> me = new Map();


  Chat({this.codchat, this.lastMessage,  this.notMe, this.me });


  // AÑADIR FUNCIÓN LEER CHAT !!!
  // Se utiliza ???
  Map<String,dynamic> toJson(){
    return {
      'codchat':codchat,
      'users': notMe['coduser'] != null && me['coduser'] != null  ? [notMe['coduser'], me['coduser']] : '',
      'lastMessage':lastMessage.toJson(),
      'me':me,
      'notMe':notMe
    };
  }

  // HAY QUE SABER QUIEN ES QUIEN !!!
  factory Chat.fromJson(json, [user]){
    Map<String,dynamic> userMe;
    Map<String,dynamic> userNotMe;

    json['users'].forEach((key,value){
      key == user.coduser ?  userMe = value : userNotMe = value;
    });

    Chat c = Chat(
      codchat: json['cod'],
      lastMessage: json['lastMessage'] != null && json['lastMessage'] != '' ? Message.fromJson(json['lastMessage']) : null,
      me:userMe,
      notMe: userNotMe
    );

    if(json['messages'] != null && json['messages'].isNotEmpty){
      for(var message in json['messages']){
        c.messages.add(Message.fromJson(message));
      }
    }
    return c;
  }
}