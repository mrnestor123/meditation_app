import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/message.dart';
import 'package:meditation_app/domain/entities/notification_entity.dart';
import 'package:meditation_app/domain/entities/request_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';

import '../entities/action_entity.dart';
import '../entities/retreat_entity.dart';

abstract class UserRepository {
  //Use Case for login users
  Future<Either<Failure, User>> loginUser({var usuario});

  Future<Either<Failure, User>> registerUser({var usuario});

  Future<Either<Failure, User>> islogged();

  Future<Either<Failure, DataBase>> getData();

  Future<Either<Failure, bool>> logout();

  Future<Either<Failure, User>> updateUser({User user,DataBase d, String type, dynamic toAdd,  DoneContent done});

  Future<Either<Failure, void>> setUserName({String username, String coduser});

  Future<Either<Failure,String>> uploadFile({dynamic image,dynamic audio, dynamic video, User u});

  Future<Either<Failure, void>> cacheMeditation({Meditation m, User u});


  Future<Either<Failure,List<Request>>> getRequests();

  Future<Either<Failure,void>> updateRequest(Request r,[List<Notify> n, Comment c]);

  Future<Either<Failure,void>> uploadRequest(Request r);

  Future<Either<Failure, List<User>>> getUsers(User u);

  Future<Either<Failure, List<User>>> getTeachers();

  // FUNCIÓN PARA SACAR EL USUARIO CON LECCIONES Y MEDITACIONES !!!!!
  Future<Either<Failure, User>> getUser(String cod, [bool expand]);

  Future<Either<Failure,Request>> getRequest(String cod);

  Future<Either<Failure,void>> updateNotification(Notify n);

  Future<Either<Failure,void>> sendMessage({Message message});

  Future<Either<Failure,void>> updateMessage({Message message});

  Future<Either<Failure,void>> deleteUser({User user});

  Future<Either<Failure, void>> addAction({UserAction a});

  Future<Either<Failure, List<Request>>> getFeed();

  Future<Either<Failure, Stream<List<Message>>>> startConversation({User sender, String receiver});

 // Future<Either<Failure, List<Retreat>>> getRetreats();

//  Future<Either<Failure, Retreat>> joinRetreat(String cod);

  Future<Either<Failure, List<Request>>> getStageRequests();

  Future<Either<Failure, void >> addMeditationReport({Meditation m, MeditationReport report, User user});

  Future<Either<Failure, void>> sendQuestion({String question, String coduser});

  Future<Either<Failure, Content>> getContent(String cod);

}
