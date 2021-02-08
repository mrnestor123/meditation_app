import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';

abstract class UserRepository {
  //Use Case for login users
  Future<Either<Failure, User>> loginUser({FirebaseUser usuario});

  Future<Either<Failure, User>> registerUser({FirebaseUser usuario});

  Future<Either<Failure, User>> islogged();

  Future<Either<Failure, DataBase>> getData();

  Future<Either<Failure, bool>> logout();

  Future<Either<Failure, bool>> changeStage(User user);

  Future<Either<Failure, User>> updateUser({User user,DataBase d, Meditation m});
}
