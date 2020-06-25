import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Meditation extends Equatable {
  final String codmed, title, duration, recording;
  //for referencing the user.
  //final String userId;

  Meditation(
      {@required this.codmed,
      this.title,
      @required this.duration,
      this.recording,
      //this.userId
      });

  @override
  List<Object> get props => [codmed, title, duration, recording];
}
