import 'package:flutter_test/flutter_test.dart';
import 'package:meditation_app/domain/services/database_Service.dart';

void main() {
  test('DataBase testing', () {
    //We instantiate the database

    DB.init();
    print('why it does not get printed');
  });
}
