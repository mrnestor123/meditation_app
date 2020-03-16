import 'package:equatable/equatable.dart';
import 'package:flutter/semantics.dart';

abstract class Failure extends Equatable {
  List properties;
  Failure([List properties = const <dynamic>[]]);

  @override
  List<Object> get props => [properties];
}

// General failures
class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
