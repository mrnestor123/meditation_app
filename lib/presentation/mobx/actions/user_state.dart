import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/core/usecases/usecase.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/usecases/meditation/take_meditation.dart';
import 'package:meditation_app/domain/usecases/user/get_data.dart';
import 'package:meditation_app/domain/usecases/user/isloggedin.dart';
import 'package:mobx/mobx.dart';
import 'package:observable/observable.dart';

part 'user_state.g.dart';

class UserState extends _UserState with _$UserState {
  UserState(
      {CachedUserUseCase cachedUseCase,
      MeditateUseCase meditate,
      GetDataUseCase data})
      : super(cachedUser: cachedUseCase, meditate: meditate, getdata: data);
}

abstract class _UserState with Store {
  CachedUserUseCase cachedUser;
  MeditateUseCase meditate;
  GetDataUseCase getdata;

  _UserState({this.cachedUser, this.meditate, this.getdata});

  @observable
  User user;

  @observable
  bool loggedin;

  @observable
  Either<Failure, User> _isUserCached;

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
    _isUserCached = await cachedUser.call(NoParams());

    _isUserCached.fold((Failure f) => loggedin = false, (User u) {
      user = u;
      loggedin = true;
    });
  }

  @action
  Future takeMeditation(Duration d) async {
    Either<Failure, bool> meditation =
        await meditate.call(Params(duration: d, user: user));

    meditation.fold((Failure f) => loggedin = false, (bool b) {
      print('The meditation has been a success');
    });
  }

  //We get all the necessary data for displaying the app from the database and the
  @action
  Future getData() async {

    final result = await  getdata.call(NoParams());

    result.fold((Failure f) => print(f.error), (Map m) {
      lessondata = m;
    });
  }


  @action 
  void changeBottomMenu(int stage){
    _menuindex= stage+1;
  }

}
