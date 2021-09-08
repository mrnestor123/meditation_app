import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
import 'package:meditation_app/domain/entities/request_entity.dart';
import 'package:meditation_app/domain/entities/stats_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:http/http.dart' as http;


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

  Future updateRequest(Request r);

  Future uploadRequest(Request r);

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
    //nodejs = 'http://192.168.4.67:8802';
  }

  Map<int, Map<String, List<LessonModel>>> alllessons;

  Future<UserModel> connect(String cod) async {
    var url = Uri.parse('$nodejs/connect/$cod');
    http.Response response = await http.get(url);

    if(response.statusCode == 400){
      return null;
    }else{
    //comprobar que funciona bien
      UserModel u = UserModel.fromRawJson(response.body);
      return u;
    }
  }

  //se ejecuta cuando nos conectamos siempre!
  addfollowers(User loggeduser) async {    
    //si sigue a alguien sacamos los que sigue y los que no sigue
    if(loggeduser.followedcods.length > 0 ){
      QuerySnapshot notfollowed = await database.collection('users').where('coduser', whereNotIn: loggeduser.followedcods).get();

      loggeduser.followedcods.forEach((element) async { 
        QuerySnapshot userquery = await database.collection('users').where('coduser', isEqualTo: element).get();
        UserModel user = UserModel.fromJson(userquery.docs[0].data());  
        //Sacamos las meditaciones del usuario al que sigue
        /// NO ESTOY SEGURO DE HACER ESTO !!!! 
        QuerySnapshot meditations = await database.collection('meditations').where('coduser', isEqualTo: user.coduser).get();    
        if (meditations.docs.length > 0) {
          for (DocumentSnapshot doc in meditations.docs) {
            user.addMeditation(new MeditationModel.fromJson(doc.data()));
          }
        }
        loggeduser.addfollow(user);
      });

      if(notfollowed.docs.length > 0){
        for(DocumentSnapshot doc in notfollowed.docs){
          loggeduser.addUnfollower(UserModel.fromJson(doc.data()));
        }
      }    
    } else {
      QuerySnapshot allusers = await database.collection('users').where('coduser', isNotEqualTo: loggeduser.coduser).get();

       if(allusers.docs.length > 0){
        for(DocumentSnapshot doc in allusers.docs){
          UserModel user = UserModel.fromJson(doc.data());  
          QuerySnapshot meditations = await database.collection('meditations').where('coduser', isEqualTo: user.coduser).get();    
          if (meditations.docs.length > 0) {
            for (DocumentSnapshot doc in meditations.docs) {
              user.addMeditation(new MeditationModel.fromJson(doc.data()));
            }
          }
          loggeduser.addUnfollower(user);
        }
      }  
    }

    QuerySnapshot followsyou = await database.collection('users').where('following',arrayContains: loggeduser.coduser).get();

    if(followsyou.docs.length > 0){
      for(DocumentSnapshot doc in followsyou.docs){
        UserModel user = UserModel.fromJson(doc.data());
        loggeduser.addFollower(user);
      }
    }

    loggeduser.sortFollowers();
  }

  //sacamos todos los datos del usuario.
  //Meditaciones, lecciones y misiones. También sacamos las misiones de cada etapa
  @override
  Future<UserModel> loginUser({var usuario}) async {
      // Vamos a hacer esto en el server !!
    UserModel loggeduser = await connect(usuario.uid);
    if(loggeduser != null){
      getActions(loggeduser);
      Timer.periodic(new Duration(seconds: 30), (timer) {
        getActions(loggeduser);
      });   
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

    if(response.statusCode != 400){
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
    var response = await http.get(url);
    try{
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
  //SACA LOS USUARIOS QUE HAY AHORA !! HACE FALTA ?? // SE UTILIZA ??? // DEBERÍA QUITARSE !!
  Future<DataBase> getData() async  {
    DataBase d = new DataBase();
    var url = Uri.parse('$nodejs/stages');
    http.Response response = await http.get(url);
    List<StageModel>  stages = new List.empty(growable: true);

    var stagesquery = json.decode(response.body);

    for(var stage in stagesquery){
      d.stages.add(StageModel.fromJson(stage));      
    }

    //Pasar esto al server de node !!
    QuerySnapshot users = await database.collection('users').get();

    for (var user in users.docs) {
      d.users.add(new UserModel.fromJson(user.data()));
    }

//    d.stages.sort((a, b) => a.stagenumber.compareTo(b.stagenumber));
    d.users.sort((a, b) => b.userStats.total.timemeditated.compareTo(a.userStats.total.timemeditated));

    return d;
  }

  Future<String> updateImage(PickedFile image, User u) async {
      Reference ref =  FirebaseStorage.instance.ref('/userdocs/${u.coduser}');

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
        var body = json.encode(element.toJson());

        var response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: body
        );
      });

      user.lastactions.clear();
    }catch(e){  
      print(e);
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

        Timer.periodic(new Duration(seconds: 30), (timer) {
          getActions(u);
        });    
      
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

  Future updateRequest(Request r) async{
    QuerySnapshot query = await database.collection('requests').where('cod', isEqualTo: r.cod).get();
    String docID = query.docs[0].id; 
    try{
      await database.collection("requests").doc(docID).update(r.toJson());
    }catch(e) {
      throw ServerException();
    }
  }

  Future uploadRequest(Request r) async{
    await database.collection('requests').add(r.toJson());
  }

}
