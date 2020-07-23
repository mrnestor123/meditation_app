

import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/usecases/usecase.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';

class GetDataUseCase extends UseCase<Map, NoParams> {
  UserRepository repository;

  GetDataUseCase(this.repository);

  @override
  Future<Either<Failure, Map>> call(NoParams p) async{
    // Aquí a lo mejor hay que comprobar los datos?. Añadirlo a alguna stage? Habrá que pasarle datos?
    return await repository.getData();
  }
}