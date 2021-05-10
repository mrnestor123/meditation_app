import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/usecases/usecase.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/meditation_repository.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';

class MeditateUseCase extends UseCase<User, Params> {
  MeditationRepository repository;
  UserRepository userRepository;

  MeditateUseCase(this.repository,this.userRepository);

  @override
  Future<Either<Failure, User>> call(Params params) async {
   int stagenumber = params.user.stagenumber;
   params.user.takeMeditation(params.meditation, params.d);
   return await userRepository.updateUser(user:params.user, d: params.d, toAdd: [params.meditation, params.user.lastactions], type: 'meditate');
  }
}

class Params {
  Meditation meditation;
  User user;
  DataBase d;

  Params({this.meditation, this.user, this.d});

  List<Object> get props => [meditation, user];
}
 