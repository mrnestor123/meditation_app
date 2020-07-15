import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/network/network_info.dart';
import 'package:meditation_app/data/datasources/local_datasource.dart';
import 'package:meditation_app/data/datasources/remote_data_source.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/meditation_repository.dart';

class MeditationRepositoryImpl implements MeditationRepository {
  UserRemoteDataSource remoteDataSource;
  UserLocalDataSource localDataSource;
  NetworkInfo networkInfo;

  MeditationRepositoryImpl(
      {@required this.remoteDataSource,
      @required this.localDataSource,
      @required this.networkInfo});

  @override
  Future<Either<Failure, Meditation>> meditate({Duration d, User user}) async {
    // TODO: implement meditate
    Meditation m = await remoteDataSource.meditate(d, user);

    return Right(m);

  }
}
