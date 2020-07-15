

import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/domain/entities/lesson_entity.dart';
import 'package:meditation_app/domain/usecases/lesson/get_brain_lessons.dart';
import 'package:mobx/mobx.dart';

part 'lesson_state.g.dart';

class LessonState extends _LessonState with _$LessonState {
 LessonState({GetBrainLessonsUseCase brainlessonsUseCase}) : super(brainLessons: brainlessonsUseCase);
}

abstract class _LessonState with Store {
  GetBrainLessonsUseCase brainUsecase;

  @observable
  List<LessonModel> brainlessons = new List<LessonModel>();

  @observable 
  String error;

  @observable
  Either<Failure,List<LessonModel>> result;

  _LessonState({brainLessons}) {
    this.brainUsecase = brainLessons;
  }


  @action
  Future getBrainLessons({int stage}) async{

    result = await brainUsecase.call(Params(stage: stage));

    result.fold(
      (l) => error = "Could not fetch lessons", 
      (r) => brainlessons = r);
  }
}