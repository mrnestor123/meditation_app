import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Lesson extends Equatable {
  final String codlesson;
  final String title;
  final String slider;
  final String description;
  final String text;
  final int stagenumber;

  Lesson({
    @required this.title,
    @required this.codlesson,
    this.slider,
    @required this.description,
    @required this.text,
    @required this.stagenumber,
  });

  @override
  List<Object> get props => [title,codlesson, slider, description, text, stagenumber];
}
