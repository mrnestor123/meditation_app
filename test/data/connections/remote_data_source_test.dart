import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meditation_app/data/datasources/firestore_mock.dart';
import 'package:meditation_app/data/datasources/remote_data_source.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/auth/email_address.dart';
import 'package:mock_cloud_firestore/mock_cloud_firestore.dart';
import 'package:mockito/mockito.dart';

void main() {
  UserRemoteDataSourceImpl remoteSource;
  MockCloudFirestore database;
  DatabaseString databaseString;
  setUp(() {
    databaseString = DatabaseString();
    database = MockCloudFirestore(databaseString.db);
    remoteSource = UserRemoteDataSourceImpl(database);
  });

  group(
    'user registration ',
    () {
      test(
        'returns the user registered and if the lessons have been added',
        () async {
          //We create the user and then we add user lists to it
          UserModel user = await remoteSource.registerUser(
              mail: 'ernest@gmail.com',
              nombre: 'ernest',
              usuario: 'ernestino',
              password: 'ernesto',
              stagenumber: 1);
          
          List<LessonModel> l = await remoteSource.getStageLessons(stage:1);
          user.setRemainingLessons(l);

          expect(user.remainingLessons.length>0 , true);
          expect(user == null, false);  
        },
      );
    },
  );

  group(
    'user login',
    () {
      test(
        'returns if the user logged is not null',
        () async {
          UserModel user = await remoteSource.loginUser(
              usuario: 'ernestino', password: 'ernesto');
          expect(user == null, false);
        },
      );
    },
  );

  group('get lessons', () {
    test(
      'check getlessons method',
      () async {
        List<LessonModel> list = await remoteSource.getStageLessons(stage: 1);
        expect(list.length > 0, true);
      },
    );
  });
}
