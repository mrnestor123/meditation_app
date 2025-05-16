import 'package:flutter/material.dart';
import 'package:meditation_app/data/models/user_model.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:uuid/uuid.dart';

//intento de hacer enum. Muy complicado serializar
//class State{}
// type = issue and suggestion
//  state = open, closed
// states go from open, to in progress, to closed.
class Request {
  
  dynamic cod, stagenumber;
  String username,type,content,coduser,state,title,image,userimage;

  DateTime date;
  List<Comment> comments = new List.empty(growable: true);
  int points, comentaries;
  Map<String,dynamic> votes = new Map();

  List<dynamic> shortcomments = new List.empty(growable: true);

  List<Request> feed = new List.empty(growable: true);

  Request({
    this.cod,
    this.username,
    this.type,
    this.content,
    this.date,
    this.coduser,
    this.state,
    this.points = 0,
    this.image,
    this.userimage,
    this.comentaries = 0,
    this.stagenumber,
    this.title
  }){

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

  // AQUÍ HAY QUE MIRAR SI SE EXPANDEN O QUE !!!
  Request.fromJson(Map<String, dynamic> json) {
    this.cod = json['cod'];
    this.username = json['username'];
    this.image = json['image'];
    this.type = json['type'];
    this.content = json['content'] == null ? json['description'] : json ['content'];
    this.coduser = json['coduser'];
    this.userimage = json['userimage'];
    this.state = json['state'];
    this.stagenumber = json['stagenumber'];
    this.date = json['date'] == null ? DateTime.now().subtract(Duration(days: 30)): 
      json['date']  is String ? DateTime.parse(json["date"]).toLocal() :
      DateTime.fromMillisecondsSinceEpoch(json['date']).toLocal();


    //ESTO SE PUEDE HACER EN OTROS SITIOS
    if (json['comments'] != null) {
      json['comments'].forEach((v) {
        if(v['username'] != null){
          this.comments.add(new Comment.fromJson(v));
        }else {
        }
      });
    }


    if(json['feed'] != null){
      json['feed'].forEach((v) {
        if(v['username'] != null){
          this.feed.add(new Request.fromJson(v));
        }else {
        }
      });
    }

    this.shortcomments = json['shortComments'] != null ? json['shortComments']: [];

    comentaries = json['comments'] != null ? json['comments'].length : json['shortComments'] != null ? json['shortComments'].length : 0;
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
    data['date'] = this.date.millisecondsSinceEpoch;
    data['stagenumber'] = this.stagenumber;
    
    if (this.comments != null) {
      data['shortComments'] = this.comments.map((v) => v.cod).toList();
    } else {
      data['shortComments'] = [];
    }
    
    data['commentaries'] = this.comentaries;

    data['points'] = this.points;

    if (this.votes != null) {
      data['votes'] = this.votes;
    } else {
      data['votes'] = {};
    }

    
    data['title'] = this.title;
    data['userimage'] = this.userimage;
    data['username'] = this.username;
    
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
      return Colors.orange;
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

    this.shortcomments.add(c.cod);
  }
}

class Comment{
  String comment;
  String username;
  String coduser;
  String userimage, cod, codrequest;
  User user;
  DateTime date;
  List<String> images  = new List.empty(growable: true);

  Comment({this.cod,this.comment, this.username, this.coduser, this.userimage, this.user,this.codrequest,this.date}){
    if (cod == null) {
      this.cod = Uuid().v1();
    } else {
      this.cod = cod;
    }
  }

  Comment.fromJson(Map<String, dynamic> json) {
    this.cod = json['cod'];
    this.comment = json['comment'];
    this.username = json['username'];
    this.coduser = json['coduser'];
    this.userimage = json['userimage'];
    this.codrequest = json['codrequest'];
    this.date = json['date'] != null ? json['date'] is String ? DateTime.parse(json['date']).toLocal() : DateTime.fromMillisecondsSinceEpoch(json['date'])  : null;
    this.user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
  
    if(json['images'] != null){
      this.images = json['images'].cast<String>();
    }
  
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment'] = this.comment;
    data['username'] = this.username;
    data['userimage'] = this.userimage;
    data['codrequest'] = this.codrequest;
    data['coduser'] = this.coduser;
    data['cod'] = this.cod;
    data['date'] = this.date.millisecondsSinceEpoch;

    if(this.images.length>0){
      data['images'] = this.images;
    }

    return data;
  }


}


