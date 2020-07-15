import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meditation_app/core/error/exception.dart';
import 'package:meditation_app/core/structures/tupla.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
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

  Future<Tupla> getUserData({String userid});


  Future<MeditationModel> meditate(Duration d, UserModel user);



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
      user= new UserModel.fromJson(document.data);
    }
  
    if(user != null){
      return user;
    } else{
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
        stagenumber: 1);

    //faltará saber el id una vez añadido
    DocumentReference docRef = await collectionGet('users').add(user.toJson());
    print(docRef.toString());
    return user;
  }

  @override
  Future<List<LessonModel>> getBrainLessons({int stage}) async{
     ObservableList<LessonModel> l = new ObservableList<LessonModel>();
    CollectionReference lessons = collectionGet('lessons').document(stage.toString()).collection("brain");
    // Query query = lessons.where("stagenumber",isEqualTo:"1");
    QuerySnapshot documents = await lessons.getDocuments();
    for (DocumentSnapshot document in documents.documents) {
      print(document.data);
      l.add(new LessonModel.fromJson(document.data));
    }
    return l;
  }

  @override
  Future<Tupla> getUserData({String userid}) async{
    // TODO: implement getUserLessons

    List<LessonModel> learned = new List();
    List<LessonModel> remaining = new List();
    List<MeditationModel> usermeditations = new List();

    DocumentReference userlist = collectionGet('userlists').document('1');
     //Query query = lessons.where('coduser',isequalto:userid)

    CollectionReference remaininglessons = userlist.collection('remaininglessons');
    CollectionReference userlessons = userlist.collection('readlessons');
    CollectionReference usrmeditations = userlist.collection('meditations');

   
    QuerySnapshot readlesson = await userlessons.getDocuments();
    QuerySnapshot remaininglesson = await remaininglessons.getDocuments();
    QuerySnapshot meditationsuser = await usrmeditations.getDocuments();
  
    for (DocumentSnapshot document in readlesson.documents) {
      print(document.data);
      learned.add(new LessonModel.fromJson(document.data));
    }

    for(DocumentSnapshot document in remaininglesson.documents){
      print(document.data);
      remaining.add(new LessonModel.fromJson(document.data));
    }

    for(DocumentSnapshot document in meditationsuser.documents){
      print(document.data);
      usermeditations.add(new MeditationModel.fromJson(document.data));
    }

    Tupla t = new Tupla(usermeditations,learned,remaining);

    if(t != null){
      return (t);
    }else {
      throw DataException();
    }
  }

  @override
  Future<List<LessonModel>> getMeditationLessons({int stage}) {
    // TODO: implement getMeditationLessons
    throw UnimplementedError();
  }

// Faltaría añadirlo a la base de datos
  @override
  Future<MeditationModel> meditate(Duration d, UserModel user) async{
    // TODO: implement meditate
    MeditationModel res = new MeditationModel(duration: d.toString()); 
    user.totalMeditations.add(res);
    return res;
  }
}
