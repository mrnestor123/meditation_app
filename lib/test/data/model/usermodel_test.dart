import 'package:flutter_test/flutter_test.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';

void main() {
  final UserModel = UserModel();

  test(
    'should be a subclass of NumberTrivia entity',
    () async {
      // assert
      expect(UserModel, isA<User>());
    },
  );
}
