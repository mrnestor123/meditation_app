class RegularException implements Exception {
  // List properties;
  final String error;
  RegularException({this.error});
}


class ServerException extends RegularException {
  ServerException({String error}) : super(error:error);


  @override
  String toString(){
    
    return '$error';
  }
}

class CacheException extends RegularException {
  CacheException({String error}) : super(error:error);
}

class UserException extends RegularException {
  UserException({String error}) : super(error:error);
}

class LoginException extends RegularException {
  LoginException({String error}) : super(error:error);
}

class LessonException extends RegularException {
  LessonException({String error}) : super(error:error);
}

class DataException extends RegularException {
  DataException({String error}) : super(error:error);
}

class MeditationException extends RegularException {
  MeditationException({String error}) : super(error:error);
}

