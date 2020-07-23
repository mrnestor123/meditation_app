import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Meditation extends Equatable {
  final String codmed, recording;
  final Duration duration;
  final DateTime day;


  //for referencing the user.
  //final String userId;

  Meditation(
      {this.codmed,
      @required this.duration,
      this.recording,
      this.day
      //this.userId
      });

  @override
  List<Object> get props => [codmed, duration, recording,day];
}
