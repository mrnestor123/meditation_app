

import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/lesson_entity.dart';
import 'package:meditation_app/domain/entities/mission.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';

/** ESTO NO SE UTILIZA !!! */
abstract class LessonRepository {

  Future<Either<Failure,void>> takeLesson({UserModel user});
}