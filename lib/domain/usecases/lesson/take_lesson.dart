import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/usecases/usecase.dart';
import 'package:meditation_app/domain/entities/lesson_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/lesson_repository.dart';

class TakeLessonUseCase extends UseCase<void, Params> {
  LessonRepository repository;

  TakeLessonUseCase(this.repository);

  //Hay que comprobar en el bloc antes de utilizar la función esta que el usuario ha acabado la lección. 
  //Esto es en el caso de que la acabe.
  @override
  Future<Either<Failure, void>> call(Params params) {
    //añadimos la leccion al usuario que hemos creado
    params.user.takeLesson(params.lesson);
    //más adelante comprobar si ha hecho algún objetivo para la stage

    // Aquí a lo mejor hay que comprobar los datos?. Añadirlo a alguna stage? Habrá que pasarle datos?
    return repository.takeLesson(lesson:params.lesson, user:params.user);
  }
}

class Params extends Equatable {
  final User user;
  final Lesson lesson;

  Params({
    @required this.user,
    @required this.lesson,
  });

  @override
  List<Object> get props => [
        this.user,
        this.lesson
      ];
}
