import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/usecases/usecase.dart';
import 'package:meditation_app/domain/entities/lesson_entity.dart';
import 'package:meditation_app/domain/entities/mission.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/lesson_repository.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';

class TakeLessonUseCase extends UseCase<List<Mission>, LessonParams> {
  LessonRepository repository;
  UserRepository userRepository;

  TakeLessonUseCase(this.repository, this.userRepository);

  //Hay que comprobar en el bloc antes de utilizar la función esta que el usuario ha acabado la lección.
  //Esto es en el caso de que la acabe.
  @override
  Future<Either<Failure, List<Mission>>> call(LessonParams params) {

    //añadimos la leccion al usuario
    if (!params.user.lessonslearned.contains(params.lesson)) {
      final missions = params.user.takeLesson(params.lesson);
      if (missions.length > 0) {
        userRepository.updateMissions(missions, params.user);
      }
      
      // Aquí a lo mejor hay que comprobar los datos?. Añadirlo a alguna stage? Habrá que pasarle datos?
      return repository.takeLesson(lesson: params.lesson, user: params.user,missions:missions);
    }
  }
}

class LessonParams extends Equatable {
  final User user;
  final Lesson lesson;

  LessonParams({
    @required this.user,
    @required this.lesson,
  });

  @override
  List<Object> get props => [this.user, this.lesson];
}
