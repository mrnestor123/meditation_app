

import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/domain/entities/lesson_entity.dart';
import 'package:meditation_app/domain/entities/mission.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';

abstract class LessonRepository {

  Future<Either<Failure,void>> takeLesson({Lesson lesson, User user,List<Mission> missions});

  //in order to add a lesson to the database.
  Future<Either<Failure,void>> addLesson({Lesson lesson});

  Future<Either<Failure,List<Lesson>>> getBrainLessons({int stage});

    Future<Either<Failure,List<Lesson>>> getMeditationLessons({int stage});


}