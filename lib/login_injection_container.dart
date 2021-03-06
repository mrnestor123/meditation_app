import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:meditation_app/core/network/network_info.dart';
import 'package:meditation_app/data/datasources/firestore_mock.dart';
import 'package:meditation_app/data/datasources/local_datasource.dart';
import 'package:meditation_app/data/datasources/remote_data_source.dart';
import 'package:meditation_app/data/repositories/meditation_repository.dart';
import 'package:meditation_app/data/repositories/user_repository.dart';
import 'package:meditation_app/domain/repositories/meditation_repository.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';
import 'package:meditation_app/domain/usecases/lesson/take_lesson.dart';
import 'package:meditation_app/domain/usecases/meditation/take_meditation.dart';
import 'package:meditation_app/domain/usecases/user/answer_question.dart';
import 'package:meditation_app/domain/usecases/user/get_data.dart';
import 'package:meditation_app/domain/usecases/user/isloggedin.dart';
import 'package:meditation_app/domain/usecases/user/loginUser.dart';
import 'package:meditation_app/domain/usecases/user/registerUser.dart';
import 'package:meditation_app/domain/usecases/user/update_image.dart';
import 'package:meditation_app/domain/usecases/user/update_stage.dart';
import 'package:meditation_app/domain/usecases/user/follow_user.dart';
import 'package:meditation_app/presentation/mobx/login_register/login_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/repositories/lesson_repository.dart';
import 'domain/repositories/lesson_repository.dart';
import 'domain/usecases/user/change_data.dart';
import 'domain/usecases/user/log_out.dart';
import 'presentation/mobx/actions/game_state.dart';
import 'presentation/mobx/actions/meditation_state.dart';
import 'presentation/mobx/actions/menu_state.dart';
import 'presentation/mobx/actions/user_state.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await Firebase.initializeApp();
  //Mobx
  sl.registerFactory(
    () => LoginState(loginUseCase: sl(), registerUseCase:sl(), logout:sl(),),
  );

  sl.registerFactory(
    () => MeditationState(meditate: sl()),
  );

  /// A lo mejor userstate hace demasiado ??
  sl.registerFactory(
    () => UserState(cachedUseCase: sl(),meditate: sl(),data: sl(),lesson: sl(),updateUserUseCase: sl(), updateStageUseCase: sl(),updateImageUseCase: sl(),changeDataUseCase: sl()),
  );

  sl.registerFactory(
    () => MenuState(sidebarRoute: '/main',bottomenuindex: 1),
  );

  sl.registerFactory(
    () => GameState(answerusecase: sl()),
  );


  //Use cases
  sl.registerLazySingleton(() => AnswerQuestionUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(()=> CachedUserUseCase(sl()));
  sl.registerLazySingleton(()=> MeditateUseCase(sl(),sl()));
  sl.registerLazySingleton(()=> GetDataUseCase(sl()));
  sl.registerLazySingleton(() => LogOutUseCase(sl()));
  sl.registerLazySingleton(()=> TakeLessonUseCase(sl(),sl()));
  sl.registerLazySingleton(() => FollowUseCase(sl()));
  sl.registerLazySingleton(()=> ChangeDataUseCase(sl()));
  sl.registerLazySingleton(()=> UpdateStageUseCase(sl()));
  sl.registerLazySingleton(()=> UpdateImageUseCase(sl()));

  //Repositories
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
      remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));

   sl.registerLazySingleton<LessonRepository>(() => LessonRepositoryImpl(
      remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));

   sl.registerLazySingleton<MeditationRepository>(() => MeditationRepositoryImpl(
     localDataSource: sl(), remoteDataSource: sl(), networkInfo: sl())); 


   //Network info
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  //Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl());
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(()=> sharedPreferences);
}
