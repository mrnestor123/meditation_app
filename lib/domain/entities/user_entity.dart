import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:observable/observable.dart';

class User extends Equatable {
  final int coduser;

  //Nombre es el nombre de pila y usuario es el nombre en la aplicación
  final String nombre, mail, usuario, password;
  final int stagenumber;

  //A list with the meditations ids
  final ObservableList<String> totalMeditations = new ObservableList();

  //two lists with the lessons ids. At the beginning the user has no lessons learned and all the remaining lessons for each stage
  final ObservableList<String> lessonslearned = new ObservableList();
  final ObservableList<String> remainingLessons = new ObservableList();

  User({
    this.coduser,
    this.nombre,
    @required this.mail,
    @required this.usuario,
    @required this.password,
    @required this.stagenumber,
  });

  @override
  List<Object> get props =>
      [coduser, nombre, mail, usuario, password, stagenumber];
}
