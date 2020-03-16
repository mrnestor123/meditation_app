import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';

abstract class UserRepository {
  //Use Case for login users
  Future<Either<Failure, User>> loginUser({String usuario, String password});

  Future<Either<Failure, User>> registerUser(
      {String nombre,
      String mail,
      String nomuser,
      String password,
      String usuario,
      int stagenumber});

  Future<Either<Failure, void>> setLessons(User u);
}
