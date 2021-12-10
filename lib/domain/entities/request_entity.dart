import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:uuid/uuid.dart';

//intento de hacer enum. Muy complicado serializar
//class State{}
// type = issue and suggestion
//  state = open, closed
// states go from open, to in progress, to closed.
class Request {
  dynamic cod;
  String username,type,content,coduser,state,title,image,userimage;

  DateTime date;
  List<Comment> comments = new List.empty(growable: true);
  int points;
  Map<String,dynamic> votes = new Map();

  Request(
      {this.cod,
      this.username,
      this.type,
      this.content,
      this.date,
      this.coduser,
      this.state,
      this.points = 0,
      this.image,
      this.userimage,
      this.title}){

    if (cod == null) {
      var uuid = Uuid();
      this.cod = uuid.v1();
    } else {
      this.cod = coduser;
    }     

    if(this.date == null){
      date = DateTime.now();
    }
    
  }

  Request.fromJson(Map<String, dynamic> json) {
    this.cod = json['cod'];
    this.username = json['username'];
    this.image = json['image'];
    this.type = json['type'];
    this.content = json['content'] == null ? json['description'] : json ['content'];
    this.coduser = json['coduser'];
    this.userimage = json['userimage'];
    this.state = json['state'];
    this.date = json['date'] == null ? DateTime.now().subtract(Duration(days: 30))  : DateTime.parse(json["date"]).toLocal();
    //ESTO SE PUEDE HACER EN OTROS SITIOS
    if (json['comments'] != null) {
      json['comments'].forEach((v) {
        this.comments.add(new Comment.fromJson(v));
      });
    }
    this.points = json['points'];
    this.votes = json['votes'] != null ? json['votes'] : new Map<String,dynamic>();
  
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cod'] = this.cod;
    data['type'] = this.type;
    data['content'] = this.content;
    data['coduser'] = this.coduser;
    data['state'] = this.state;
    data['image'] = this.image;
    data['date'] = this.date.toIso8601String();
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }else{
      data['comments'] = [];
    }
    data['points'] = this.points;
    if (this.votes != null) {
      data['votes'] = this.votes;
    }else{
      data['votes'] = {};
    }
    data['title'] = this.title;
    return data;
  }

  String getState(){
    if(this.state =='open'){
      return 'Open';
    }else if(this.state == 'inprogress'){
      return 'In Progress';
    }else{
      return 'Closed';
    }
  }

  Color getColor(){
    if(this.state =='open'){
      return Colors.green;
    }else if(this.state == 'inprogress'){
      return Colors.yellow;
    }else{
      return Colors.red;
    }
  }

  Color nextStateColor(){
    if(this.state =='open'){
      return Colors.yellow;
    }else if(this.state == 'inprogress'){
      return Colors.red;
    }else{
      return Colors.green;
    }
  }


  String nextState(){
    if(this.state =='open'){
      return 'in progress';
    }else if(this.state == 'inprogress'){
      return 'closed';
    }else{
      return 'open';
    }
  }


  void changeState(User u){
     if(this.state =='open'){
      this.state = 'inprogress';
    }else if(this.state == 'inprogress'){
      this.state = 'closed';
    }else {
      this.state ='open';
    }

    //this.comments.add(Comment(comment: 'Has changed state of the request to ' + this.getState(), username: u.nombre,coduser: u.coduser));
  }

  void like(String cod){
    if(votes[cod] == null){
      this.points++;
      this.votes[cod] = 1;
    }else if(votes[cod] == 1){
      this.points--;
      this.votes.removeWhere((key, value) => key == cod);
    }else{
      this.points +=2 ;
      this.votes[cod] = 1;
    } 
  }
  

  void dislike(String cod){
    if(votes[cod] == -1){
      this.points++;
      this.votes.removeWhere((key, value) => key == cod);
    }else if(points > 0 ){
      if(votes[cod] == null){
        this.points--;
        this.votes[cod] = -1;
      }else if(votes[cod] == 1){
        print('ha votado');
        this.points--;
        if(this.points > 0){
          this.points--;
          this.votes[cod] = -1;
        }else{
          this.votes.removeWhere((key, value) => key == cod);
        }
      } 
    }
  }


  void comment(Comment c){
    if(this.comments == null){
      this.comments = new List.empty(growable: true);
    }

    this.comments.add(c);
  }
}

class Comment{
  String comment;
  String username;
  String coduser;

  Comment({this.comment, this.username, this.coduser});


  Comment.fromJson(Map<String, dynamic> json) {
    this.comment = json['comment'];
    this.username = json['username'];
    this.coduser = json['coduser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment'] = this.comment;
    data['username'] = this.username;
    data['coduser'] = this.coduser;
    return data;
  }
}


