

import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/domain/entities/lesson_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';

abstract class LessonRepository {

  Future<Either<Failure,void>> takeLesson({Lesson lesson, User user});

  //in order to add a lesson to the database.
  Future<Either<Failure,void>> addLesson({Lesson lesson});
}