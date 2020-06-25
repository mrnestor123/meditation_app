

import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/meditation_repository.dart';

class MeditationRepositoryImpl implements MeditationRepository{
  @override
  Future<Either<Failure, void>> meditate({Meditation meditation, User user}) {
    // TODO: implement meditate
    return null;
  }
}