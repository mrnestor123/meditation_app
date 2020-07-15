

import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';

abstract class MeditationRepository{

  Future<Either<Failure,Meditation>> meditate({Duration d,User user});
}