import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/usecases/usecase.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';

class LoginUseCase extends UseCase<User, UserParams> {
  UserRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(UserParams params) async {
    // Aquí a lo mejor hay que comprobar los datos?. Añadirlo a alguna stage? Habrá que pasarle datos?
    return await repository.loginUser(
      usuario: params.usuario,
    );
  }
}

class UserParams extends Equatable {
  var usuario;

  UserParams({
    @required this.usuario,
  });

  @override
  List<Object> get props => [
        this.usuario,
      ];
}
