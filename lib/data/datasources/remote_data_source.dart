import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meditation_app/core/error/exception.dart';
import 'package:meditation_app/core/structures/tupla.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/data/models/mission_model.dart';
import 'package:meditation_app/data/models/stageData.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/lesson_entity.dart';
import 'package:meditation_app/domain/entities/level.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
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

  Future takeLesson(Lesson l, User user,List<Lesson> unlockedlessons);

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
    
    QuerySnapshot user = await database.collection('users').where('usuario', isEqualTo: usuario).where('password',isEqualTo:password).getDocuments();
    UserModel loggeduser;

    if(user.documents.length > 0) {
      loggeduser = new UserModel.fromJson(user.documents[0].data);
      QuerySnapshot stage = await database.collection('stages').where('stagenumber',isEqualTo:loggeduser.stagenumber).getDocuments();  
      loggeduser.setStage(new StageModel.fromJson(stage.documents[0].data));
      QuerySnapshot userdata = await database.collection('userdata').where('coduser',isEqualTo: loggeduser.coduser).getDocuments();
      String documentId = userdata.documents[0].documentID;
      // HAY QUE HACER UN JOIN DE LAS DOS
      QuerySnapshot userlessons = await database.collection('userdata').document(documentId).collection('lessons').getDocuments();
      QuerySnapshot usermeditations = await database.collection('userdata').document(documentId).collection('meditations').getDocuments();
      QuerySnapshot databaselessons = await database.collection('lessons').where('stagenumber', isLessThan: loggeduser.stagenumber +3).getDocuments();

      Map<String,dynamic> joinedlessons = {};

      for(DocumentSnapshot doc in databaselessons.documents){
        joinedlessons[doc.data['codlesson']] = doc.data;
      }


      for(DocumentSnapshot doc in userlessons.documents) {
        joinedlessons[doc.data['codlesson']]['seen'] = doc.data['seen'];
        joinedlessons[doc.data['codlesson']]['blocked'] = doc.data['blocked'];       
        loggeduser.addLesson(new LessonModel.fromJson(joinedlessons[doc.data['codlesson']]));
      }

      for(DocumentSnapshot doc in usermeditations.documents){
        loggeduser.addMeditation(new MeditationModel.fromJson(doc.data));
      }

      //Faltaría por hacer lo mismo con las misiones
      return loggeduser;
    }

     else {
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
  Future<UserModel> registerUser({String nombre, String mail,String password,String usuario,int stagenumber}) async {

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


    QuerySnapshot usersnapshot = await database.collection('userdata').where('coduser', isEqualTo:user.coduser).getDocuments();

    DocumentReference meditations = await database.collection('userdata').document(usersnapshot.documents[0].documentID).collection('meditations').add(m.toJson());



   /* DocumentReference ref = await collectionGet("userdata")
        .document(user.coduser)
        .collection("meditations")
        .add(m.toJson());
    */
    //Aquí le añadiríamos el nivel de ahora.
  }


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


  //ESTO DEBERÍAN SER LESSONMODELS Y USERMODELS
  Future takeLesson(Lesson l, User user,List<Lesson> unlockedlessons) async {
    QuerySnapshot userdata = await database.collection('userdata').where('coduser',isEqualTo:user.coduser).getDocuments();
    String documentId = userdata.documents[0].documentID;

    
    QuerySnapshot lessondone = await database.collection('userdata').document(documentId).collection('lessons').where('codlesson', isEqualTo: l.codlesson).getDocuments();
    // lo ha visto en la base de datos
    await database.collection('userdata').document(documentId).collection('lessons').document(lessondone.documents[0].documentID).updateData({'seen':true});
    
    //desbloqueamos las lecciones que haya que desbloquear
    for(LessonModel lesson in unlockedlessons){
      QuerySnapshot dbunlockedlesson = await database.collection('userdata').document(documentId).collection('lessons').where('codlesson', isEqualTo: lesson.codlesson).getDocuments();
      await database.collection('userdata').document(documentId).collection('lessons').document(dbunlockedlesson.documents[0].documentID).updateData({'blocked':false});
    }

   }

  //FALTA POR IMPLEMENTAR, CUANDO HAYA CONEXION CON FIREBASE LO HAREMOS
  @override
  Future<void> updateMission(
      MissionModel m, UserModel u, bool requiredmission) {
    // TODO: implement updateMission
    throw UnimplementedError();
  }
}
