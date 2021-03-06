



import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/usecases/usecase.dart';
import 'package:meditation_app/domain/entities/lesson_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/lesson_repository.dart';
import 'package:meditation_app/domain/usecases/lesson/take_lesson.dart';
/*
class AddLessonUseCase extends UseCase<bool, LessonParams> {
  LessonRepository repository;

  AddLessonUseCase({this.repository});
  
  @override
  Future<Either<Failure, bool>> call(LessonParams params) {
    return repository.addLesson(lesson:params.lesson);
  }
}


class LessonParams extends Equatable{
  final Lesson lesson;
  final User user;

  LessonParams({this.lesson,this.user});

  @override
  // TODO: implement props
  List<Object> get props => [lesson,user];
}*/