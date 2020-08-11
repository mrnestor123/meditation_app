import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/usecases/usecase.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/meditation_repository.dart';
import 'package:meditation_app/domain/usecases/lesson/add_lesson.dart';

class MeditateUseCase extends UseCase<bool, Params> {
  MeditationRepository repository;

  MeditateUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(Params params) async {

   MeditationModel m = new MeditationModel(duration:params.duration,day:DateTime.now());
   params.user.takeMeditation(m);

   return await repository.meditate(meditation: m, user: params.user);
  }
}

class Params {
  Duration duration;
  User user;

  Params({this.duration, this.user});

  List<Object> get props => [duration, user];
}
