

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/usecases/usecase.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';

class ChangeDataUseCase extends UseCase<User, UParams> {
  UserRepository repository;

  ChangeDataUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(UParams params) async {
    params.user.nombre = params.nombre;
    return repository.updateUser(user: params.user, d: params.db, toAdd: params.user.lastactions, type:params.type);
  }
}



class UParams {
  final User user;
  final User followeduser;
  final String nombre;
  final String type;
  final DataBase db;
  final PickedFile image;

  UParams(
      {this.user,
      this.nombre,
      this.type,
      this.db,
      this.image,
      this.followeduser});
}
