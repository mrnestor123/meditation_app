

import 'package:flutter/material.dart';

import 'content_entity.dart';

class Game extends Content {
  List<Question> questions = new List.empty(growable: true);

  String video;

  Game(
      {cod,
      @required title,
      image,
      stagenumber,
      type,
      position,
      @required description,
      this.questions,
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
    json.map((j) => this.questions.add(Question.fromJson(j)));
  }

}


class Question {
  String question;
  String answer;

  Question({this.question,this.answer});

  bool isValid(String ans){
    return ans == this.answer;
  }  

  factory Question.fromJson(Map<String, dynamic> json) => Question(
      answer: json["answer"] == null ? json['answer'] : json["answer"],
      question: json['question'] == null ? null : json['question']
    );

  Map<String, dynamic> toJson() => {
      "answer": answer == null ? null : answer,
      "question": question == null ? null : question
  };

}