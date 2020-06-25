

import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/usecases/usecase.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/usecases/lesson/add_lesson.dart';

class MeditateUseCase extends UseCase<Meditation,Params>{
  @override
  Future<Either<Failure, Meditation>> call(Params params) {
    return null;
  }
}

class Params {
  Meditation meditation;
  User user;

  Params({this.meditation,this.user});

  List<Object> get props => [meditation,user];


}
