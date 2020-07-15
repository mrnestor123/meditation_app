import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/usecases/usecase.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/usecases/meditation/take_meditation.dart';
import 'package:meditation_app/domain/usecases/user/isloggedin.dart';
import 'package:mobx/mobx.dart';
import 'package:observable/observable.dart';

part 'user_state.g.dart';

class UserState extends _UserState with _$UserState {
  UserState({CachedUserUseCase cachedUseCase, MeditateUseCase meditate})
      : super(cachedUser: cachedUseCase, meditate: meditate);
}

abstract class _UserState with Store {
  CachedUserUseCase cachedUser;
  MeditateUseCase meditate;

  _UserState({this.cachedUser, this.meditate});

  @observable
  User user;

  @observable
  bool loggedin;

  @observable
  Either<Failure, User> _isUserCached;

  Either<Failure, Meditation> meditation;

  @action
  void setUser(var u) {
    user = u;
  }

  @action
  Future userisLogged() async {
    _isUserCached = await cachedUser.call(NoParams());

    _isUserCached.fold((Failure f) => loggedin = false, (User u) {
      user = u;
      loggedin = true;
    });
  }

  @action
  Future takeMeditation(Duration d) async {
    meditation = await meditate.call(Params(duration: d, user: user));

    meditation.fold((Failure f) => loggedin = false, (Meditation m) {
      print('The meditation has been a success');
    });
  }
}
