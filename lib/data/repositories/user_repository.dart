import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/core/error/exception.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/network/network_info.dart';
import 'package:meditation_app/data/datasources/local_datasource.dart';
import 'package:meditation_app/data/datasources/remote_data_source.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/auth/email_address.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  UserRemoteDataSource remoteDataSource;
  UserLocalDataSource localDataSource;
  NetworkInfo networkInfo;

  UserRepositoryImpl(
      {@required this.remoteDataSource,
      @required this.localDataSource,
      @required this.networkInfo});

  /// Primero miramos si el usuario esta en la cache y si no esta y estamos conectados, comprobamos en la base de datos
  @override
  Future<Either<Failure, User>> loginUser({
    String password,
    String usuario,
  }) async {
    try {
      final localUser = await localDataSource.getUser();
      return Right(localUser);
    } on Exception {
      if (await networkInfo.isConnected) {
        try {
          final newUser = await remoteDataSource.loginUser(
              usuario: usuario, password: password);

          final l= await remoteDataSource.getUserData(userid: newUser.coduser);

          newUser.setRemainingLessons(l.remaining);
          newUser.setLearnedLessons(l.learned);
          newUser.setMeditations(l.meditation);

          localDataSource.cacheUser(newUser);
          return Right(newUser);
        }on LoginException{ 
          return Left(LoginFailure());
        }on ServerException {
          return Left(ServerFailure());
        }
      } else {
        return Left(ServerFailure());
      }
    }
  }

  @override
  Future<Either<Failure, User>> registerUser(
      {String nombre,
      String mail,
      String password,
      String usuario,
      int stagenumber}) async {
    //si esta conectado lo añadimos a la base de datos. Si no lo añadimos a nuestra caché. Devolvemos el usuario guardado
    if (await networkInfo.isConnected) {
      try {
        final newUser = await remoteDataSource.registerUser(
            nombre: nombre,
            mail: mail,
            usuario: usuario,
            password: password,
            stagenumber: stagenumber);
        //Añadimos las lecciones
        newUser.setRemainingLessons(await remoteDataSource.getStageLessons(stage:stagenumber));
        localDataSource.cacheUser(newUser);
        return Right(newUser);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        localDataSource.cacheUser(UserModel(
            nombre: nombre,
            mail: mail,
            usuario: usuario,
            password: password,
            stagenumber: stagenumber));
        final localUser = await localDataSource.getUser();
        return Right(localUser);
      } on ServerException {
        return Left(ServerFailure());
      }
    }
  }

}