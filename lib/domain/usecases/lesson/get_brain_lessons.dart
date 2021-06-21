import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/usecases/usecase.dart';
import 'package:meditation_app/domain/entities/lesson_entity.dart';
import 'package:meditation_app/domain/repositories/lesson_repository.dart';
/*
class GetBrainLessonsUseCase extends UseCase<List<Lesson>, Params> {
  LessonRepository repository;

  GetBrainLessonsUseCase(this.repository);
  
  @override
  Future<Either<Failure, List<Lesson>>> call(Params params) {
    return repository.getBrainLessons(stage: params.stage);
  }
}

class Params extends Equatable{
  final int stage;

  Params({this.stage});

  @override
  // TODO: implement props
  List<Object> get props => [stage];
}*/