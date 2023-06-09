import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_app/core/error/exception.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/network/network_info.dart';
import 'package:meditation_app/data/datasources/local_datasource.dart';
import 'package:meditation_app/data/datasources/remote_data_source.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/action_entity.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/lesson_entity.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/message.dart';
import 'package:meditation_app/domain/entities/notification_entity.dart';
import 'package:meditation_app/domain/entities/request_entity.dart';
import 'package:meditation_app/domain/entities/retreat_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';
import 'package:meditation_app/presentation/pages/main.dart';

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

        if(newUser != null){
          localDataSource.cacheUser(newUser);
          return Right(newUser);
        }
      } on ServerException catch(e) {
        return Left(ServerFailure(error: e.error));
      } on Exception {
        return Left(ServerFailure(error: 'Server error'));
      }
    } else {
      //Hay que arreglar este método
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, User>> islogged() async {
    if (await networkInfo.isConnected) {
      try {
        //final cod = await localDataSource.getUser();
        final user = await remoteDataSource.loginUser();
        print({'GOT USER', user});
        
        final cachedUser = await localDataSource.getCachedUser();
        final meditations = await localDataSource.getCachedMeditations();

        if(meditations != null && meditations.length > 0){
          for(var med in meditations){
            // para que se vean las acciones
            user.takeMeditation(med, null, false,false, true);
          }

          // WHERE DO  WE ADD ACTIONS ??
          if(cachedUser != null){
            // DEBERÍAMOS DE ACTUALIZAR EL USUARIO !!
            remoteDataSource.updateUser(user:cachedUser, toAdd: meditations, type:'meditate');
          }
        }

        if(cachedUser == null){
          localDataSource.cacheUser(user);
        }
       

        return Right(user);
      } on ServerException catch(e) {
        return Left(ServerFailure(error: e.error));
      } on Exception {
        print('EXCEPTION');
        return Left(ServerFailure(error: 'Server error'));
      }
    } else {  
      // si no está conectado pero hay un usuario le devolvemos el usuario
      try {
        final user = await localDataSource.getCachedUser();
        return Right(user);
      } on ServerException catch(e) {
        return Left(ServerFailure(error: e.error));
      }
    } 
  }

  Future<Either<Failure, User>> updateUser({var user, DataBase d, dynamic toAdd, String type, DoneContent done}) async {
    if (await networkInfo.isConnected) {
      try {
        final newUser = await remoteDataSource.updateUser(user:user,data: d, toAdd: toAdd, type: type, done: done);
        return Right(newUser);
      } on ServerException {
        return Left(ServerFailure());
      } on Exception {
        return Left(ServerFailure(error: 'An error occured at login. Try again please'));
      }
    } else {
        return Left(ConnectionFailure());
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
      } on ServerException catch(e) {
        return Left(ServerFailure(error: e.error));
      } on Exception {
        return Left(ServerFailure(error: 'An error ocurred while registering the user. Try again please'));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, DataBase>> getData() async {
    if (await networkInfo.isConnected) {
      try {
        final data = await remoteDataSource.getData();

        return Right(data);
      } on ServerException catch(e) {
        return Left(ServerFailure(error: e.error));
      } on Exception {
        return Left(ServerFailure(error: 'Server error'));
      }
    } else {
      //habrá que hacer algo cuando el usuario no tenga internet.. Mostrar un modal con PONTE INTERNET
      return Left(ConnectionFailure());
    }
  }

  Future<Either<Failure, bool>> logout() async {
    if (await networkInfo.isConnected) {
      try {
        final loggedout = await localDataSource.logout();
        if (loggedout) {
          return Right(true);
        } else {
          return Left(ServerFailure());
        }
      }on ServerException catch(e) {
        return Left(ServerFailure(error: e.error));
      } on Exception {
        return Left(ServerFailure(error: 'Server error'));
      }
    }else{
      return Left(ConnectionFailure());
    }
  }
 
  @override
  Future<Either<Failure, String>> uploadFile({dynamic image,dynamic audio, dynamic video, User u}) async{
    if (await networkInfo.isConnected) {
      try{
        var string = await remoteDataSource.uploadFile(image:image,audio:audio,video:video, u: u);

        if(string != null) {
          return Right(string);
        }else{
          return Left(ServerFailure());
        }
      }on ServerException catch(e) {
        return Left(ServerFailure(error: e.error));
      } on Exception {
        return Left(ServerFailure(error: 'Server error'));
      }
    }else{
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure,List<Request>>> getRequests({String coduser}) async{
    if (await networkInfo.isConnected) {
      try{
        List<Request> requests = await remoteDataSource.getRequests(coduser: coduser);

        if(requests != null) {
          return Right(requests);
        }else{
          return Left(ServerFailure());
        }
      }on ServerException catch(e) {
        return Left(ServerFailure(error: e.error));
      } on Exception {
        return Left(ServerFailure(error: 'Server error'));
      }
    }else{
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure,void>> updateRequest(Request r, [List<Notify> n, Comment c]) async{
    if (await networkInfo.isConnected) {
      try{
        await remoteDataSource.updateRequest(r,n,c);
      }on ServerException catch(e) {
        return Left(ServerFailure(error: e.error));
      } on Exception {
        return Left(ServerFailure(error: 'Server error'));
      }
    }else{
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> uploadRequest(Request r) async{
    if (await networkInfo.isConnected) {
      try{
        await remoteDataSource.uploadRequest(r);
        return Right(null);
      }on ServerException catch(e) {
        return Left(ServerFailure(error: e.error));
      } on Exception {
        return Left(ServerFailure(error: 'Server error'));
      }
    }else{
      return Left(ConnectionFailure());
    }
  }


  @override
  Future<Either<Failure, List<User>>> getUsers(User u) async {
    if (await networkInfo.isConnected) {
      try {
        final users = await remoteDataSource.getUsers(u);
        return Right(users);
      } on ServerException catch(e) {
        return Left(ServerFailure(error: e.error));
      }
    }else{
      return Left(ConnectionFailure());
    } 
  }

  @override
  Future<Either<Failure, User>> getUser(String cod,[bool expand = false]) async{
     if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.getUser(cod, expand);
        return Right(user);
      } on ServerException catch(e) {
        return Left(ServerFailure(error: e.error));
      } on Exception {
        return Left(ServerFailure(error: 'Server error'));
      }
    }else{
      return Left(ConnectionFailure());
    } 
  }

  @override
  Future<Either<Failure, Request>> getRequest(String cod) async {
    if (await networkInfo.isConnected) {
      try {
        final request = await remoteDataSource.getRequest(cod);
        return Right(request);
      } on ServerException catch(e) {
        return Left(ServerFailure(error: e.error));
      } on Exception {
        return Left(ServerFailure(error: 'Server error'));
      }
    }else{
      return Left(ConnectionFailure());
    } 
  }

  @override
  Future<Either<Failure, void>> updateNotification(Notify n) async {
    if(await networkInfo.isConnected){
      try{
        await remoteDataSource.updateNotification(n);
      } on ServerException catch(e) {
        return Left(ServerFailure(error: e.error));
      } on Exception {
        return Left(ServerFailure(error: 'Server error'));
      }
    }else{
      return Left(ConnectionFailure());
    } 
  }

  @override
  Future<Either<Failure, List<User>>> getTeachers() async{
     if(await networkInfo.isConnected){
        try{
          final teachers = await remoteDataSource.getTeachers();
          return Right(teachers);
        } on ServerException catch(e) {
          return Left(ServerFailure(error: e.error));
        } on Exception {
          return Left(ServerFailure(error: 'Server error'));
        }
      }else{
        return Left(ConnectionFailure());
      }
  }

  @override
  Future<Either<Failure, void>> sendMessage({Message message}) async{
    if(await networkInfo.isConnected){
      try{
        await remoteDataSource.sendMessage(message);
        return Right(null);
      } on ServerException catch(e) {
        return Left(ServerFailure(error: e.error));
      } on Exception {
        return Left(ServerFailure(error: 'Server error'));
      }
    }else{
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateMessage({Message message}) async {
    if (await networkInfo.isConnected) {
      try {
        // await remoteDataSource.updateMessage(message: message);
       // return Right(null);
      }  on ServerException catch(e) {
        return Left(ServerFailure(error: e.error));
      } on Exception {
        return Left(ServerFailure(error: 'Server error'));
      }
    } else {
      //Hay que arreglar este método
      return Left(ConnectionFailure());
    }
  }


  /*
  @override
  Future<Either<Failure, void>> uploadContent({Content c}) async {
    if (await networkInfo.isConnected) {
      try {
       // await remoteDataSource.uploadContent(c:c);
        return Right(null);
      } on Exception {
        return Left(ServerFailure());
      }
    } else {
      //Hay que arreglar este método
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, User>> expandUser({User u}) async{
    if (await networkInfo.isConnected) {
      try {
        UserModel user =await remoteDataSource.expandUser(u:u);
        return Right(user);
      } on Exception {
        return Left(ServerFailure());
      }
    } else {
      //Hay que arreglar este método
      return Left(ConnectionFailure());
    }
  }
  
  @override
  Future<Either<Failure, void>> follow({User u, User followed, bool follows}) async{
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.follow(user:u, followed: followed, follows: follows);
        return Right(null);
      } on Exception {
        return Left(ServerFailure());
      }
    } else {
      //Hay que arreglar este método
      return Left(ConnectionFailure());
    }
  }*/


/*
  @override
  Future<Either<Failure, void>> takeLesson({User u, Lesson l}) async{
     if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.takeLesson(user:u, l:l);
        return Right(null);
      } on Exception {
        return Left(ServerFailure());
      }
    } else {
      //Hay que arreglar este método
      return Left(ConnectionFailure());
    }

  }*/

  @override
  Future<Either<Failure, void>> addAction({UserAction a}) async{
     if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.addAction(a:a);
        return Right(null);
      }  on ServerException catch(e) {
        return Left(ServerFailure(error: e.error));
      }  on Exception {
        return Left(ServerFailure(error: 'Server error'));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  /*
  @override
  Future<Either<Failure, List<Chat>>> getMessages({User user}) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDataSource.getChats(user:user));
      } on Exception {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }*/

  /*
  @override
  Future<Either<Failure, Chat>> getChat({User sender, String receiver}) async{
    if (await networkInfo.isConnected) {
      try {
        return Right(await remoteDataSource.getChat(sender:sender,receiver:receiver));
      } on Exception {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }*/

  @override
  Future<Either<Failure, Stream<List<Message>>>> startConversation({User sender, String receiver}) async{
    if (await networkInfo.isConnected) {
      try {
        //return Right(await remoteDataSource.startConversation(sender:sender,receiver:receiver));
      }  on ServerException catch(e) {
        return Left(ServerFailure(error: e.error));
      } on Exception {
        return Left(ServerFailure(error: 'Server error'));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }


  

  @override
  Future<Either<Failure, void>> cacheMeditation({Meditation m, User  u}) async {
    try {
      await localDataSource.cacheMeditation(m,u);
    } on ServerException catch(e) {
      return Left(ServerFailure(error: e.error));
    } on Exception {
      return Left(ServerFailure());
    }
  }

  /*
  @override
  Future<Either<Failure, void>> createRetreat({Retreat r}) async{
    try{
      await remoteDataSource.createRetreat(r:r); 
    }on Exception {
      return Left(ServerFailure());
    }
  }*/

  @override
  Future<Either<Failure, List<Retreat>>> getRetreats() {
    // TODO: implement getRetreats
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Retreat>> joinRetreat(String cod) {
    // TODO: implement joinRetreat
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, List<Request>>> getStageRequests() async{
    try{
    //  final requests = await remoteDataSource.getStageRequests(); 

     // return Right(requests);
    } on ServerException catch(e){
      return Left(ServerFailure(error: e.error));
    } on Exception {
      return Left(ServerFailure());
    }
  }
  
  @override
  Future<Either<Failure, void>> addMeditationReport({Meditation m, MeditationReport report, User user}) async{
    try {
      if(await networkInfo.isConnected){
        await remoteDataSource.addMeditationReport(m: m, report:report, user: user);
      }else{
        await localDataSource.addMeditationReport(m, report);
      }
      return Right(null);
    } on ServerException catch(e) {
      return Left(ServerFailure(error: e.error));
    } on Exception {
      return Left(ServerFailure());
    }
  }
  
  @override
  Future<Either<Failure, void>> sendQuestion({String question, String coduser}) async {
    try {
      // SI NO  ESTA CONECTADO DEBERÍA DE DEVOLVER CONNECTION FAILURE
      if(await networkInfo.isConnected){
        await remoteDataSource.sendQuestion(question: question, coduser: coduser); 
      }
      return Right(null);
    } on ServerException catch(e) {
      return Left(ServerFailure(error: e.error));
    } on Exception {
      return Left(ServerFailure());
    }
  }
  
  @override
  Future<Either<Failure, void>> setUserName({String username, String coduser}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.setUsername(username: username, coduser: coduser);
        return Right(null);
      }  on ServerException catch(e) {
        return Left(ServerFailure(error: e.error));
      } on Exception {
        return Left(ServerFailure());
      }
    } else {
      //Hay que arreglar este método
      return Left(ConnectionFailure());
    }
  }
  
  @override
  Future<Either<Failure, Content>> getContent(String cod) async {

    if(await networkInfo.isConnected){
      try {
        final content = await remoteDataSource.getContent(cod);
        return Right(content);
      } on ServerException catch(e) {
        return Left(ServerFailure(error: e.error));
      } on Exception {
        return Left(ServerFailure());
      }
    }else{
      return Left(ConnectionFailure());
    }
  }
  
  @override
  Future<Either<Failure, List<Request>>> getFeed() async {

     if(await networkInfo.isConnected){
      try {
        final content = await remoteDataSource.getFeed();
        return Right(content);
      } on ServerException catch(e) {
        return Left(ServerFailure(error: e.error));
      } on Exception {
        return Left(ServerFailure());
      }
    }else{
      return Left(ConnectionFailure());
    }

  }
}
