import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_app/core/error/exception.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/data/models/game_model.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/data/models/stageData.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/action_entity.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/notification_entity.dart';
import 'package:meditation_app/domain/entities/request_entity.dart';
import 'package:meditation_app/domain/entities/stats_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:http/http.dart' as http;
import 'package:meditation_app/domain/entities/version_entity.dart';


import '../models/lesson_model.dart';

typedef CollectionReference CollectionGet(String path);

//This will use the flutter database.
abstract class UserRemoteDataSource {
  // sacamos el objeto referencia

  /// Logins a user to the DataBase
  ///
  /// Throws a [ServerException] for all error codes.
  Future<UserModel> loginUser({var usuario});

  UserRemoteDataSource();

  Future<UserModel> registerUser({var usuario});

  Future updateUser({UserModel user, DataBase data, dynamic toAdd, String type});

  //We get all the users data
  Future<DataBase> getData();

  //sacamos los datos del usuario que no guardamos en la bd
  Future <UserModel> getUserData(String coduser);

  Future getActions(UserModel u);

  Future updateImage(PickedFile image, User u);

  Future <List<Request>> getRequests();

  Future updateRequest(Request r, [Notify n]);

  Future updateNotification(Notify n);

  Future uploadRequest(Request r);

  Future <List<User>> getUsers(User u);

  Future <User> getUser(String cod);

  Future<Request> getRequest(String cod);

}

// QUITAR ESTO PARA EL FUTURO
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {

  var database;
  var nodejs ;

  UserRemoteDataSourceImpl() {
    HttpOverrides.global = new MyHttpOverrides();
    database = FirebaseFirestore.instance;
    nodejs = 'https://public.digitalvalue.es:8002';
  //  nodejs = 'http://192.168.4.67:8002';
  }

  Map<int, Map<String, List<LessonModel>>> alllessons;

  Future<UserModel> connect(String cod) async {
    try{
    var url = Uri.parse('$nodejs/connect/$cod');
    http.Response response = await http.get(url);

    if(response.statusCode == 400){
      return null;
    }else{
      //comprobar que funciona bien
      UserModel u = UserModel.fromRawJson(response.body);
      return u;
    }
    }catch(e) {
      print({'EXCEPtion', e.toString()});
    }
  }

  //sacamos todos los datos del usuario.
  //Meditaciones, lecciones y misiones. También sacamos las misiones de cada etapa
  @override
  Future<UserModel> loginUser({var usuario}) async {
      // Vamos a hacer esto en el server !!
    UserModel loggeduser = await connect(usuario.uid);
    if(loggeduser != null){
      getActions(loggeduser);
      //HAY QUE QUITAR ESTO UNA VEZ SE DESCONECTA
      /*
      Timer.periodic(new Duration(seconds: 30), (timer) {
        getActions(loggeduser);
      });*/   
      return loggeduser;
    }else{
      throw LoginException();
    }
  }

  @override
  Future<UserModel> registerUser({var usuario}) async {
    //Sacamos la primera etapa
    //Esto se debería de sacar del getStage
    var url = Uri.parse('$nodejs/stage/1');
    http.Response response = await http.get(url);

    if(response.statusCode != 400 && response.statusCode != 404){
      //comprobar que funciona bien
      //ESTO QUE ES !!!
      //UserModel u = UserModel.fromRawJson(response.body);
      StageModel one = StageModel.fromRawJson(response.body);

      //hay que pasar esto al nuevo setting con UserStats
      UserModel user = new UserModel(
          coduser: usuario.uid,
          user: usuario,
          stagenumber: 1,
          meditposition: 0,
          gameposition: 0,
          role: "meditator",
          classic: true,
          position: 0,
          stage: one,
          userStats: UserStats.empty()
        );


      //añadimos al usuario en la base de datos de usuarios
      await database.collection('users').add(user.toJson());

      return user;
    }else{
      throw ServerException();
    }
  }

  // se carga cada x tiempo las últimas acciones del usuario!
  Future getActions(UserModel u) async {
    var url = Uri.parse('$nodejs/live/${u.coduser}');
    try{
      var response = await http.get(url);
      var actions = json.decode(response.body);

      if(actions['today'] != null && actions['today'].length > u.todayactions.length){
        u.setActions(actions['today'], true);
      }

      if(actions['thisweek'] != null && actions['thisweek'].length > u.thisweekactions.length){
        u.setActions(actions['thisweek'], false);
      }
    }catch(e){
      print(e);
    }
  }

  @override
  Future<DataBase> getData([bool getStages]) async  {
    DataBase d = new DataBase();

    //HAGO ESTO DEMASIADO
    var url = Uri.parse('$nodejs/stages');
    print('getting data');
    try{
      http.Response response = await http.get(url);
      List<StageModel> stages = new List.empty(growable: true);

      var stagesquery = json.decode(response.body);

      for(var stage in stagesquery){
        d.stages.add(StageModel.fromJson(stage));      
      }

      QuerySnapshot nostageContent = await database.collection('content').where('stagenumber', isEqualTo: 'none').get();

      for(DocumentSnapshot doc in nostageContent.docs){
        var data = doc.data();
        if(data['type'] == 'meditation-practice'){
          d.nostagemeditations.add(MeditationModel.fromJson(data));
        }else{
          d.nostagelessons.add(LessonModel.fromJson(data));
        }
      }

      QuerySnapshot versions = await database.collection('versions').get();

      for(DocumentSnapshot doc in versions.docs){
        d.addVersion(Version.fromJson(doc.data()));
      }

      d.getLastVersion();

      return d;
    }catch(e){
      print({'exception',e.toString()});
    }

    throw Exception();
  }

  Future<List<User>> getUsers(User loggeduser) async{
    List<User> l = new List.empty(growable: true);
    try{
      var usersUrl = Uri.parse('$nodejs/users/${loggeduser.coduser}');
      http.Response response = await http.get(usersUrl);
      var users = json.decode(response.body);
      for(var user in users){
        l.add(UserModel.fromJson(user));
      }

      l.sort((a, b) => b.userStats.total.timemeditated.compareTo(a.userStats.total.timemeditated));

      return l;
    } catch(e){
      print({'exception',e.toString()});
    }

    throw Exception();
  }

  //DEBERIA DE LLAMARSE IMAGE
  Future<String> updateImage(PickedFile image, User u) async {
      String randomnumber = new Random().nextInt(100000).toString();

      Reference ref =  FirebaseStorage.instance.ref('/userdocs/${u.coduser}/$randomnumber');

      final UploadTask storageUpload = ref.putData(await image.readAsBytes());

      final urlString = await (await storageUpload.whenComplete(()=> null));
      String profilepath = await ref.getDownloadURL();

      return profilepath;
  }

  @override
  Future<List<Request>> getRequests() async {
    var url = Uri.parse('$nodejs/requests');
    http.Response response = await http.get(url);
    List<Request> requests = new List.empty(growable: true);

    //Comprobar que no haya error al llamar
    for(var j in json.decode(response.body)){
      requests.add(Request.fromJson(j));
    }

    return requests;
  }

  @override
  Future updateUser({UserModel user, DataBase data, dynamic toAdd, String type}) async {
    try{
      QuerySnapshot userreference = await database.collection('users').where('coduser', isEqualTo: user.coduser).get();
      String documentId = userreference.docs[0].id;
      
      await database.collection("users").doc(documentId).update(user.toJson());
  
      //Mejor hacer funciones ??????? MEDITAR, SEGUIR A ALGUIEN ,TOMAR UNA LECCION, MUCHO IF !!
      if (type == 'meditate') {
        await database.collection('meditations').add(toAdd[0].toJson());
      }else if(type =='lesson'){
        //Añadirlo a las lessonss del usuario !!
      }

      var url = Uri.parse('$nodejs/action/${user.coduser}');

      print(url);

      //esto se ejecutará antes que el clear ??
      //esto desde cuando se ejecuta ??
      user.lastactions.forEach((element) async{
        try{
        var body = json.encode(element.toJson());
        
        var response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: body
        );
        }catch(e){
          print(e);
        }
      });

      user.lastactions.clear();
    }catch(e){  
      print(e.toString());
      throw ServerException();
    }
  }

  /*
    TODO: SACAR LAS LECCIONES QUE HA LEIDO !!
  */
  @override
  Future <UserModel> getUserData(String coduser) async{
    try {
      UserModel u = await connect(coduser);

      if(u !=null){
        getActions(u);

        /*
        ESTO NO LO VAMOS A HACER ASI. CADA VEZ QUE ENTRE A MAINSCREEN SACAMOS ACTIONS
        Timer.periodic(new Duration(seconds: 30), (timer) {
          getActions(u);
        }); */   
      
        if(u == null){
          throw Exception();
        }else{
          return u;
        }
      }
    }catch(e){
      throw ServerException();
    }
  }

  Future <User> getUser(dynamic coduser)async{
    var url = Uri.parse('$nodejs/user/$coduser');
    http.Response response = await http.get(url);

    if(response.statusCode == 400){
      throw Exception();
    }else{
      //comprobar que funciona bien
      UserModel u = UserModel.fromRawJson(response.body);
      return u;
    }
  }


  //MIRAR DE COMO IMPLEMENTAR ESTO !!
  Future <User> quickUser(dynamic coduser) async {

    
  }


  Future updateRequest(Request r, [Notify n]) async{
    try{
      QuerySnapshot query = await database.collection('requests').where('cod', isEqualTo: r.cod).get();
      String docID = query.docs[0].id; 
      await database.collection("requests").doc(docID).update(r.toJson());
      if(n != null){
        await database.collection('notifications').add(n.toJson());
      }
    }catch(e) {
      throw ServerException();
    }
  }

  Future updateNotification(Notify n) async{
    try{
      QuerySnapshot query = await database.collection('notifications').where('cod', isEqualTo: n.cod).get();
      if(query.docs.length  > 0){ 
        String docID = query.docs[0].id;      
        await database.collection("notifications").doc(docID).update(n.toJson());
      }
    }catch(e) {
      throw ServerException();
    }
  }

  Future uploadRequest(Request r) async{
    await database.collection('requests').add(r.toJson());
  }

  @override
  Future<Request> getRequest(String cod) async{
    try{
      var url = Uri.parse('$nodejs/request/$cod');
      http.Response response = await http.get(url);
      Request request =  new Request.fromJson(json.decode(response.body));
      return request;
    }catch(e) {
      throw ServerException();
    }
  }
}
