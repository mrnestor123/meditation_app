import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

//type issue and suggestion
//state open, closed
class Request {
  dynamic cod;
  String username,type,content,coduser,state,title;
  List<Comment> comments;
  int points;
  Map<String,dynamic> votes;
  Uuid _uiddd = Uuid();

  Request(
      {this.cod,
      this.username,
      this.type,
      this.content,
      this.coduser,
      this.state,
      this.comments,
      this.points = 0,
      this.votes,
      this.title}){

    if (cod == null) {
      var uuid = Uuid();
      this.cod = uuid.v1();
    } else {
      this.cod = coduser;
    }     
  }

  Request.fromJson(Map<String, dynamic> json) {
    this.cod = json['cod'];
    this.username = json['username'];
    this.type = json['type'];
    this.content = json['content'] == null ? json['description'] : json ['content'];
    this.coduser = json['coduser'];
    this.state = json['state'];
    //ESTO SE PUEDE HACER EN OTROS SITIOS
    if (json['comments'] != null) {
      this.comments = new List.empty(growable: true);
      json['comments'].forEach((v) {
        this.comments.add(new Comment.fromJson(v));
      });
    }
    this.points = json['points'];
    this.votes = json['votes'] != null ? json['votes'] : null;
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cod'] = this.cod;
    data['username'] = this.username;
    data['type'] = this.type;
    data['content'] = this.content;
    data['coduser'] = this.coduser;
    data['state'] = this.state;
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
        this.points--;
        if(this.points > 0){
          this.points--;
        }
        this.votes[cod] = -1;
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

