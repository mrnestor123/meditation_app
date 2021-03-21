import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';

abstract class UserRepository {
  //Use Case for login users
  Future<Either<Failure, User>> loginUser({var usuario});

  Future<Either<Failure, User>> registerUser({var usuario});

  Future<Either<Failure, User>> islogged();

  Future<Either<Failure, DataBase>> getData();

  Future<Either<Failure, bool>> logout();

  Future<Either<Failure, User>> updateUser({User user,DataBase d, Meditation m});

  Future<Either<Failure,String>> updateImage(PickedFile image, User u);
}
