import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/usecases/usecase.dart';
import 'package:meditation_app/domain/entities/auth/email_address.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';

class RegisterUseCase extends UseCase<User, UserParams> {
  UserRepository repository;

  RegisterUseCase(this.repository);

  //Para registrar un usuario. Primero creamos el usuario, luego le añadimos las lecciones que tiene por la etapa que está.
  @override
  Future<Either<Failure, User>> call(UserParams params) async {

    if (!params.validatePassword(params.password)) {
      return Left(RegisterFailure(error: 'Password length must be more than 6'));
    }

    if (params.confirmpassword != params.password) {
      return Left(RegisterFailure(error: 'Passwords must be equal'));
    }

    if (!params.validateMail(params.mail)) {
      return Left(RegisterFailure(error: 'Please input a valid mail'));
    }

    // Aquí a lo mejor hay que comprobar los datos?. Añadirlo a alguna stage? Habrá que pasarle datos?
    var user = await repository.registerUser(
        nombre: params.nombre,
        mail: params.mail,
        password: params.password,
        usuario: params.usuario,
        stagenumber: params.stagenumber);
      
      return user;
  }
}

class UserParams extends Equatable {
  final String nombre;
  final String mail;
  final String usuario;
  final String password;
  final String confirmpassword;
  final int stagenumber;

  UserParams({
    this.nombre,
    @required this.mail,
    @required this.usuario,
    @required this.password,
    @required this.confirmpassword,
    @required this.stagenumber,
  });

  @override
  List<Object> get props => [
        this.nombre,
        this.mail,
        this.usuario,
        this.password,
        this.confirmpassword,
        this.stagenumber
      ];

  bool validatePassword(String password) {
    if (password.length > 6) {
      return true;
    } else {
      return false;
    }
  }

  bool validateMail(String mail) {
    const emailRegex =
        r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";

    if (RegExp(emailRegex).hasMatch(mail)) {
      return true;
    } else {
      return false;
    }
  }
}
