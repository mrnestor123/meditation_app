import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/message.dart';
import 'package:meditation_app/domain/entities/notification_entity.dart';
import 'package:meditation_app/domain/entities/request_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';
import 'package:mobx/mobx.dart';

part 'user_state.g.dart';

class UserState extends _UserState with _$UserState {
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

  _UserState({this.repository});

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
  List<User> users =  new List.empty(growable: true);

  @observable 
  List<User> filteredusers = new List.empty(growable: true);

  @observable 
  bool loading = false;

  //USERS THAT GET EXTRACTED FROM Method getUSersList
  @observable 
  List<User> dynamicusers  = new List.empty(growable: true);

  @observable 
  List<User> teachers = new List.empty(growable: true);

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
  Future getTeachers() async {
    loading = true;
    Either<Failure,List<User>> userlist = await repository.getTeachers();

    userlist.fold(
      (l) => _mapFailureToMessage(l), 
      (r) {
        loading = false;
        teachers = r;
      }
    );
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
      dynamicusers.add(u);
    } else {
      user.unfollow(u);
      dynamicusers.remove(u);
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

  @action 
  Future updateUser({User u})async{
    return repository.updateUser(user: u != null ? u : user);
  }

  //UTILIZAR UPLOADIMAGE EN ESTE!!
  @action 
  Future changeImage(dynamic image) async {
    Either<Failure,String> imageupload = await repository.uploadFile(image:image, u: user);
    //PASAR TODOS LOS  FOLD AL FINAL !!!
    imageupload.fold((l) => errorMessage = 'error al subir imagen', (r) => user.image = r);

    return repository.updateUser(user: user);
  }

  @action 
  Future<String> uploadFile({dynamic image, FilePickerResult audio, XFile video}) async{

    Either<Failure,String> imageupload = await repository.uploadFile(image:image,audio:audio,video: video, u:user);
   
    //PASAR TODOS LOS FOLD AL FINAL !!!
    String imgstring;
    imageupload.fold(
      (l) => errorMessage = 'error al subir imagen', 
      (r) => imgstring = r
    );

    return imgstring;
  }

  @action
  // PARA SUBIR UNA ETAPA
  Future updateStage() async {
    //updateamos la stage
    user.updateStage(data);
    return repository.updateUser(user: user);
  }


  Future getUsers() async {
    loading = true;
    Either<Failure,List<User>> userlist = await repository.getUsers(user);

    userlist.fold(
      (l) => _mapFailureToMessage(l), 
      (r) {
        users = r;
        filteredusers = users;
      }
    );
  }


  Future sendMessage(User to, String type, [String text]) async {
      Message m = user.sendMessage(to,type, text);
      Either<Failure,void> userlist = await repository.sendMessage(sender:user,receiver:to,message: m);
      
      userlist.fold(
      (l) => _mapFailureToMessage(l), 
      (r) {
  
      }
    );
  }


  void changeRequest(Message m, bool confirm){
    user.changeRequest(m,confirm);
    var messages ={
      'accept': 'Has accepted your request to join his courses',
      'deny': 'Has denied your request to join his courses'
    };
    //user.sendMessage(to, 'text', confirm ? messages['accept']: messages['deny']);
    // ESTO NO DEBERÍA SER ASI !!!!!
    repository.updateUser(user: m.user);
    repository.updateUser(user: user);

  }

  Future deleteMessage(Message m){
    user.messages.remove(m);

  }



  Future uploadContent({Content c, FilePickerResult audio, XFile video}) async{
    user.uploadContent(c);
    
    Either <Failure,String> upload = await repository.uploadFile(audio:audio, video:video, u: user);

    upload.fold(
      (l) => errorMessage = 'error al subir imagen', 
      (r) => {
        print('imagen subida perfectamente')
      });
  }



  void seeMessages(){
    if(user.messages.where((element) => !element.read).length>0){
      for(Message m in user.messages){
        m.read = true;
      }
    }
  }



  //FROM LIST OF USER CODS WE GET THE USERS
  Future <List<User>> getUsersList(List<dynamic> cods)async{
    loading = true;
    List<User> l = new List.empty(growable: true);

    for(var cod in cods){
      Either<Failure,User> u  = await repository.getUser(cod);
      u.fold((l) => _mapFailureToMessage(l), (u) => l.add(u));
    }

    dynamicusers = l;
    loading = false;

    return l;
  }

  Future setVersion(int versionNumber){
    user.setVersion(versionNumber);

    return repository.updateUser(user:user);
  }

}
