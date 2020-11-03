import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/core/error/exception.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/network/network_info.dart';
import 'package:meditation_app/data/datasources/local_datasource.dart';
import 'package:meditation_app/data/datasources/remote_data_source.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/data/models/mission_model.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/auth/email_address.dart';
import 'package:meditation_app/domain/entities/mission.dart';
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

  //Primero miramos si el usuario esta en la cache y si no esta y estamos conectados, comprobamos en la base de datos
  @override
  Future<Either<Failure, User>> loginUser({
    String password,
    String usuario,
  }) async {
    try {
      final localUser = await localDataSource.getUser(usuario);
      return Right(localUser);
    } on Exception {
      if (await networkInfo.isConnected) {
        try {
          final newUser = await remoteDataSource.loginUser(
              usuario: usuario, password: password);
          localDataSource.cacheUser(newUser);
          return Right(newUser);
        } on LoginException {
          return Left(LoginFailure());
        } on ServerException {
          return Left(ServerFailure());
        }
      } else {
        return Left(ServerFailure());
      }
    }
  }

  @override
  Future<Either<Failure, User>> islogged() async {
    try {
      final user = await localDataSource.getUser();
      return Right(user);
    } on Exception {
      return Left(CacheFailure(error: 'User is not in cache'));
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
        //Lo añadimos a la caché
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

  @override
  Future<Either<Failure, Map>> getData() async {
    // TODO: implement getData
    if (await networkInfo.isConnected) {
      try {
        //final data = await remoteDataSource.getData();
        final data = await remoteDataSource.getAllLessons();
        return Right(data);
      } on Exception {
        return Left(ServerFailure());
      }
    } else {
      return Left(
          ConnectionFailure(error: "User is not connected to the internet"));
    }
  }

  Future<Either<Failure, bool>> logout() async {
    /* A lo mejor hay que comprobar si los datos de la caché se han subido a la base de datos.
    if(await networkInfo.isConnected){

    }**/

    final loggedout = await localDataSource.logout();

    if (loggedout) {
      return Right(true);
    } else {
      return Left(ServerFailure());
    }
  }


  @override
  Future<Either<Failure,bool>> changeStage(User user) async{
    if(await networkInfo.isConnected){
      remoteDataSource.changeStage(user);
      return Right(true);
    }else{
      return Left(ServerFailure());
    }
  }


  Future<Either<Failure, bool>> updateMission(Mission m) async {
    if (await networkInfo.isConnected) {
      // remoteDataSource.updateMission(m);

    }
  }

  Future<Either<Failure, bool>> updateMissions(List<Mission> missions, User u) async {
    if (await networkInfo.isConnected) {
      for (Mission m in missions) {
        try {
         // await remoteDataSource.updateMission(m, u, m.requiredmission);
          await localDataSource.updateMission(m, m.requiredmission);
        } on Exception {
          return Left(ServerFailure());
        }
      }
      return Right(true);
    }
  }
}
