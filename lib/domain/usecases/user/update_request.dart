

import 'package:meditation_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/usecases/usecase.dart';
import 'package:meditation_app/domain/entities/request_entity.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';

class UpdateRequestUseCase extends UseCase<void, ReqParams>{
  UserRepository repository;

  UpdateRequestUseCase(this.repository);

  //añadir comentario también podria estar aqui !!!
  @override
  Future<Either<Failure, void>> call(ReqParams params) {
     /*if(params.like){
       params.r.like(params.cod);
     }else{
       params.r.dislike(params.cod);
     }*/
     
     return repository.updateRequest(params.r);
  }
}

class ReqParams{
  Request r;
  bool like;
  String cod;
  ReqParams({this.r,this.like,this.cod});
}