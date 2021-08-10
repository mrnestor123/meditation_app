
import 'package:meditation_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/usecases/usecase.dart';
import 'package:meditation_app/domain/entities/request_entity.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';

class GetRequestsUseCase extends UseCase<List<Request>, NoParams>{
  UserRepository repository;

  GetRequestsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Request>>> call(NoParams params) {
     return repository.getRequests();
  }
}

