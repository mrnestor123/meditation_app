

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meditation_app/core/error/failures.dart';

class EmailAddress extends Equatable{

  final Either<Failure,String> value;

  factory EmailAddress(String input){
    assert(input != null);
    return EmailAddress._(validateEmailAddress(input),);
  }

  const EmailAddress._(this.value) ;

  @override
  List<Object> get props => [value];
}

Either<Failure,String> validateEmailAddress(String input){
  const emailRegex = r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";
  
  if (RegExp(emailRegex).hasMatch(input)) {
    return right(input);
  } else {
    return left(EmailFailure(error:'Email is not correct'));
  }
}