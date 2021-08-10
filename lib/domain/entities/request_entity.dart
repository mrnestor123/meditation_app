import 'package:http/http.dart';

class Request {
  String cod;
  String username;
  String type;
  String description;
  String coduser;
  String state;
  List<Comment> comments;
  int points;
  Map<String,dynamic> votes;
  String title;

  Request(
      {this.cod,
      this.username,
      this.type,
      this.description,
      this.coduser,
      this.state,
      this.comments,
      this.points,
      this.votes,
      this.title});

  Request.fromJson(Map<String, dynamic> json) {
    this.cod = json['cod'];
    this.username = json['username'];
    this.type = json['type'];
    this.description = json['description'];
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
    data['description'] = this.description;
    data['coduser'] = this.coduser;
    data['state'] = this.state;
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    data['points'] = this.points;
    if (this.votes != null) {
      data['votes'] = this.votes;
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
    if(points > 0){
      if(votes[cod] == null){
      this.points--;
      this.votes[cod] = -1;
      }else if(votes[cod] == -1){
      this.points++;
      this.votes.removeWhere((key, value) => key == cod);
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

  }
}

class Comment{
  String _comment;
  String _username;
  String _coduser;

  Comment({String comment, String username, String coduser}) {
    this._comment = comment;
    this._username = username;
    this._coduser = coduser;
  }


  Comment.fromJson(Map<String, dynamic> json) {
    _comment = json['comment'];
    _username = json['username'];
    _coduser = json['coduser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment'] = this._comment;
    data['username'] = this._username;
    data['coduser'] = this._coduser;
    return data;
  }
}

