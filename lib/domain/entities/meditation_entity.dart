import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Meditation extends Equatable {
  final int codmed;
  final String duration;
  final String recording;
  final int guided;

  //for referencing the user.
  final int userId;

  Meditation(
      {this.codmed,
      @required this.duration,
      this.recording,
      this.guided,
      this.userId});

  @override
  List<Object> get props => [codmed, duration, recording, guided, userId];
}
