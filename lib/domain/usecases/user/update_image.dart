import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/usecases/usecase.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';
import 'package:meditation_app/domain/usecases/user/change_data.dart';

class UpdateImageUseCase extends UseCase<User, UParams> {
  UserRepository repository;

  UpdateImageUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(UParams params) async {
    //updateamos la stage
    
    Either<Failure,String> image = await repository.updateImage(params.image, params.user);
    image.fold((l) => print('error al subir imagen'), (r) => params.user.image = r);

    return repository.updateUser(user: params.user);
  }
}
