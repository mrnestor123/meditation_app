import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/network/network_info.dart';
import 'package:meditation_app/data/datasources/local_datasource.dart';
import 'package:meditation_app/data/datasources/remote_data_source.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/domain/entities/lesson_entity.dart';
import 'package:meditation_app/domain/entities/mission.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/lesson_repository.dart';

class LessonRepositoryImpl implements LessonRepository{

  UserRemoteDataSource remoteDataSource;
  UserLocalDataSource localDataSource;
  NetworkInfo networkInfo;

  LessonRepositoryImpl(
      {@required this.remoteDataSource,
      @required this.localDataSource,
      @required this.networkInfo});


  //Me llevo el missions de antes hasta aquí !! Esto no debería de ser así..
  @override
  Future<Either<Failure, List<Mission>>> takeLesson({Lesson lesson, User user,List<Mission> missions,List<Lesson> unlockedlessons}) async{
    if(await networkInfo.isConnected){
     try{
       await remoteDataSource.takeLesson(lesson,user,unlockedlessons);
       await localDataSource.takeLesson(user);
       return Right(missions);
      }on Exception {
       return Left(ServerFailure());
     }
    }
    return null;
  }

  @override
  Future<Either<Failure, void>> addLesson({Lesson lesson}) {
    // TODO: implement addLesson
    return null;
  }

  @override 
  Future<Either<Failure,List<LessonModel>>> getBrainLessons({int stage}) async{
      if(await networkInfo.isConnected){
        try {
          final lessons= await remoteDataSource.getBrainLessons(stage: stage);
          return Right(lessons);
        }on Exception {
          return Left(ServerFailure());
        }
      }else {
        return Left(ServerFailure());
      }
  }


  @override 
  Future<Either<Failure,List<LessonModel>>> getMeditationLessons({int stage}){
    return null;
  }


}