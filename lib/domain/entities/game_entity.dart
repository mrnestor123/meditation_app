

import 'package:flutter/material.dart';

import 'content_entity.dart';

class Game extends Content {
  final List<Question> questions = new List.empty(growable: true);

  String video;

  Game(
      {cod,
      @required title,
      image,
      stagenumber,
      type,
      position,
      @required description,
      this.video
      })
      : super(
            cod: cod,
            title: title,
            type: type,
            image: image,
            stagenumber: stagenumber,
            description: description,
            position: position);


  void setQuestions(json) {
    for(var question in json){
      questions.add(Question.fromJson(question));
    }
  }

}


class Question {
  String question, key;
  
  List<dynamic> options;
  int answer;

  Question({this.question,this.options,this.answer, this.key});

  bool isValid(int ans){
    return ans == this.answer;
  }  

  factory Question.fromJson(Map<String, dynamic> json) => Question(
      answer: json["answer"] == null ? 0 : json['answer'] is String ? int.parse(json["answer"]) : json['answer'],
      options: json['options'] == null ? [] : json['options'],
      question: json['question'] == null ? null : json['question'],
      key: json['key'] == null ?null : json['key']
    );

  Map<String, dynamic> toJson() => {
      "answer": answer == null ? null : answer,
      "options":options == null ? null : options,
      "question": question == null ? null : question,
      'key': key == null ? null : key
  };

}