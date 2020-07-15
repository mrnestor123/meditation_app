import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/auth/email_address.dart';
import 'package:observable/observable.dart';

import 'lesson_entity.dart';
import 'meditation_entity.dart';

class User extends Equatable {
  //Nombre es el nombre de pila y usuario es el nombre en la aplicación
  final String coduser, nombre, usuario, password;
  final String mail;
  final int stagenumber;
  final double experience;

  //A list with the meditations
  final ObservableList<Meditation> totalMeditations = new ObservableList();

  //two lists with the lessons. At the beginning the user has no lessons learned and all the remaining lessons for each stage
  final ObservableList<Lesson> lessonslearned = new ObservableList();
  final ObservableList<Lesson> remainingLessons = new ObservableList();

  User({
    @required this.coduser,
    this.nombre,
    this.experience,
    @required this.mail,
    @required this.usuario,
    @required this.password,
    @required this.stagenumber,
  });

  @override
  List<Object> get props =>
      [coduser, nombre, mail, usuario, password, stagenumber];

  ObservableList<Lesson> getRemainingLessons() => remainingLessons;
  ObservableList<Lesson> getLessonsLearned() => lessonslearned;
  
  void setLearnedLessons(List<Lesson>l)=> lessonslearned.addAll(l);
  void setRemainingLessons(List<Lesson> l) => remainingLessons.addAll(l);
  void setMeditations(List<Meditation> m) =>totalMeditations.addAll(m);


  void setLessons(List<Lesson> learned, List<Lesson> remaining) {
    lessonslearned.addAll(learned);
    remainingLessons.addAll(remaining);
  }

  void takeLesson(Lesson l) {
    lessonslearned.add(l);
    remainingLessons.remove(l);
  }

}
