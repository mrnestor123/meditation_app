import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/usecases/usecase.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/mission.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/meditation_repository.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';
import 'package:meditation_app/domain/usecases/lesson/add_lesson.dart';

class MeditateUseCase extends UseCase<List<Mission>, Params> {
  MeditationRepository repository;
  UserRepository userRepository;

  MeditateUseCase(this.repository,this.userRepository);

  @override
  Future<Either<Failure, List<Mission>>> call(Params params) async {
   int stagenumber = params.user.stagenumber;
   MeditationModel m = new MeditationModel(duration:params.duration,day:DateTime.now());
   var mission = params.user.takeMeditation(m);
   
    if(mission.length>0){
      if(params.user.stagenumber > stagenumber){
        //añade unas misiones nuevas
        userRepository.changeStage(params.user);
      }else{
        //cambia las misiones que tiene el usuario actualmente. Las pone en done
        await userRepository.updateMissions(mission,params.user);
      }
    }
    
   return await repository.meditate(meditation: m, user: params.user,missions:mission);
  }
}

class Params {
  Duration duration;
  User user;

  Params({this.duration, this.user});

  List<Object> get props => [duration, user];
}
