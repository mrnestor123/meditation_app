import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meditation_app/core/error/exception.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/platform/network_info.dart';
import 'package:meditation_app/data/datasources/local_datasource.dart';
import 'package:meditation_app/data/datasources/remote_data_source.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/data/repositories/user_repository.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock implements UserRemoteDataSource {}

class MockLocalDataSource extends Mock implements UserLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  UserRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = UserRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('loginUser', () {
    // DATA FOR THE MOCKS AND ASSERTIONS
    // We'll use these three variables throughout all the tests
    final nombre = "Ernest";
    final username = "ernestino";
    final password = "ernesto";
    final mail = "ernestbarra97@gmail.com";

    final userModel = UserModel(
        nombre: nombre,
        mail: mail,
        usuario: username,
        password: password,
        stagenumber: 1);

    final User user = userModel;

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test('should check if the device is online', () {
        //arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act

        final result = repository.loginUser(
            nombre: nombre,
            mail: mail,
            usuario: username,
            password: password,
            stagenumber: 1);
        // assert
        verify(mockRemoteDataSource.loginUser(
            nombre: nombre,
            mail: mail,
            usuario: username,
            password: password,
            stagenumber: 1));

        verify(mockLocalDataSource.cacheUser(user));

        expect(result, equals(Right(user)));
      });

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.loginUser(
                  nombre: nombre,
                  mail: mail,
                  usuario: username,
                  password: password,
                  stagenumber: 1))
              .thenThrow(ServerException());
          // act
          final result = await repository.loginUser(
              nombre: nombre,
              mail: mail,
              usuario: username,
              password: password,
              stagenumber: 1);
          // assert
          verify(mockRemoteDataSource.loginUser(
              nombre: nombre,
              mail: mail,
              usuario: username,
              password: password,
              stagenumber: 1));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getUser()).thenAnswer((_) async => user);
          // act
          final result = await repository.loginUser(
              nombre: nombre,
              mail: mail,
              usuario: username,
              password: password,
              stagenumber: 1);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getUser());
          expect(result, equals(Right(user)));
        },
      );

      test(
        'should return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(mockLocalDataSource.getUser()).thenThrow(CacheException());
          // act
          final result = await repository.loginUser(
              nombre: nombre,
              mail: mail,
              usuario: username,
              password: password,
              stagenumber: 1);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getUser());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
