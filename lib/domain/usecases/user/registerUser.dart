import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/usecases/usecase.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';

class RegisterUseCase extends UseCase<User, UserParams> {
  UserRepository repository;

  RegisterUseCase(this.repository);

  //Para registrar un usuario. Primero creamos el usuario, luego le añadimos las lecciones que tiene por la etapa que le ha surgido.
  @override
  Future<Either<Failure, User>> call(UserParams params) async {
    // Aquí a lo mejor hay que comprobar los datos?. Añadirlo a alguna stage? Habrá que pasarle datos?
    var user = await repository.registerUser(
        nombre: params.nombre,
        mail: params.mail,
        password: params.password,
        usuario: params.usuario,
        stagenumber: params.stagenumber);

    if (user is User) {
      repository.initializeUser(user);
    }

    return user;
  }
}

class UserParams extends Equatable {
  final String nombre;
  final String mail;
  final String usuario;
  final String password;
  final int stagenumber;

  UserParams({
    @required this.nombre,
    @required this.mail,
    @required this.usuario,
    @required this.password,
    @required this.stagenumber,
  });

  @override
  List<Object> get props =>
      [this.nombre, this.mail, this.usuario, this.password, this.stagenumber];
}
