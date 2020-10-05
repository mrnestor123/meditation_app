import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/usecases/usecase.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/mission.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/usecases/lesson/take_lesson.dart';
import 'package:meditation_app/domain/usecases/meditation/take_meditation.dart';
import 'package:meditation_app/domain/usecases/user/get_data.dart';
import 'package:meditation_app/domain/usecases/user/isloggedin.dart';
import 'package:meditation_app/domain/usecases/user/log_out.dart';
import 'package:mobx/mobx.dart';

part 'user_state.g.dart';

class UserState extends _UserState with _$UserState {
  UserState(
      {CachedUserUseCase cachedUseCase,
      MeditateUseCase meditate,
      LogOutUseCase logout,
      GetDataUseCase data,
      TakeLessonUseCase lesson})
      : super(
            cachedUser: cachedUseCase,
            meditate: meditate,
            getdata: data,
            logoutusecase: logout,
            lesson: lesson);
}

abstract class _UserState with Store {
  CachedUserUseCase cachedUser;
  MeditateUseCase meditate;
  GetDataUseCase getdata;
  TakeLessonUseCase lesson;

  LogOutUseCase logoutusecase;

  _UserState(
      {this.cachedUser,
      this.meditate,
      this.getdata,
      this.logoutusecase,
      this.lesson});

  @observable
  User user;

  @observable
  bool nightmode = false;

  @observable
  bool loggedin;

  @observable
  Map lessondata;

  @observable
  int _menuindex = 1;

  @computed
  int get menuindex => _menuindex;

  @action
  void setUser(var u) {
    user = u;
  }

  @action
  Future userisLogged() async {
    Either<Failure, User> _isUserCached = await cachedUser.call(NoParams());
    _isUserCached.fold((Failure f) => loggedin = false, (User u) {
      user = u;
      loggedin = true;
    });
  }

  @action
  Future<List<Mission>> takeMeditation(Duration d) async {
    Either<Failure, List<Mission>> meditation =
        await meditate.call(Params(duration: d, user: user));

    List<Mission> m = new List<Mission>();

    meditation
        .fold((Failure f) => print("something happened with the meditation"),
            (List<Mission> missions) {
      print('The meditation has been a success');
      m = missions;
    });
    return m;
  }

  @action
  Future<List<Mission>> takeLesson(LessonModel l) async {
    int currentstage = user.stagenumber;
    Either<Failure, List<Mission>> lessonsuccess =
        await lesson.call(LessonParams(lesson: l, user: user));
    
    List<Mission> result = new List<Mission>();

    if (lessonsuccess != null) {
      lessonsuccess
          .fold((Failure f) => print("something happened with the lesson"),
              (List<Mission> missions) {
        print("We passed a mission");
        result = missions;
      });
    }

    return result;
  }

  //We get all the necessary data for displaying the app from the database and the
  @action
  Future getData() async {
    final result = await getdata.call(NoParams());

    result.fold((Failure f) => print(f.error), (Map m) {
      lessondata = m;
    });
  }

  @action
  void changeBottomMenu(int stage) {
    _menuindex = stage + 1;
  }

  @action
  Future logout() async {
    user = null;
    loggedin = false;
    await logoutusecase.call(NoParams());
  }
}
