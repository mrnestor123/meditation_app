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
    } else if (params.type == 'stage') {
      //updateamos la stage
      params.user.updateStage(params.db);
    } else if (params.type == 'image') {
      params.user.image = params.image;
    } else if (params.type == 'follow') {
      params.user.follow(params.followeduser);
    } else if (params.type == 'unfollow') {
      params.user.unfollow(params.followeduser);
    }

    return repository.updateUser(user: params.user, d: params.db);
  }
}

class UParams {
  final User user;
  final User followeduser;
  final String nombre;
  final String type;
  final DataBase db;
  final String image;

  UParams(
      {this.user,
      this.nombre,
      this.type,
      this.db,
      this.image,
      this.followeduser});
}
