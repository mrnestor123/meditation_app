import 'package:meditation_app/data/models/userData.dart';

//This will use the sqlite database. But in the future it will be added to the server.
abstract class UserRemoteDataSource {
  /// Logins a user to the DataBase
  ///
  /// Throws a [ServerException] for all error codes.
  Future<UserModel> loginUser({String password, String usuario});

  Future<UserModel> registerUser(
      {String nombre,
      String mail,
      String nomuser,
      String password,
      String usuario,
      int stagenumber});
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  //Habrá que cambiar este método yo creo por meter un UserModel
  @override
  Future<UserModel> loginUser({String password, String usuario}) {
    // TODO: implement loginUser
    return null;
  }

  @override
  Future<UserModel> registerUser(
      {String nombre,
      String mail,
      String nomuser,
      String password,
      String usuario,
      int stagenumber}) {
    return null;
  }
}
