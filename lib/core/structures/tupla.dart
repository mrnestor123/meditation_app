


import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';

class Tupla {

  List<Meditation> meditation = new List();
  List<LessonModel> learned = new List();
  List<LessonModel> remaining = new List();

  Tupla(List<Meditation> m,List<LessonModel> learned,List<LessonModel>remaining){
    this.meditation=m;
    this.learned=learned;
    this.remaining = remaining;
  }

  void setTupla(List<Meditation> meditation,List<LessonModel>learned,List<LessonModel>remaining){
    meditation.addAll(meditation);
    learned.addAll(learned);
    remaining.addAll(remaining);
  }
}