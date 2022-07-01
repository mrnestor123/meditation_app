import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
 // List properties;
  final String error;
  Failure({this.error});

  @override
  List<Object> get props => [error];
}

// General failures
class ServerFailure extends Failure {
  ServerFailure({String error}) : super(error:error);
}

class CacheFailure extends Failure {
  CacheFailure({String error}) : super(error:error);
}

class LoginFailure extends Failure{
  LoginFailure({String error}) : super(error:error);
}

class EmailFailure extends Failure{
  EmailFailure({String error}) : super(error:error);
}

class RegisterFailure extends Failure{
  RegisterFailure({String error}) : super(error:error);
}

class MeditationFailure extends Failure {
  MeditationFailure({String error}): super(error:error);
}

class ConnectionFailure extends Failure {
  ConnectionFailure({String error}): super(error:error);
}

class UserExistsFailure extends Failure {
  UserExistsFailure({String error}): super(error:error);
}


