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

abstract class UserRepository {
  //Use Case for login users
  Future<Either<Failure, User>> loginUser({var usuario});

  Future<Either<Failure, User>> registerUser({var usuario});

  Future<Either<Failure, User>> islogged();

  Future<Either<Failure, DataBase>> getData();

  Future<Either<Failure, bool>> logout();

  Future<Either<Failure, User>> updateUser({User user,DataBase d, String type, dynamic toAdd});

  Future<Either<Failure,String>> uploadFile({dynamic image,dynamic audio, dynamic video, User u});

  Future<Either<Failure,List<Request>>> getRequests();

  Future<Either<Failure,void>> updateRequest(Request r,[Notify n]);

  Future<Either<Failure,void>> uploadRequest(Request r);

  Future<Either<Failure, List<User>>> getUsers(User u);

  Future<Either<Failure, List<User>>> getTeachers();

  Future<Either<Failure, User>> getUser(String cod);

  Future<Either<Failure,Request>>getRequest(String cod);

  Future<Either<Failure,void>> updateNotification(Notify n);

  Future<Either<Failure,void>> sendMessage({Message message});

  Future<Either<Failure,void>> updateMessage({Message message});

  Future<Either<Failure,void>> uploadContent({Content c});
  
}
