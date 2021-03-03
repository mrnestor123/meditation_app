import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/usecases/usecase.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/mission.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/usecases/lesson/take_lesson.dart';
import 'package:meditation_app/domain/usecases/meditation/take_meditation.dart';
import 'package:meditation_app/domain/usecases/user/get_data.dart';
import 'package:meditation_app/domain/usecases/user/isloggedin.dart';
import 'package:meditation_app/domain/usecases/user/log_out.dart';
import 'package:meditation_app/domain/usecases/user/loginUser.dart';
import 'package:meditation_app/domain/usecases/user/update_user.dart';
import 'package:mobx/mobx.dart';

part 'user_state.g.dart';

class UserState extends _UserState with _$UserState {
  UserState(
      {CachedUserUseCase cachedUseCase,
      MeditateUseCase meditate,
      LogOutUseCase logout,
      GetDataUseCase data,
      TakeLessonUseCase lesson,
      UpdateUserUseCase updateUserUseCase})
      : super(
            cachedUser: cachedUseCase,
            meditate: meditate,
            getdata: data,
            logoutusecase: logout,
            lesson: lesson,
            updateUserUseCase: updateUserUseCase);
}

abstract class _UserState with Store {
  CachedUserUseCase cachedUser;
  MeditateUseCase meditate;
  GetDataUseCase getdata;
  TakeLessonUseCase lesson;
  LogOutUseCase logoutusecase;
  UpdateUserUseCase updateUserUseCase;

  _UserState(
      {this.cachedUser,
      this.meditate,
      this.getdata,
      this.logoutusecase,
      this.lesson,
      this.updateUserUseCase});

  @observable
  User user;

  @observable
  DataBase data;

  @observable
  bool nightmode = false;

  @observable
  bool loggedin;

  @observable
  Map lessondata;

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

  //SE PUEDE BORRARRR
  @action
  Future<bool> takeMeditation(Duration d) async {
    int currentposition = user.position;
    Either<Failure, User> meditation =
        await meditate.call(Params(duration: d, user: user, d: data));

    List<Mission> m = new List<Mission>();

    if (currentposition < user.position) {
      return true;
    } else {
      return false;
    }
  }

  //Esto tiene que ser LESSONNNNNNNN
  @action
  Future<bool> takeLesson(LessonModel l) async {
    int currentposition = user.position;
    await lesson.call(LessonParams(lesson: l, user: user, d: data));

    if (currentposition < user.position) {
      return true;
    } else {
      return false;
    }
  }

  //We get all the necessary data for displaying the app from the database and the
  @action
  Future getData() async {
    final result = await getdata.call(NoParams());

    result.fold((Failure f) => print(f.error), (DataBase d) {
      data = d;
    });
  }

  @action
  Future follow(User u, bool follow) async {
    final following = updateUserUseCase.call(UParams(user: user, followeduser: u, type: follow ? 'follow' : 'unfollow'));
  }

  @action
  Future logout() async {
    user = null;
    loggedin = false;
    await logoutusecase.call(NoParams());
  }

  @action
  Future changeName(String username) async {
    Either<Failure, User> _addedname = await updateUserUseCase
        .call(UParams(user: user, nombre: username, type: "name"));

    return true;
  }

  @action
  Future updateUser(String path, String type) async {
    Either<Failure, User> _addedname = await updateUserUseCase
        .call(UParams(user: user, type: type, image: path));
  }

  @action
  Future updateStage() async {
    Either<Failure, User> _addedname = await updateUserUseCase
        .call(UParams(user: user, type: "stage", db: data));
  }
}
