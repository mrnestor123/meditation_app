
import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/presentation/pages/commonWidget/error_dialog.dart';
import 'package:meditation_app/presentation/pages/main.dart';


void foldResult({Either<Failure,dynamic> result, dynamic onSuccess}){
  String errorMessage;
  String header;

  String _mapFailureToMessage(Failure failure) {   
    // Instead of a regular 'if (failure is ServerFailure)...'
    switch (failure.runtimeType) {
      case ServerFailure:
        header ='Server failure';
        errorMessage = 'An unexpected error has ocurred';
        break;
      case CacheFailure:
        header = 'Cache failure';
        errorMessage = 'An unexpected error has ocurred';
        break;
      case LoginFailure: 
        errorMessage = failure.error != null ? failure.error : 'User not found in the database';
        break;
      case ConnectionFailure: 
        errorMessage = 'You are not connected to the internet. Please, connect to it and restart the application';
        header = 'Connection Failure';
        break;
      default:
        errorMessage = 'Unexpected Error';
        break;
    }

    return errorMessage;
  }

  result.fold(
    (Failure l) { 
      _mapFailureToMessage(l);
      // SE PODRIA PONER AQUÍ !! 
      showErrorDialog(header: header, description: errorMessage);
      navigatorKey.currentState.setState(() {});
    }, 
    (r) { if(onSuccess !=null) onSuccess(r); }
  );
}
