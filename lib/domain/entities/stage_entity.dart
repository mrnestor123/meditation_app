import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/lesson_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:observable/observable.dart';

class Stage extends Equatable {
  final int stagenumber;
  final String description;
 

  //this is for referencing the lessons. 
  final ObservableList<Lesson> lessons = new ObservableList();

  //this is for referencing the users.
  final ObservableList<User> users = new ObservableList();

  Stage({
    @required this.stagenumber,
    @required this.description,
  });

  @override
  List<Object> get props => [stagenumber, description];
}
