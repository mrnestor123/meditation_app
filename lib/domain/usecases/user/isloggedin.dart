import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/usecases/usecase.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';


/*
* We check if there is a user in the cached data.
*/
class CachedUserUseCase extends UseCase<User, NoParams> {
  UserRepository repository;

  CachedUserUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams p) async{
    // Aquí a lo mejor hay que comprobar los datos?. Añadirlo a alguna stage? Habrá que pasarle datos?
    return await repository.islogged();
  }
}
