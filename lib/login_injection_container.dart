import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:meditation_app/core/network/network_info.dart';
import 'package:meditation_app/data/datasources/firestore_mock.dart';
import 'package:meditation_app/data/datasources/local_datasource.dart';
import 'package:meditation_app/data/datasources/remote_data_source.dart';
import 'package:meditation_app/data/repositories/meditation_repository.dart';
import 'package:meditation_app/data/repositories/user_repository.dart';
import 'package:meditation_app/domain/repositories/meditation_repository.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';
import 'package:meditation_app/domain/usecases/lesson/get_brain_lessons.dart';
import 'package:meditation_app/domain/usecases/lesson/take_lesson.dart';
import 'package:meditation_app/domain/usecases/meditation/take_meditation.dart';
import 'package:meditation_app/domain/usecases/user/get_data.dart';
import 'package:meditation_app/domain/usecases/user/isloggedin.dart';
import 'package:meditation_app/domain/usecases/user/loginUser.dart';
import 'package:meditation_app/domain/usecases/user/registerUser.dart';
import 'package:meditation_app/presentation/mobx/login_register/login_state.dart';
import 'package:meditation_app/presentation/mobx/login_register/register_state.dart';
import 'package:mock_cloud_firestore/mock_cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/repositories/lesson_repository.dart';
import 'domain/repositories/lesson_repository.dart';
import 'domain/usecases/user/log_out.dart';
import 'presentation/mobx/actions/lesson_state.dart';
import 'presentation/mobx/actions/meditation_state.dart';
import 'presentation/mobx/actions/menu_state.dart';
import 'presentation/mobx/actions/user_state.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //Mobx
  sl.registerFactory(
    () => LoginState(loginUseCase: sl()),
  );

  sl.registerFactory(
    () => RegisterState(registerUseCase:sl()),
  );

  sl.registerFactory(
    () => MeditationState(),
  );

  sl.registerFactory(
    () => UserState(cachedUseCase: sl(),meditate: sl(),data: sl(),logout:sl(),lesson: sl()),
  );

  sl.registerFactory(
    () => LessonState(brainlessonsUseCase: sl()),
  );

  sl.registerFactory(
    () => MenuState(sidebarRoute: '/main',bottomenuindex: 1),
  );


  //Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(()=> CachedUserUseCase(sl()));
  sl.registerLazySingleton(()=> GetBrainLessonsUseCase(sl()));
  sl.registerLazySingleton(()=> MeditateUseCase(sl(),sl()));
  sl.registerLazySingleton(()=> GetDataUseCase(sl()));
  sl.registerLazySingleton(() => LogOutUseCase(sl()));
  sl.registerLazySingleton(()=> TakeLessonUseCase(sl(),sl()));



  //Repositories
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
      remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));

   sl.registerLazySingleton<LessonRepository>(() => LessonRepositoryImpl(
      remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));

   sl.registerLazySingleton<MeditationRepository>(() => MeditationRepositoryImpl(
     localDataSource: sl(), remoteDataSource: sl(), networkInfo: sl())); 


   //Network info
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //External
  final sharedPreferences = await SharedPreferences.getInstance();
  final database = DatabaseString();
  //final cloudfirestore = new MockCloudFirestore(database.db);
  sl.registerLazySingleton(()=> sharedPreferences);
  sl.registerLazySingleton(() => MockCloudFirestore(database.db));
 // sl.registerLazySingleton(()=> CollectionReference);
  sl.registerLazySingleton(() => DataConnectionChecker());
}
