
/*
  types can be: classrequest, text ?

*/
class Message{
  String type;
  String username;
  DateTime date;
  String text;
  String coduser;
  String message;
  bool confirmed;

  Message({this.coduser,this.date,this.username,this.type,this.text});

  Map<String,dynamic> toJson(){
    return {
      'username': username,
      'text':text,
      'date':date.toIso8601String(),
      'coduser':coduser,
      'type':type
    };
  }

  factory Message.fromJson(json){
    return Message(
      coduser: json['coduser'],
      date: DateTime.parse(json['date']).toLocal(),
      username: json['username'],
      type: json['type'],
      text: json['text']
    );
  }
}