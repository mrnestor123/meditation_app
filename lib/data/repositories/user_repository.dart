import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_app/core/error/exception.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/network/network_info.dart';
import 'package:meditation_app/data/datasources/local_datasource.dart';
import 'package:meditation_app/data/datasources/remote_data_source.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/request_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  UserRemoteDataSource remoteDataSource;
  UserLocalDataSource localDataSource;
  NetworkInfo networkInfo;

  UserRepositoryImpl({@required this.remoteDataSource,@required this.localDataSource,@required this.networkInfo});

  //Primero miramos si el usuario esta en la cache y si no esta y estamos conectados, comprobamos en la base de datos
  @override
  Future<Either<Failure, User>> loginUser({var usuario}) async {
    if (await networkInfo.isConnected) {
      try {
        final newUser = await remoteDataSource.loginUser(usuario: usuario);
        localDataSource.cacheUser(newUser);
        return Right(newUser);
      } on LoginException {
        return Left(LoginFailure(error: 'User does not exist in the database'));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      //Hay que arreglar este método
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> islogged() async {
    if (await networkInfo.isConnected) {
      try {
        final cod = await localDataSource.getUser();
        final user = await remoteDataSource.getUserData(cod);
        return Right(user);
      } on Exception {
        return Left(ConnectionFailure(error: "User is not connected to the internet"));
      }
    } 
  }

  Future<Either<Failure, User>> updateUser({var user, DataBase d, dynamic toAdd, String type}) async {
    if (await networkInfo.isConnected) {
      try {
        final newUser = await remoteDataSource.updateUser(user:user,data: d, toAdd: toAdd, type: type);
      //  localDataSource.updateData(user:user, toAdd: toAdd, type: type);
        return Right(newUser);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
        return Left(ServerFailure());
    }
  }

  /*
    Hay que comprobar si el usuario ya existe antes de registrarlo y hacer nada
  */
  @override
  Future<Either<Failure, User>> registerUser({var usuario}) async {
    //si esta conectado lo añadimos a la base de datos. Si no lo añadimos a nuestra caché. Devolvemos el usuario guardado
    if (await networkInfo.isConnected) {
      try {
        final newUser = await remoteDataSource.registerUser(usuario: usuario);
        //Lo añadimos a la caché
        localDataSource.cacheUser(newUser);
        return Right(newUser);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      /*try {
        //localDataSource.cacheUser(UserModel(
          //  user: usuario,
            //stagenumber: stagenumber));
        final localUser = await localDataSource.getUser();
        return Right(localUser);
      } on ServerException {*/
      return Left(ConnectionFailure(error: "User is not connected to the internet"));
    }
  }

  @override
  Future<Either<Failure, DataBase>> getData() async {
    // TODO: implement getData
    if (await networkInfo.isConnected) {
      try {
        final data = await remoteDataSource.getData();
        return Right(data);
      } on Exception {
        return Left(ServerFailure());
      }
    } else {
      //habrá que hacer algo cuando el usuario no tenga internet.. Mostrar un modal con PONTE INTERNET
      return Left(ConnectionFailure(error: "User is not connected to the internet"));
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
  Future<Either<Failure, String>> updateImage(PickedFile image, User u) async{
    try{
      var string = await remoteDataSource.updateImage(image, u);

      if(string != null) {
        return Right(string);
      }else{
        return Left(ConnectionFailure(error: 'No se ha podido subir'));
      }
    }catch(e){
      return Left(ConnectionFailure(error: 'No se ha podido subir'));
    }


    // TODO: implement updateImage
  }



  @override
  Future<Either<Failure,List<Request>>> getRequests() async{
    List<Request> requests = await remoteDataSource.getRequests();

    if(requests != null) {
      return Right(requests);
    }else{
      return Left(ConnectionFailure(error: 'We could not get the  requests'));
    }
  }


  @override
  Future<Either<Failure,void>> updateRequest(Request r) async{
    try{
      remoteDataSource.updateRequest(r);
    }catch(e){
      return Left(ConnectionFailure(error: 'Ha ocurrido un error'));
    }
  
  }


}
