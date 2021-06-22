import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/usecases/usecase.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';

class RegisterUseCase extends UseCase<User, RegisterParams> {
  UserRepository repository;

  RegisterUseCase(this.repository);

  //Para registrar un usuario. Primero creamos el usuario, luego le añadimos las lecciones que tiene por la etapa que está.
  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
  
    // Aquí a lo mejor hay que comprobar los datos?. Añadirlo a alguna stage? Habrá que pasarle datos?
    var user = await repository.registerUser(usuario: params.user);

    return user;
  }
}

class RegisterParams {
  var user;

  RegisterParams({
    this.user,
  });

  //ESTO es interesante de utilizar
  bool validatePassword(String password) {
    if (password.length > 6) {
      return true;
    } else {
      return false;
    }
  }

  bool validateMail(String mail) {
    const emailRegex =
        r"""^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+""";

    if (RegExp(emailRegex).hasMatch(mail)) {
      return true;
    } else {
      return false;
    }
  }
}
