

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/usecases/usecase.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/game_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';

class AnswerQuestionUseCase extends UseCase<User, GameParams> {
  UserRepository repository;

  AnswerQuestionUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(GameParams params) async {
   
  }
}


class GameParams {
  final Question question;
  final User user;
  final Game game;

  GameParams(
      {
        this.game,
        this.user,
        this.question
      });
}
