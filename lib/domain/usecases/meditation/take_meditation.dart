import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/usecases/usecase.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/mission.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/meditation_repository.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';
import 'package:meditation_app/domain/usecases/lesson/add_lesson.dart';

class MeditateUseCase extends UseCase<User, Params> {
  MeditationRepository repository;
  UserRepository userRepository;

  MeditateUseCase(this.repository,this.userRepository);

  @override
  Future<Either<Failure, User>> call(Params params) async {
   int stagenumber = params.user.stagenumber;
   MeditationModel m = new MeditationModel(duration:params.duration, day:DateTime.now(), coduser: params.user.coduser);
   params.user.takeMeditation(m, params.d);
   return await userRepository.updateUser(user:params.user, d:params.d, m: m);
  }
}

class Params {
  Duration duration;
  User user;
  DataBase d;

  Params({this.duration, this.user, this.d});

  List<Object> get props => [duration, user];
}
