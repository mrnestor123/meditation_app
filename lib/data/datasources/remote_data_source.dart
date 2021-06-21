import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_app/core/error/exception.dart';
import 'package:meditation_app/data/models/game_model.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/data/models/stageData.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/action_entity.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/stats_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';


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

  Future updateImage(PickedFile image, User u);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {

  var database;

  UserRemoteDataSourceImpl() {
    database = FirebaseFirestore.instance;
  }

  Map<int, Map<String, List<LessonModel>>> alllessons;

  addfollowers(User loggeduser) async{

    //si sigue a alguien sacamos los que sigue y los que no sigue
    if(loggeduser.followedcods.length > 0 ){
      QuerySnapshot notfollowed = await database.collection('users').where('coduser', whereNotIn: loggeduser.followedcods).get();

      loggeduser.followedcods.forEach((element) async { 
        QuerySnapshot userquery = await database.collection('users').where('coduser', isEqualTo: element).get();
        UserModel user = UserModel.fromJson(userquery.docs[0].data());  
        loggeduser.addfollow(user);
      });

      if(notfollowed.docs.length > 0){
        for(DocumentSnapshot doc in notfollowed.docs){
          loggeduser.addUnfollower(UserModel.fromJson(doc.data()));
        }
      }    
    }else{
      QuerySnapshot allusers = await database.collection('users').where('coduser', isNotEqualTo: loggeduser.coduser).get();

       if(allusers.docs.length > 0){
        for(DocumentSnapshot doc in allusers.docs){
          if(doc.data()['cod'])
          loggeduser.addUnfollower(UserModel.fromJson(doc.data()));
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
    QuerySnapshot user = await database.collection('users').where('coduser', isEqualTo: usuario.uid).get();

    UserModel loggeduser;

    if (user.docs.length > 0) {
      loggeduser = new UserModel.fromJson(user.docs[0].data());

      await addfollowers(loggeduser);

      QuerySnapshot stage = await database.collection('stages').where('stagenumber', isEqualTo: loggeduser.stagenumber).get();

      StageModel s = await populateStage(stage.docs[0].data());

      loggeduser.setStage(s);

      QuerySnapshot meditations = await database.collection('meditations').where('coduser', isEqualTo: loggeduser.coduser).get();

      if (meditations.docs.length > 0) {
        for (DocumentSnapshot doc in meditations.docs) {
          loggeduser.addMeditation(new MeditationModel.fromJson(doc.data()));
        }
      }

      return loggeduser;
    } else {
      throw LoginException();
    }
  }

  @override
  Future<UserModel> registerUser({var usuario}) async {
    //Sacamos la primera etapa
    QuerySnapshot firststage = await database.collection('stages').where('stagenumber', isEqualTo: 1).get();
    StageModel one;

    for (DocumentSnapshot doc in firststage.docs) {
      one = new StageModel.fromJson(doc.data());
    }

    //hay que pasar esto al nuevo setting con UserStats
    UserModel user = new UserModel(
        coduser: usuario.uid,
        user: usuario,
        stagenumber: 1,
        role: "meditator",
        position: 0,
        stage: one,
        userStats: UserStats.empty()
      );

    //añadimos al usuario en la base de datos de usuarios
    await database.collection('users').add(user.toJson());

    return user;
  }


  Future<StageModel> populateStage(json) async {
    StageModel s = new StageModel.fromJson(json);
    QuerySnapshot lessons = await database.collection('content').where('stagenumber', isEqualTo: s.stagenumber).get();

    for (var content in lessons.docs) {
      if (content.data()['position'] != null || content.data()['type'] == 'meditation-game') {
        content.data()['type'] == 'meditation-practice' ?
          s.addContent(MeditationModel.fromJson(content.data())):
        content.data()['type'] == 'meditation-game' ?
          s.addContent(GameModel.fromJson(content.data())):
          s.addContent(LessonModel.fromJson(content.data()));
      }
    }

    return s;
  }


  @override
  //SACA LOS USUARIOS QUE HAY AHORA !! HACE FALTA ??
  Future<DataBase> getData() async  {
    DataBase d = new DataBase();
    QuerySnapshot stages = await database.collection('stages').get();
    QuerySnapshot users = await database.collection('users').get();

    for (var stage in stages.docs) {
      StageModel s = await populateStage(stage.data());
      d.stages.add(s);
    }

    for (var user in users.docs) {
      d.users.add(new UserModel.fromJson(user.data()));
    }

    d.stages.sort((a, b) => a.stagenumber.compareTo(b.stagenumber));
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
  Future updateUser({UserModel user, DataBase data, dynamic toAdd, String type}) async {
    QuerySnapshot userreference = await database.collection('users').where('coduser', isEqualTo: user.coduser).get();
    String documentId = userreference.docs[0].id;
    await database.collection("users").doc(documentId).update(user.toJson());

    //actualizamos la base de datos. habrá que mirarlo esto !!!!!!!!!. ESTO NO LO HARÍA ASÍ . HABRÁ QUE CAMBIAR ESTOO!!!
    //aCTUALIZAR DATA CADA 5 MIN ?
    /*
    if (data != null) {
      QuerySnapshot users = await database.collection('users').get();
      data.users.clear();
      for (var user in users.docs) {
        data.users.add(new UserModel.fromJson(user.data()));
      }
      data.users.sort((a, b) => b.userStats.total.timemeditated.compareTo(a.userStats.total.timemeditated));
    }*/

    //Mejor hacer funciones ??????? MEDITAR, SEGUIR A ALGUIEN ,TOMAR UNA LECCION, MUCHO IF !!
    if (type == 'meditate') {
      await database.collection('meditations').add(toAdd[0].toJson());
    } 
  }



  /*

    TODO: SACAR LAS LECCIONES QUE HA LEIDO !!
  */

  @override
  Future <UserModel> getUserData(String coduser) async{
    QuerySnapshot user = await database.collection('users').where('coduser', isEqualTo: coduser).get();
    if(user.docs.length > 0){
      UserModel u = UserModel.fromJson(user.docs[0].data());
  
      QuerySnapshot stage = await database.collection('stages').where('stagenumber',isEqualTo:u.stagenumber).get();
      StageModel s =  await populateStage(stage.docs[0].data());
      u.setStage(s);
      await addfollowers(u);
      
      QuerySnapshot meditations = await database.collection('meditations').where('coduser', isEqualTo: u.coduser).get();

      if (meditations.docs.length > 0) {
        for (DocumentSnapshot doc in meditations.docs) {
          u.addMeditation(new MeditationModel.fromJson(doc.data()));
        }
      }
      return u;
    } throw Exception();
  }
}
