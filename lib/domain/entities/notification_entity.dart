

import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/request_entity.dart';
import 'package:uuid/uuid.dart';

class Notify{
  String cod, codrequest, message, type, coduser, usernamedoing,requesttitle, userimage;
  DateTime date;
  Request r;
  bool seen;

  Notify({this.cod,this.codrequest,this.message,this.type = 'comment',this.date,this.r,this.coduser,this.usernamedoing= '',this.requesttitle = '', this.userimage,this.seen}){
    if (cod == null) {
      var uuid = Uuid();
      this.cod = uuid.v1();
    } else {
      this.cod = cod;
    }

    var types =  {
      'comment':'commented on ',
      'state':'changed state of '
    };

    if(message == null){
      this.message = this.usernamedoing + ' ' + types[type] + requesttitle;
    }
  }

  void view(){
    this.seen = true;
  }


  IconData getIcon(){
    if(type == 'comment'){
      return Icons.comment;
    }else{
      return Icons.check_circle;
    }
  }


  factory Notify.fromJson(Map<String, dynamic> json) => Notify(    
    cod : json['cod'],
    codrequest : json['codrequest'],
    coduser: json['coduser'],
    message :json['message'],
    usernamedoing: json['usernamedoing'] != null ? json['usernamedoing']: '',
    requesttitle: json['requesttitle'] != null ? json['requesttitle']: '',
    userimage: json['userimage'],
    type: json['type'] != null ? json['type']: 'comment',
    seen: json['seen'] != null ? json['seen'] : false,
    r: json['request'] != null ? Request.fromJson(json['request']): null,
    date : json["date"] == null ? DateTime.now() : DateTime.parse(json["date"])
  );
  

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cod'] = this.cod;
    data['codrequest'] = this.codrequest;
    data['coduser'] = this.coduser;
    data['requesttitle'] = this.requesttitle;
    data['coduser']= this.coduser;
    data['usernamedoing']= this.usernamedoing; 
    data['type'] = this.type;
    data['seen'] = this.seen;
    data['date'] = this.date == null ? DateTime.now().toIso8601String() : this.date.toIso8601String();
    return data;
  }
}