
import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialogs.dart';
import 'package:meditation_app/presentation/pages/main.dart';

import '../../pages/commonWidget/dialogs.dart';


void foldResult({Either<Failure,dynamic> result, dynamic onSuccess}){
  String errorMessage;
  String header;

  String _mapFailureToMessage(Failure failure) {   
    if(failure.error != null && failure.error.isNotEmpty){
      errorMessage = failure.error;
     }
    // Instead of a regular 'if (failure is ServerFailure)...'
    switch (failure.runtimeType) {
      case ServerFailure:
        header ='Server failure';
        if(errorMessage==null || errorMessage.isEmpty) errorMessage =  'Could not connect to the server';
        break;
      case CacheFailure:
        header = 'Cache failure';
        if(errorMessage==null || errorMessage.isEmpty) errorMessage = 'Could not connect to the server';
        break;
      case LoginFailure: 
        if(errorMessage==null || errorMessage.isEmpty) errorMessage = failure.error != null ? failure.error : 'User not found in the database';
        break;
      case ConnectionFailure: 
        if(errorMessage==null || errorMessage.isEmpty) errorMessage = 'You are not connected to the internet. Please, connect to it to save the app data';
        header = 'Connection Failure';
        break;
      default:
        if(errorMessage==null || errorMessage.isEmpty) errorMessage = 'Unexpected Error';
        break;
    }

    return errorMessage;
  }

  result.fold(
    (Failure l) { 
      _mapFailureToMessage(l);
      // SE PODRIA PONER AQUÍ !! 
      showInfoDialog(header: header, description: errorMessage);
      navigatorKey.currentState.setState(() {});
    }, 
    (r) { if(onSuccess !=null) onSuccess(r); }
  );
}
