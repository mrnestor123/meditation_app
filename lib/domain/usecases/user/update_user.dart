import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/usecases/usecase.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';

class UpdateUserUseCase extends UseCase<User, UParams> {
  UserRepository repository;

  UpdateUserUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(UParams params) async {
    if (params.type == "name") {
      params.user.nombre = params.nombre;
    }

    //updateamos la stage
    if (params.type == 'stage') {
      params.user.updateStage(params.db);
    }

    if (params.type == 'image') {
      params.user.image = params.image;
    }

    return repository.updateUser(user: params.user, d: params.db);
  }
}

class UParams {
  final User user;
  final String nombre;
  final String type;
  final DataBase db;
  final String image;

  UParams({this.user, this.nombre, this.type, this.db, this.image});
}
