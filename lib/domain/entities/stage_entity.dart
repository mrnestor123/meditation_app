import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:observable/observable.dart';

class Stage extends Equatable {
  final int stagenumber;
  final String description;

  //this is for referencing the lessons. A list with the ids of the lessons.
  final ObservableList<int> lessons = new ObservableList();

  //this is for referencing the users. List with their ids
  final ObservableList<int> users = new ObservableList();

  Stage({
    @required this.stagenumber,
    @required this.description,
  });

  @override
  List<Object> get props => [stagenumber, description];
}
