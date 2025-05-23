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

import 'package:meditation_app/presentation/pages/mainpages/meditation_screen.dart';
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



  // ESTO PODRÍA SER TODO UNA MISMA LISTA!!
  List<User> thisWeekMeditators = new List.empty(growable: true);
  List<User> thisMonthMeditators = new List.empty(growable: true);
  List<User> streakMeditators = new List.empty(growable: true);

  bool isOffline = false;

 

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
    int currentposition = user.stagenumber;
    user.takeLesson(l, data);

    // SE HACE DOBLE !!
    // esto se hace  en otro sitio con las recordings y los videos !!
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
  Future connect() async {
    var loggedresult = await repository.islogged();

    loggedresult.fold(
      (l) {
        if(l is ConnectionFailure){
          isOffline = true;
        } 
      },
      (r) => user =  r
    );
    
    if(loggedresult.isRight() ){
      gettingData = repository.getData();
  
      /*if(result.isLeft()){
        Failure f;
        
        result.fold((l) => f = l, (r) => null);
        
        if(f is ServerFailure){
          errorMessage =  'ERROR';
        }
      }*/
      
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
        filteredusers = r.where((User u)=>
          u.settings.hideInLeaderboard == false  
        ).toList();

        users = filteredusers;

        /*
        thisWeekMeditators = users.where((element) =>  
          element.userStats.meditatedThisWeek >  0 
        ).toList();*/

        DateTime now = DateTime.now();
        DateTime thismonth = DateTime(now.year, now.month, 0);
        DateTime thisweek = now.subtract(Duration(days: now.weekday - 1));


        thisMonthMeditators = users.where((element) =>  
          element.userStats.meditatedThisMonth >  0 
          && element.userStats.lastmeditated != null  
          && element.userStats.lastmeditated.isAfter(
            thismonth
          ) 
        ).toList();

        streakMeditators  = users.where((element) =>  
          element.userStats.streak >  0 
        ).toList();

        //thisWeekMeditators.sort((a,b) => b.userStats.meditatedThisWeek.compareTo(a.userStats.meditatedThisWeek));
        thisMonthMeditators.sort((a,b) => b.userStats.meditatedThisMonth.compareTo(a.userStats.meditatedThisMonth));
        streakMeditators.sort((a,b) => b.userStats.maxStreak.compareTo(a.userStats.maxStreak));
        users.sort((a, b) => b.userStats.timeMeditated.compareTo(a.userStats.timeMeditated));
      }
    );  
    
    loading = false;
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

    if(user != null && !user.offline && !isOffline){
      user.takeMeditation(m, data, earlyFinish);
      repository.updateUser(user: user,d:data, toAdd: [m],type: 'meditate');
    }else {
      user.takeMeditation(m, data, true, earlyFinish, );
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


  Future sendMessage({User to,  String text}){
    Message m = Message(
      sender: user.email,
      receiver: to.email,
      body: text,
      date: DateTime.now()
    );

    return repository.sendMessage(message: m);
  }


  /*
  @action
  Future createRetreat({Retreat r}){
    user.retreats.add(r);
   // repository.createRetreat(r:r);
    
    return repository.updateUser(user: user, toAdd: [r],type: 'retreat');
  }*/


  void addReport({String str, MeditationReport report}) async{
    Meditation m = user.totalMeditations.last;
    m.report = report;

    foldResult(
      result: await repository.addMeditationReport(m: m, report: report,  user:user)
    );
  }

  void deleteUser()async {

    foldResult(
      result: await repository.deleteUser(user: user)
    );
  }

  Future sendQuestion(String text){
    return repository.sendQuestion(coduser: user.coduser, question: text);
  }

}