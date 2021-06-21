import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/usecases/usecase.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/mission.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/usecases/lesson/take_lesson.dart';
import 'package:meditation_app/domain/usecases/meditation/take_meditation.dart';
import 'package:meditation_app/domain/usecases/user/change_data.dart';
import 'package:meditation_app/domain/usecases/user/get_data.dart';
import 'package:meditation_app/domain/usecases/user/isloggedin.dart';
import 'package:meditation_app/domain/usecases/user/log_out.dart';
import 'package:meditation_app/domain/usecases/user/update_image.dart';
import 'package:meditation_app/domain/usecases/user/update_stage.dart';
import 'package:meditation_app/domain/usecases/user/follow_user.dart';
import 'package:mobx/mobx.dart';

part 'user_state.g.dart';

class UserState extends _UserState with _$UserState {
  UserState(
      {CachedUserUseCase cachedUseCase,
      MeditateUseCase meditate,
      LogOutUseCase logout,
      GetDataUseCase data,
      TakeLessonUseCase lesson,
      FollowUseCase updateUserUseCase,
      UpdateImageUseCase updateImageUseCase,
      UpdateStageUseCase updateStageUseCase,
      ChangeDataUseCase changeDataUseCase
      })
      : super(
            cachedUser: cachedUseCase,
            meditate: meditate,
            getdata: data,
            logoutusecase: logout,
            lesson: lesson,
            followUseCase: updateUserUseCase,
            updateStageUseCase: updateStageUseCase,
            imageUseCase: updateImageUseCase,
            changeDataUseCase: changeDataUseCase
            );
}

abstract class _UserState with Store {
  CachedUserUseCase cachedUser;
  MeditateUseCase meditate;
  GetDataUseCase getdata;
  TakeLessonUseCase lesson;
  LogOutUseCase logoutusecase;
  FollowUseCase followUseCase;
  UpdateImageUseCase imageUseCase;
  UpdateStageUseCase updateStageUseCase;
  ChangeDataUseCase changeDataUseCase;


  _UserState(
      {this.cachedUser,
      this.meditate,
      this.getdata,
      this.logoutusecase,
      this.lesson,
      this.followUseCase,
      this.imageUseCase,
      this.updateStageUseCase, 
      this.changeDataUseCase
      });

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

  @action
  Future<bool> takeLesson(LessonModel l) async {
    user.progress = null;

    int currentposition = user.stagenumber;
    await lesson.call(LessonParams(lesson: l, user: user, d: data));

    // SI HA SUBIDO DE ETAPA !!!! 
    if (currentposition < user.stagenumber) {
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

  //todos los del updateuserusecase se podrían juntar !!!!!!!!!
  @action
  Future follow(User u, bool follow) async {
    final following = followUseCase.call(UParams(user: user, followeduser: u, type: follow ? 'follow' : 'unfollow'));
  }

  @action
  Future logout() async {
    user = null;
    loggedin = false;
    await logoutusecase.call(NoParams());
  }

  @action
  Future changeName(String username) async {
    Either<Failure, User> _addedname = await changeDataUseCase.call(UParams(user: user, nombre: username, type: "name"));
    return true;
  }

  //DE AQUI HAY QUE QUITAR EL CHANGE IMAGE
  @action
  Future updateUser(dynamic variable, String type) async {
    Either<Failure, User> _addedname = await followUseCase.call(UParams(user: user, type: type, image: variable));
  }

  @action
  Future updateStage() async {
    Either<Failure, User> _addedname = await updateStageUseCase.call(UParams(user: user,db: data));
  }
}
