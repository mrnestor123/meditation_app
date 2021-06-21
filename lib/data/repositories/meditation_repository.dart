import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/network/network_info.dart';
import 'package:meditation_app/data/datasources/local_datasource.dart';
import 'package:meditation_app/data/datasources/remote_data_source.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/mission.dart';
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
  Future<Either<Failure, bool>> meditate({MeditationModel meditation, UserModel user}) async {
    if (await networkInfo.isConnected) {
     // await remoteDataSource.meditate(meditation, user);
     // await localDataSource.addMeditation(meditation, user);
      return Right(true);
    } else {
     // await localDataSource.addMeditation(meditation, user);
      return Right(true);
    }
  }

  @override
  Future<Either<Failure, List<Meditation>>> getmeditations() {}
}
