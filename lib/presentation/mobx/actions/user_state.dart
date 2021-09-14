import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/request_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';
import 'package:mobx/mobx.dart';

part 'user_state.g.dart';

class   UserState extends _UserState with _$UserState {
  UserState(
      {
      UserRepository userRepository
      })
      : super(
        repository: userRepository
      );
}

abstract class _UserState with Store {
  UserRepository repository;

  _UserState(
      {this.repository,
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
  String errorMessage;

  @observable 
  List<Request> requests;

  @observable 
  List<User> users;

  @observable
  Map lessondata;

  @action
  void setUser(var u) {
    if(u != null){
      user = u;
    }
  }

   void _mapFailureToMessage(Failure failure) {
    // Instead of a regular 'if (failure is ServerFailure)...'
    switch (failure.runtimeType) {
      case ServerFailure:
        errorMessage='Server failure';
        break;
      case CacheFailure:
        errorMessage = 'Cache failure';
        break;
      case LoginFailure: 
        errorMessage = failure.error != null ? failure.error : 'User not found in the database';
        break;
      default:
        errorMessage = 'Unexpected Error';
        break;
    }
  }


  @action
  Future userisLogged() async {
    Either<Failure, User> _isUserCached = await repository.islogged();
    _isUserCached.fold((Failure f) => loggedin = false, 
    (User u) {
      user = u;
      loggedin = true;
    });
  }

  @action
  Future<bool> takeLesson(LessonModel l) async {
    user.progress = null;
    int currentposition = user.stagenumber;
    user.takeLesson(l, data);
    repository.updateUser(user: user,  type: 'lesson');

    // SI HA SUBIDO DE ETAPA !!!! 
    //CHECKEAR EL UPLOADSTAGE !!!
    if (currentposition < user.stagenumber) {
      return true;
    } else {
      return false;
    }
  }

  //We get all the necessary data for displaying the app from the database and the
  @action
  Future getData() async {
    final result = await repository.getData();

    result.fold(
    (Failure f)  {
       _mapFailureToMessage(f); 
    },
    (DataBase d) {
      data = d;
    });
  }

  //!!COMPROBAR ERRORES
  @action
  Future follow(User u, bool follow) async {
     if (follow) {
      user.follow(u);
    } else {
      user.unfollow(u);
    } 

    // Updateamos también los datos del usuario val que se sigue
    repository.updateUser(user: u);
    repository.updateUser(user:user);
  }

  
  @action
  Future changeName(String username) async {
    user.nombre = username;
    return repository.updateUser(user: user);
  }

  //UTILIZAR UPLOADIMAGE EN ESTE!!
  @action 
  Future changeImage(dynamic image) async {
    Either<Failure,String> imageupload = await repository.updateImage(image, user);
    //PASAR TODOS LOS  FOLD AL FINAL !!!
    imageupload.fold((l) => errorMessage = 'error al subir imagen', (r) => user.image = r);

    return repository.updateUser(user: user);
  }

  @action 
  Future<String> uploadImage(dynamic image) async{
    Either<Failure,String> imageupload = await repository.updateImage(image,user);
    //PASAR TODOS LOS  FOLD AL FINAL !!!
    String imgstring;
    imageupload.fold(
      (l) => errorMessage = 'error al subir imagen', 
      (r) => imgstring = r
    );
    return imgstring;
  }

  @action
  Future updateStage() async {
      //updateamos la stage
    user.updateStage(data);
    return repository.updateUser(user: user);
  }


  @action 
  Future getRequests() async{
    Either<Failure, List<Request>> res = await repository.getRequests();
    requests = new List.empty(growable: true);

    res.fold(
    (Failure f) {
      _mapFailureToMessage(f);  
    },
    (List<Request> d) {
      requests = d;
    });
  }

  Future updateRequest(Request r, bool like, [String comment]) async{
    if(like != null){
      if(like){
        r.like(user.coduser);
      }else{
        r.dislike(user.coduser);
      }
    }else if(comment != null){
      Comment c = new Comment(comment: comment,username: user.nombre, coduser: user.coduser);
      r.comment(c);
    }

    Either<Failure, void> res = await repository.updateRequest(r);
    res.fold((f) => _mapFailureToMessage(f), (r) => print('bien'));
  }

  Future uploadRequest(Request r) async{
    r.coduser = user.coduser;
    r.username = user.nombre;
    Either<Failure,void> res = await repository.uploadRequest(r);
    res.fold((f) => _mapFailureToMessage(f), (r) => print('bien'));
  }


  Future getUsers() async {
    Either<Failure,List<User>> userlist = await repository.getUsers(user);

    userlist.fold(
      (l) => _mapFailureToMessage(l), 
      (r) => users = r
    );
  }

  //FROM LIST OF USER CODS WE GET THE USERS
  Future <List<User>> getUsersList(List<dynamic> cods)async{
    List<User> l = new List.empty(growable: true);

    for(var cod in cods){
      Either<Failure,User>u  = await repository.getUser(cod);
      u.fold((l) => _mapFailureToMessage(l), (u) => l.add(u));
    }

    return l;

  }

}
