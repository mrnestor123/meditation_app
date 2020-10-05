import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';
import 'package:meditation_app/domain/usecases/get_user_details.dart';
import 'package:meditation_app/domain/usecases/get_user_details.dart';
import 'package:mockito/mockito.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  GetUserDetails usecase;
  MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = GetUserDetails(mockUserRepository);
  });

  final tcodUser = 1;
  //Habra que comprobar si los datos estan bien metidos en el usecase
  final tUser = User(
      coduser: 1,
      mail: "ernest@gmail.com",
      usuario: "ernestino",
      password: "ernesto",
      stagenumber: 1);

  test(
    'should get the user from the repository',
    () async {
      // "On the fly" implementation of the Repository using the Mockito package.
      // When getUserDetails is called with any argument, always answer with
      // the Right "side" of Either containing a test NumberTrivia object.
      when(mockUserRepository.getUserDetails(any))
          .thenAnswer((_) async => Right(tUser));
      // The "act" phase of the test. Call the not-yet-existent method.
      final result = await usecase.execute(coduser: tcodUser);
      // UseCase should simply return whatever was returned from the Repository
      expect(result, Right(tUser));
      // Verify that the method has been called on the Repository
      verify(mockUserRepository.getUserDetails(tcodUser));
      // Only the above method should be called and nothing more.
      verifyNoMoreInteractions(mockUserRepository);
    },
  );
}
