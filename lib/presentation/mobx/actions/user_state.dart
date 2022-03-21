import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/lesson_entity.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/message.dart';
import 'package:meditation_app/domain/entities/notification_entity.dart';
import 'package:meditation_app/domain/entities/request_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';
import 'package:meditation_app/presentation/pages/commonWidget/error_dialog.dart';
import 'package:mobx/mobx.dart';

import 'error_helper.dart';

part 'user_state.g.dart';

class UserState extends _UserState with _$UserState {
  UserState({UserRepository userRepository}): super(repository: userRepository);
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
  bool loggedin  = false;

  @observable
  String errorMessage;

  bool hasFailed = true;

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

  // CREO QUE ESTO YA NO SE UTILIZA 
  // HABRÁ QUE BORRAR ESTO !!!!
  @action 
  Future getTeachers() async {
    loading = true;
    Either<Failure,List<User>> userlist = await repository.getTeachers();
    foldResult(
      result: userlist,
      onSuccess: (r){
        teachers = r;
        loading =false;
      }
    );
  }

  @action
  Future userisLogged() async {
    Either<Failure, User> _isUserCached = await repository.islogged();
    _isUserCached.fold((Failure f) => loggedin = false, 
    (User u) {
      user = u;
      // loggedin hace falta ???
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
    foldResult(
      result: await repository.getData(),  
      onSuccess: (DataBase d) { data = d;}
    );
  }

  //!!COMPROBAR ERRORES
  @action
  Future follow(User u, bool follow) async {
     if (follow) {
      user.follow(u);
    } else {
      user.unfollow(u);
    } 

    repository.follow(u: user, followed:u, follows: follow);

    // Updateamos también los datos del usuario val que se sigue
   // repository.updateUser(user: u);
   // repository.updateUser(user:user);
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
    
    String imgString = await uploadFile(image:image);
   
    user.setImage(imgString);

    return repository.updateUser(user: user);
  }

  @action 
  Future<String> uploadFile({dynamic image, FilePickerResult audio, XFile video}) async{
    Either<Failure,String> fileupload = await repository.uploadFile(image:image,audio:audio,video: video, u:user);

    String imgstring;

    foldResult(
      result: fileupload,
      onSuccess: (r){
        user.files.add(File.fromUri(Uri.file(r)));
        imgstring = r;
      }
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


  @action 
  Future connect() async {
    var loggedresult = await repository.islogged();
    loggedresult.fold((l) => hasFailed = false, (r) { user = r; loggedin = true;});
    
    if(user != null){
      var dataresult = await repository.getData();

      foldResult(
        result: dataresult, 
        onSuccess: (DataBase d) {
          data = d;
          getUsers();
          hasFailed= false;
        }
      );
    }else{
      hasFailed= false;
    }
  }


  // ESTO SE PUEDE QUITAR???
  Future getUsers() async {
    loading = true;
    Either<Failure,List<User>> userlist = await repository.getUsers(user);

    foldResult(
      result:userlist,
      onSuccess: (r){
        users = r;
        filteredusers = r;
      }
    );  
    
    loading = false;
  }


  Future sendMessage(User to, String type, [String text]) async {
    Message m = user.sendMessage(to,type, text);
    to.messages.add(m);
    Either<Failure,void> userlist = await repository.sendMessage(message: m);

    foldResult(
      result: userlist,
    );
  }


  // ESTO ES PARA ACEPTAR STUDIANTES
  void acceptStudent(Message m, bool confirm){
    Message reply = user.acceptStudent(m,confirm);
    var messages ={
      'accept': 'Has accepted your request to join his courses',
      'deny': 'Has denied your request to join his courses'
    };

    repository.sendMessage(message: reply);
    repository.updateMessage(message: m);
    repository.updateUser(user: user);

    //user.sendMessage(to, 'text', confirm ? messages['accept']: messages['deny']);
    // ESTO NO DEBERÍA SER ASI !!!!!
    /*
    if(m.user != null){
      repository.updateUser(user: m.user);
    }*/

  }

  Future deleteMessage(Message m){
    m.deleted = true;
    user.messages.remove(m);
    repository.updateMessage(message: m);
  }

  Future uploadContent({Content c}) async{
    c.createdBy = user;
    
    user.uploadContent(c:c);
    Either<Failure,void> upload = await repository.uploadContent(c:c);

    foldResult(
      result: upload
    );
  }


  void seeMessages(){
    List<Message> messagestoUpdate = new List.empty();

    if(user.messages.where((element) => !element.read).length>0){
      for(Message m in user.messages){
        if(!m.read){
          repository.updateMessage(message: m);
          m.read = true;
        }
      }
    }
  }

  Future <List<User>> getFollowers(){

  }

  //FROM LIST OF USER CODS WE GET THE USERS
  // ESTO LO HACEMOS EN EL SERVER !!!
  Future <List<User>> getUsersList(List<dynamic> cods)async{
    loading = true;
    List<User> l = new List.empty(growable: true);

    // PASAR ESTO A LA BASE DE DATOS !!!!!!!
    for(var cod in cods){
      Either<Failure,User> u  = await repository.getUser(cod);
      u.fold((l) => null, (u) => l.add(u));
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