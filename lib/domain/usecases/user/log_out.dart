

import 'package:meditation_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/usecases/usecase.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';
import 'package:meditation_app/domain/usecases/user/get_data.dart';

class LogOutUseCase extends UseCase<bool, NoParams> {
  UserRepository repository;

  LogOutUseCase(this.repository);


  @override
  Future<Either<Failure, bool>> call(NoParams params) async{
    // TODO: implement call
    return await repository.logout();
  }

}