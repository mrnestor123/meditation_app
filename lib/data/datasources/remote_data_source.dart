import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meditation_app/core/error/exception.dart';
import 'package:meditation_app/core/structures/tupla.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:mock_cloud_firestore/mock_cloud_firestore.dart';
import 'package:observable/observable.dart';

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
  Future<Map> getData();

  //We get all the lessons of every stage
  Future<Map> getAllLessons();

  Future takeLesson(LessonModel l, UserModel user);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  //Firestore db;
  MockCloudFirestore db;
  CollectionGet collectionGet;
  UserRemoteDataSourceImpl(this.db) {
    collectionGet = db.collection;
  }

  //Habrá que cambiar este método yo creo por meter un UserModel
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
    //Aquí le añadimos las lecciones que ha leido y las meditaciones que ha hecho
    if (user != null) {
      DocumentReference userlist =
          collectionGet('userdata').document(user.coduser);
      //Query query = lessons.where('coduser',isequalto:userid)

      CollectionReference userlessons = userlist.collection('readlessons');
      CollectionReference usermeditations = userlist.collection('meditations');

      QuerySnapshot readlesson = await userlessons.getDocuments();
      QuerySnapshot meditationsuser = await usermeditations.getDocuments();

      List<MeditationModel> m = new List<MeditationModel>();
      List<LessonModel> l = new List<LessonModel>();

      for (DocumentSnapshot document in readlesson.documents) {
        l.add(new LessonModel.fromJson(document.data));
      }

      for (DocumentSnapshot document in meditationsuser.documents) {
        m.add(new MeditationModel.fromJson(document.data));
      }

      user.setMeditations(m);
      user.setLearnedLessons(l);

      return user;
    } else {
      throw LoginException();
    }
  }

  @override
  Future<UserModel> registerUser(
      {String nombre,
      String mail,
      String password,
      String usuario,
      int stagenumber}) async {
    UserModel user = new UserModel(
      mail: mail,
      password: password,
      usuario: usuario,
      nombre: nombre,
      stagenumber: 1,
    );

    //faltará saber el id una vez añadido
    DocumentReference docRef = await collectionGet('users').add(user.toJson());
    print(docRef.toString());
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

    // user.totalMeditations.add(res);
    
  }

  @override
  Future<Map> getData() async {
    ObservableList<LessonModel> l = new ObservableList<LessonModel>();
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

    return result;
  }

  Future takeLesson(LessonModel l, UserModel user) async {
    DocumentReference ref = await collectionGet("userdata")
        .document(user.coduser)
        .collection("readlessons")
        .add({"codlesson": l.codlesson, "title": l.title});
  }
}
