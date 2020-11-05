import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meditation_app/core/error/exception.dart';
import 'package:meditation_app/core/structures/tupla.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/data/models/mission_model.dart';
import 'package:meditation_app/data/models/stageData.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/level.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:mock_cloud_firestore/mock_cloud_firestore.dart';
import 'package:observable/observable.dart';
import 'package:uuid/uuid.dart';

import '../models/lesson_model.dart';

typedef CollectionReference CollectionGet(String path);

//This will use the flutter database.
abstract class UserRemoteDataSource {
  // sacamos el objeto referencia
  MockCloudFirestore db;

  /// Logins a user to the DataBase
  ///
  /// Throws a [ServerException] for all error codes.
  Future<UserModel> loginUser({String password, String usuario});

  UserRemoteDataSource(this.db);

  Future<UserModel> registerUser(
      {String nombre,
      String mail,
      String password,
      String usuario,
      int stagenumber});

  //Given the stage we get all the lessons of  it. We get the brain lessons
  Future<List<LessonModel>> getBrainLessons({int stage});

  Future<List<LessonModel>> getMeditationLessons({int stage});

  Future meditate(MeditationModel m, UserModel user);

  //We get all the users data
//  Future<Map> getData();

  //We get all the lessons of every stage
  Future<Map> getAllLessons();

  Future changeStage(UserModel user);

  Future takeLesson(LessonModel l, UserModel user);

  Future<void> updateMission(MissionModel m, UserModel u, bool requiredmission);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  //Firestore db;
  MockCloudFirestore db;
  CollectionGet collectionGet;
  Firestore database;


  UserRemoteDataSourceImpl(this.db) {
    collectionGet = db.collection;
    database = Firestore.instance;
  }

  Map<int, Map<String, List<LessonModel>>> alllessons;





  //sacamos todos los datos del usuario. 
  //Meditaciones, lecciones y misiones. También sacamos las misiones de cada etapa
  @override
  Future<UserModel> loginUser({String password, String usuario}) async {
    CollectionReference docRef = collectionGet("users");
    // Query query = docRef.where('username',isEqualTo:usuario);
    QuerySnapshot documents = await docRef.getDocuments();
    //Query query = documents.where('username',isEqualTo:usuario);
    UserModel user;


    for (DocumentSnapshot document in documents.documents) {
      print(document.data);
      print(document.reference);
      if (usuario == document.data["usuario"] &&
          password == document.data["password"]) {
        user = new UserModel.fromJson(document.data);
      }
    }
    //Aquí le añadimos las lecciones que ha leido,las meditaciones que ha hecho y las misiones que tiene hechas y por hacer
    if (user != null) {
      DocumentReference userlist = collectionGet('userdata').document(user.coduser);
      //Query query = lessons.where('coduser',isequalto:userid)

      CollectionReference userlessons = userlist.collection('readlessons');
      CollectionReference usermeditations = userlist.collection('meditations');
      CollectionReference requiredmissionscol = userlist.collection('requiredmissions');
      CollectionReference optionalmissionscol = userlist.collection('optionalmissions');

      QuerySnapshot readlesson = await userlessons.getDocuments();
      QuerySnapshot meditationsuser = await usermeditations.getDocuments();
      QuerySnapshot reqmissions = await requiredmissionscol.getDocuments();
      QuerySnapshot optmissions = await optionalmissionscol.getDocuments();
    
      List<MeditationModel> m = new List<MeditationModel>();
      List<LessonModel> l = new List<LessonModel>();
      List<StageModel> s = new List<StageModel>();

      QuerySnapshot missions = await collectionGet('missions').getDocuments();

      /*
      for(DocumentSnapshot doc in missions.documents){
        MissionModel m = new MissionModel.fromJson(doc.data);
        database.collection('missions').add(m.toJson());
      }
      de momento no hago misiones
      hay que darle unas cuantas vueltas a los atributos
      */



     /* 
      Añadiendo lecciones a la base de datos
     QuerySnapshot goodlessons = await collectionGet('goodlessons').getDocuments();

      for(DocumentSnapshot doc in goodlessons.documents){
        LessonModel l = new LessonModel.fromJson(doc.data);
        database.collection('lessons').add(l.toJson());
      }*/

      for (DocumentSnapshot document in readlesson.documents) {
        l.add(new LessonModel.fromJson(document.data));
      }

      for (DocumentSnapshot document in meditationsuser.documents) {
        m.add(new MeditationModel.fromJson(document.data));
      }

      user.missions["required"] = {};
      for (DocumentSnapshot document in reqmissions.documents) {
        MissionModel aux = new MissionModel.fromJson(document.data);
        if (user.missions["required"][aux.type] == null) {
          user.missions["required"][aux.type] = new ObservableList();
        }
        user.missions["required"][aux.type].add(aux);
      }

      user.missions["optional"] = {};
      for (DocumentSnapshot document in optmissions.documents) {
        MissionModel aux = new MissionModel.fromJson(document.data);
        if (user.missions["optional"][aux.type] == null) {
          user.missions["optional"][aux.type] = new ObservableList();
        }
        user.missions["optional"][aux.type].add(aux);
      }

      user.setMeditations(m);
      user.setLearnedLessons(l);

      //user.setLessons(await getAllLessons());
      return user;
    } else {
      throw LoginException();
    }
  }


  //en este método el usuario cambia de etapa y se le añaden las misiones de esa etapa.
  Future changeStage(UserModel user) async{
    CollectionReference stages = collectionGet('stages');
    QuerySnapshot stagesqry = await stages.getDocuments();
    for(DocumentSnapshot document in stagesqry.documents){
      if(document.data["stagenumber"] == user.stagenumber){
        user.setStage(new StageModel.fromJson(document.data));
      }
    }
  }

  @override
  Future<UserModel> registerUser(
      {String nombre,
      String mail,
      String password,
      String usuario,
      int stagenumber}) async {

    //Sacamos la primera etapa
    QuerySnapshot firststage = await database.collection('stages').where('stagenumber',isEqualTo:1).getDocuments();
    StageModel one;

    for(DocumentSnapshot doc in firststage.documents) {
      one = new StageModel.fromJson(doc.data);
    }

    UserModel user = new UserModel(
      // De momento lo pongo así. Debería de crearse en el constructor :(
      coduser: Uuid().v1(),
      mail: mail,
      password: password,
      usuario: usuario,
      nombre: nombre,
      stagenumber: 1,
      stage: one,
      level: new Level()
    );
    //añadimos al usuario en la base de datos de usuarios
    await database.collection('users').add(user.toJson());
    //creamos su entrada en userdata
    DocumentReference userdata = await database.collection('userdata').add({'coduser': user.coduser});

    //sacamos las lecciones y misiones para añadirlas al usuario. Se le añaden hasta la etapa 3
    QuerySnapshot lessons = await database.collection('lessons').where('stagenumber', isLessThan: 4).getDocuments();

    //de momento no sacamos misiones
   // QuerySnapshot missions = await database.collection('missions').where('stagenumber', isLessThan: 4).getDocuments();

    // sacamos las lecciones y misiones y las añadimos a la base de datos userdata
    for(DocumentSnapshot lesson in lessons.documents){
      LessonModel l = new LessonModel.fromJson(lesson.data);
      l.precedinglesson != null ? l.blocked = true : l.blocked = false;
      l.seen = false;
      user.addLesson(l);
      userdata.collection('lessons').add({'codlesson': lesson.data['codlesson'],'seen': false, 'blocked': l.blocked});
    }

    /* para sacar misiones en el futuro
    for(DocumentSnapshot mission in missions.documents){
      mission.data['done'] = false;
      user.addMission(new MissionModel.fromJson(mission.data));
      userdata.collection('missions').add({'codmission': mission.data['codmission'],'done': false});
    }*/

    print(user);

    return user;
  }

  @override
  Future<List<LessonModel>> getBrainLessons({int stage}) async {
    ObservableList<LessonModel> l = new ObservableList<LessonModel>();
    CollectionReference lessons =
        collectionGet('lessons').document(stage.toString()).collection("brain");
    // Query query = lessons.where("stagenumber",isEqualTo:"1");
    QuerySnapshot documents = await lessons.getDocuments();
    for (DocumentSnapshot document in documents.documents) {
      print(document.data);
      l.add(new LessonModel.fromJson(document.data));
    }
    return l;
  }

  @override
  Future<List<LessonModel>> getMeditationLessons({int stage}) {
    // TODO: implement getMeditationLessons
    throw UnimplementedError();
  }

// Faltaría añadirlo a la base de datos
  @override
  Future meditate(MeditationModel m, UserModel user) async {
    // TODO: implement meditate

    DocumentReference ref = await collectionGet("userdata")
        .document(user.coduser)
        .collection("meditations")
        .add(m.toJson());

    //Aquí le añadiríamos el nivel de ahora.
  }





 /* @override
  Future<Map> getData() async {
    Map<int, Map<String, Map<String, List<LessonModel>>>> result =
        new Map<int, Map<String, Map<String, List<LessonModel>>>>();
    CollectionReference lessons = collectionGet('lessons');

    QuerySnapshot documents = await lessons.getDocuments();
    int stage = 1;

    for (DocumentSnapshot document in documents.documents) {
      result[stage] = {};
      document.data.forEach((oldkey, value) {
        result[stage][oldkey] = {};
        value.forEach((newkey, newvalue) {
          if (result[stage][oldkey][newvalue["group"]] == null) {
            result[stage][oldkey][newvalue["group"]] = [];
          }
          result[stage][oldkey][newvalue["group"]]
              .add(new LessonModel.fromJson(newvalue));
        });
      });
      stage++;
    }

    print(result);

    if (result.length > 0) {
      return result;
    } else {
      throw DataException();
    }
  }*/

  @override
  Future<Map> getAllLessons() async {
    ObservableList<LessonModel> l = new ObservableList<LessonModel>();
    Map<int, Map<String, List<LessonModel>>> result =
        new Map<int, Map<String, List<LessonModel>>>();
    CollectionReference lessons = collectionGet('goodlessons');

    QuerySnapshot documents = await lessons.getDocuments();
    int stage = 1;

    for (DocumentSnapshot document in documents.documents) {
      result[stage] = {};
      document.data.forEach((oldkey, value) {
        if (result[stage][value["group"]] == null) {
          result[stage][value["group"]] = [];
        }
        result[stage][value["group"]].add(new LessonModel.fromJson(value));
      });
      stage++;
    }
    alllessons = result;

    return result;
  }

  Future takeLesson(LessonModel l, UserModel user) async {
    DocumentReference ref = await collectionGet("userdata")
        .document(user.coduser)
        .collection("readlessons")
        .add({"codlesson": l.codlesson, "title": l.title});

    CollectionReference users = await collectionGet("users");
    // Query query = users.where("coduser"==user.coduser);
    //Aquí le añadiríamos el nivel de ahora
  }

  //FALTA POR IMPLEMENTAR, CUANDO HAYA CONEXION CON FIREBASE LO HAREMOS
  @override
  Future<void> updateMission(
      MissionModel m, UserModel u, bool requiredmission) {
    // TODO: implement updateMission
    throw UnimplementedError();
  }
}
