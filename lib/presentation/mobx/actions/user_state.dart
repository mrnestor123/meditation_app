import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/message.dart';
import 'package:meditation_app/domain/entities/request_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';

import 'package:meditation_app/presentation/pages/meditation_screen.dart';
import 'package:mindful_minutes/mindful_minutes.dart';
import 'package:mobx/mobx.dart';

import '../../../domain/entities/retreat_entity.dart';
import 'error_helper.dart';

part 'user_state.g.dart';

class UserState extends _UserState with _$UserState {
  UserState({UserRepository userRepository}): super(repository: userRepository);
}

abstract class _UserState with Store {
  UserRepository repository;
  bool perm;
  final _plugin = MindfulMinutesPlugin();

  _UserState({this.repository}){
    data = DataBase();
    if(Platform.isIOS){
    _plugin.checkPermission().then((hasPermission){
      if (!hasPermission) _plugin.requestPermission();
    });
    }
  }

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

  // PARA QUE NO SE ESPERE A SACAR LOS DATOS !!!!
  Future gettingData;


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
  Future<bool> takeLesson(Content l) async {
    user.progress = null;
    int currentposition = user.stagenumber;

    user.takeLesson(l, data);

    // SE HACE DOBLE !!
    if(l.isLesson()){
      DoneContent done = user.finishContent(l);

      if(done != null){
        repository.updateUser(user: user, done:done, type: 'content');
      }
    }

    
    //uploadActions(user, repository);
    repository.updateUser(user:user, type:'user');

    // SI HA SUBIDO DE ETAPA !!!! 
    // CHECKEAR EL UPLOADSTAGE !!!
    if (currentposition < user.stagenumber) {
      return true;
    } else {
      return false;
    }
  }

  //We get all the necessary data for displaying the app from the database and the
  @action
  Future getData() async {
    gettingData = repository.getData();
    foldResult(
      result: await gettingData,  
      onSuccess: (DataBase d) { data = d;}
    );
  }

  //!!COMPROBAR ERRORES ESTO SOBRA !!
  /*
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
  }*/


  Future getFeed() async {
    Either<Failure, List<Request>> query = await repository.getFeed();
    
    if(query.isRight()){
      List<Request> feed = new List.empty(growable: true);
      query.fold((l) => null, (r) => feed = r);
      return feed;
    }
  }
  
  @action
  Future changeName(String username) async {
    user.nombre = username;
    
    var fold = await repository.setUserName(username: username, coduser: user.coduser);

    if(fold.isRight()){
      return true;
    }else{

      foldResult(
        result: fold,
      );

      return false;
    }
  }

  @action 
  Future updateUser({User u})async{
    // NO COMPRUEBA ERRORES !!!
    return repository.updateUser(user: u != null ? u : user);
  }


  Future finishContent(Content c, Duration done, Duration total) async{
    //if(user.finishRecording(c, done, total)){
    DoneContent d = user.finishContent(c, done, total);

    if(d !=  null){
      repository.updateUser(user: user, done: d, type: 'content');
    }

   // uploadActions(user, repository);
  }

  //UTILIZAR UPLOADIMAGE EN ESTE!!
  @action 
  Future changeImage(String image) async {
    
    /// ESTO HABRA QUE DEVOLVER ERROR
    //String imgString = await uploadFile(image:image);

    user.setImage(image);

    foldResult(result: await repository.updateUser(user: user, type: 'user'));

  }

  @action 
  Future<String> uploadFile({dynamic image, FilePickerResult audio, XFile video}) async{
    Either<Failure,String> fileupload = await repository.uploadFile(image:image,audio:audio,video: video, u:user);

    String imgstring;

    foldResult(
      result: fileupload,
      onSuccess: (r){
        //user.files.add(File.fromUri(Uri.file(r)));
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

    loggedresult.fold((l) => null, (r) => user =  r);
    
    if(loggedresult.isRight()){

      gettingData = repository.getData();

      Either<Failure,dynamic> result = await gettingData;
  
      if(result.isLeft()){
        Failure f;
        
        result.fold((l) => f = l, (r) => null);
        
        if(f is ServerFailure){
          errorMessage =  'ERROR';
        }
      }
      
      foldResult(
        result: await gettingData,
        onSuccess: (DataBase d) { data = d;}
      );
    }


   // var dataresult = futures[0];

    /*
    if(dataresult.isLeft()){
      // SI NO HAY CONEXIÓN CON LA BASE DE DATOS
      // SE CARGA LA BASE DE DATOS LOCAL
      foldResult(
        result: dataresult,
        onSuccess: (r){
          data = r;
        }
      );


      print('WE DIDNT GET DATA');

    }else{
      dataresult.fold((l) => null, (r) => data = r);
    }


    await Future.delayed(Duration(seconds: 2));
    */

    return;
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


  // PASAR A MESSAGES_STATE
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


  Future <User> getUser({String cod})async{

    Either<Failure,User> res = await repository.getUser(cod);
    User user;

    foldResult(
      result: res,
      onSuccess: (r){
        user = r;
        return r;
      }
    );

    return user;
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



  // uploadActions(user, repository);
  // HAY QUE HACER UN FOLD CON ESTO !!!
  @action
  Future finishMeditation({Meditation m, bool earlyFinish = false}) async {
    user.settings.lastMeditDuration = m.duration.inMinutes;

    if(!user.offline){
      user.takeMeditation(m, data);
      repository.updateUser(user: user,d:data, toAdd: [m],type: 'meditate');
    }else {
      user.takeMeditation(m, data, true);
      repository.cacheMeditation(m:m,u:user);
    }

    AssetsAudioPlayer assetsAudioPlayer = new AssetsAudioPlayer();
    
    assetsAudioPlayer.open(
      Audio(bells.firstWhere((element) => element.name  == user.settings.meditation.endingBell).sound)
    );

    // HACER ESTO PARA ANDROID TAMBIÉN !!
    // IMPORTANTE !!!!!!!!
    if(Platform.isIOS){
      _plugin.writeMindfulMinutes(DateTime.now().subtract(m.duration), DateTime.now());
    }
  }

  @action 
  Future closeStageUpdate(){
    user.stageupdated = false;
  }

  @action
  Future createRetreat({Retreat r}){
    user.retreats.add(r);
   // repository.createRetreat(r:r);
    
    return repository.updateUser(user: user, toAdd: [r],type: 'retreat');
  }

  void addReport({String str, MeditationReport report}) async{
    Meditation m = user.totalMeditations.last;
    m.report = report;

    foldResult(
      result: await repository.addMeditationReport(m: m, report: report,  user:user)
    );
  }

  Future sendQuestion(String text){
    return repository.sendQuestion(coduser: user.coduser, question: text);
  }

}