import 'package:get_it/get_it.dart';
import 'package:meditation_app/presentation/blocs/bloc/login_bloc_bloc.dart';

class InjectionContainer {
  final sl = GetIt.instance();

  void init() {
    //Bloc
    sl.registerFactory(
      () => LoginBloc(),
    );
  }
}
