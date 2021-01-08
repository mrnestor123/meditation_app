

import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/usecases/usecase.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';

class GetDataUseCase extends UseCase<DataBase, NoParams> {
  UserRepository repository;

  GetDataUseCase(this.repository);

  @override
  Future<Either<Failure, DataBase>> call(NoParams p) async{
    return await repository.getData();
  }
}