import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/mission.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';

/** ESTO NO SE UTILIZA !!! */
abstract class MeditationRepository {
  Future<Either<Failure, bool>> meditate({MeditationModel meditation, UserModel user});
}
