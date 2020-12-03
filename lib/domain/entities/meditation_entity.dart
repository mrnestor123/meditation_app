import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Meditation {
  String codmed;
  int xp;
  final String recording;
  //can be a codlesson or a meditation
  final String preceding;
  final int stagenumber;
  final Duration duration;
  final DateTime day;

  List<String> sentences;

  //for referencing the user.
  //final String userId;

  Meditation({this.codmed, @required this.duration, this.recording, this.day,this.stagenumber,this.preceding
      //this.userId
      }) {
    if (this.codmed == null) {
      var uuid = Uuid();
      this.codmed = uuid.v1();
    }
    this.xp = this.duration.inMinutes * 100;
  }

  void setContent(List<String> sentence) {
    sentences.addAll(sentence);
  }

  void addSentence(String sentence) {
    sentences.add(sentence);
  }
}
