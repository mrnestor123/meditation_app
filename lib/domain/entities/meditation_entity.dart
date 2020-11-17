import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Meditation {
  String codmed;
  int xp;
  final String recording;
  final Duration duration;
  final DateTime day;

  //for referencing the user.
  //final String userId;

  Meditation({this.codmed, @required this.duration, this.recording, this.day
      //this.userId
      }) {
    if (this.codmed == null) {
      var uuid = Uuid();
      this.codmed = uuid.v1();
    }
    this.xp = this.duration.inMinutes* 100;
  }


}
