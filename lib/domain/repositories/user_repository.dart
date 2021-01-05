import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/domain/entities/auth/email_address.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/mission.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';

abstract class UserRepository {
  //Use Case for login users
  Future<Either<Failure, User>> loginUser({String usuario, String password});

  Future<Either<Failure, User>> registerUser({FirebaseUser usuario});

  Future<Either<Failure,User>> islogged();

  Future<Either<Failure,Map>> getData();

  Future<Either<Failure,bool>> logout();

  Future<Either<Failure,bool>> updateMission(Mission m);

  Future<Either<Failure,bool>> updateMissions(List<Mission> missions,User u);

  Future<Either<Failure,bool>> changeStage(User user);
}
