
/*
  types can be: classrequest, body ?

*/
import 'package:uuid/uuid.dart';


// TIPES  PUEDEN SER 
// body: mensaje normal 1 a 1
// request: para pedir una clase
// broadcast: mensaje para todo el mundo
class Message{
  String cod, body,sender; 
  DateTime date;
  dynamic receiver;

  Message({this.cod,this.sender, this.date,this.receiver, this.body}){
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
      'body':body,
      'date':date.toIso8601String(),
      'sender':sender,
      'receiver': receiver is List ? receiver.map((std)=> std is String ? std : std.coduser).toList() : receiver,
    };
  }

  factory Message.fromJson(json){
    return Message(
      cod: json['cod'],
      sender: json['sender'],
      receiver: json['receiver'],
      date: DateTime.parse(json['date']).toLocal(),
      body: json['body']
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
  List<String> users = new List.empty(growable: true);


  Chat({this.codchat, this.lastMessage,  this.notMe, this.me });

  Map<String,dynamic> toJson(){
    return {
      'codchat':codchat,
      'lastMessage':lastMessage.toJson(),
      'users':{
        notMe['coduser'] :true,
        me['coduser']:true
      },
      notMe['coduser']: notMe,
      me['coduser'] : me    
    };
  }

  // HAY QUE SABER QUIEN ES QUIEN !!!
  factory Chat.fromJson(json, [user]){
    Map<String,dynamic> userMe;
    Map<String,dynamic> userNotMe;

    json['users'].forEach((key,value){
      key == user.coduser ? userMe = value : userNotMe = value;
    });

    Chat c = Chat(
      codchat: json['cod'],
      lastMessage: json['lastMessage'] != null && json['lastMessage'] != '' ? Message.fromJson(json['lastMessage']) : null,
      notMe: userNotMe,
      me: userMe
    );

    if(json['messages'] != null && json['messages'].isNotEmpty){
      for(var message in json['messages']){
        c.messages.add(Message.fromJson(message));
      }
    }
    return c;
  }
}