import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/usecases/usecase.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';
import 'package:meditation_app/domain/usecases/user/change_data.dart';

class FollowUseCase extends UseCase<User, UParams> {
  UserRepository repository;

  FollowUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(UParams params) async {
    if (params.type == 'follow') {
      params.user.follow(params.followeduser);
     // repository.follow(user:params.user, following:params.followeduser);
    } else if (params.type == 'unfollow') {
      params.user.unfollow(params.followeduser);
    }

    return repository.updateUser(user: params.user, toAdd: params.user.lastactions, type:params.type);
  }
}
