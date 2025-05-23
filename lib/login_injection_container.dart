import 'package:audio_service/audio_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:meditation_app/core/network/network_info.dart';
import 'package:meditation_app/data/datasources/local_datasource.dart';
import 'package:meditation_app/data/datasources/remote_data_source.dart';
import 'package:meditation_app/data/repositories/user_repository.dart';
import 'package:meditation_app/domain/entities/audio_handler.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';
import 'package:meditation_app/presentation/mobx/actions/meditation_state.dart';
import 'package:meditation_app/presentation/mobx/actions/profile_state.dart';
import 'package:meditation_app/presentation/mobx/actions/requests_state.dart';
import 'package:meditation_app/presentation/mobx/login_register/login_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'presentation/mobx/actions/game_state.dart';
import 'presentation/mobx/actions/user_state.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await Firebase.initializeApp();
  
  //Mobx
  sl.registerFactory(
    () => LoginState(repository: sl()),
  );

  // HAY  QUE  QUITAR ESTO !!!
  sl.registerFactory(
    () => MeditationState(),
  );

  /// A lo mejor userstate hace demasiado ??
  sl.registerFactory(
    () => UserState(userRepository: sl()),
  );

  sl.registerFactory(
    () => GameState(repository: sl()),
  );

   sl.registerFactory(
    () => ProfileState(userRepository: sl()),
  );

  sl.registerFactory(
    () => RequestState(repository: sl()),
  );


  //Repositories
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
    remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));


  //Network info
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  //Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl());
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(()=> sharedPreferences);
  
  sl.registerSingleton<AudioHandler>(await initAudioService());
}
