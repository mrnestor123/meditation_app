import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meditation_app/core/error/exception.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/data/models/mission_model.dart';
import 'package:meditation_app/data/models/stageData.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/lesson_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
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
  Future<UserModel> loginUser({FirebaseUser usuario});

  UserRemoteDataSource(this.db);

  Future<UserModel> registerUser({FirebaseUser usuario});

  Future updateUser({UserModel user, DataBase data, MeditationModel m});

  //We get all the users data
  Future<DataBase> getData();

  //We get all the lessons of every stage
  Future<Map> getAllLessons();

  Future changeStage(UserModel user);

  Future updateLessons(UserModel u);

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

  Future updateLessons(UserModel u) async {}

  //sacamos todos los datos del usuario.
  //Meditaciones, lecciones y misiones. También sacamos las misiones de cada etapa
  @override
  Future<UserModel> loginUser({FirebaseUser usuario}) async {
    QuerySnapshot user = await database
        .collection('users')
        .where('coduser', isEqualTo: usuario.uid)
        .getDocuments();

    UserModel loggeduser;

    if (user.documents.length > 0) {
      loggeduser = new UserModel.fromJson(user.documents[0].data);

      QuerySnapshot stage = await database
          .collection('stages')
          .where('stagenumber', isEqualTo: loggeduser.stagenumber)
          .getDocuments();

      StageModel s = new StageModel.fromJson(stage.documents[0].data);

      loggeduser.setStage(s);

      QuerySnapshot userdata = await database
          .collection('userdata')
          .where('coduser', isEqualTo: loggeduser.coduser)
          .getDocuments();

      if (userdata.documents.length > 0) {
        String documentId = userdata.documents[0].documentID;
        QuerySnapshot usermeditations = await database
            .collection('userdata')
            .document(documentId)
            .collection('meditations')
            .getDocuments();
        for (DocumentSnapshot doc in usermeditations.documents) {
          loggeduser.addMeditation(new MeditationModel.fromJson(doc.data));
        }
      }

      return loggeduser;
    } else {
      throw LoginException();
    }
  }

  //en este método el usuario cambia de etapa y se le añaden las misiones de esa etapa.
  Future changeStage(UserModel user) async {
    CollectionReference stages = collectionGet('stages');
    QuerySnapshot stagesqry = await stages.getDocuments();
    for (DocumentSnapshot document in stagesqry.documents) {
      if (document.data["stagenumber"] == user.stagenumber) {
        user.setStage(new StageModel.fromJson(document.data));
      }
    }
  }

  @override
  Future<UserModel> registerUser({FirebaseUser usuario}) async {
    //Sacamos la primera etapa
    QuerySnapshot firststage = await database
        .collection('stages')
        .where('stagenumber', isEqualTo: 1)
        .getDocuments();
    StageModel one;

    for (DocumentSnapshot doc in firststage.documents) {
      one = new StageModel.fromJson(doc.data);
    }

    UserModel user = new UserModel(
        coduser: usuario.uid,
        user: usuario,
        stagenumber: 1,
        role: "meditator",
        position: 0,
        stage: one,
        stats: {
          'total': {
            'lecciones': 0,
            'meditaciones': 0,
            'maxstreak': 0,
            'tiempo': 0
          },
          'etapa': {
            'lecciones': 0,
            'medittiempo': 0,
            'meditguiadas': 0,
            'maxstreak': 0,
            'tiempo': 0
          },
          'racha': 0,
          'ultimosleidos': [],
          'lastmeditated': ''
        });

    //añadimos al usuario en la base de datos de usuarios
    await database.collection('users').add(user.toJson());
    await database.collection('userdata').add({'coduser': user.coduser});

    return user;
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

  @override
  Future<DataBase> getData() async {
    DataBase d = new DataBase();
    QuerySnapshot stages = await database.collection('stages').getDocuments();
    QuerySnapshot users = await database.collection('users').getDocuments();

    for (var stage in stages.documents) {
      StageModel s = new StageModel.fromJson(stage.data);
      d.stages.add(s);
    }

    for (var user in users.documents) {
      d.users.add(new UserModel.fromJson(user.data));
    }

    d.stages.sort((a, b) => a.stagenumber.compareTo(b.stagenumber));
    d.users.sort((a,b) => b.stats['total']['tiempo'].compareTo(a.stats['total']['tiempo']));

    return d;
  }

  @override
  //cada vez que los valores cambien del usuario lo updatearemos
  Future updateUser({UserModel user, DataBase data, MeditationModel m}) async {
    QuerySnapshot userreference = await database
        .collection('users')
        .where('coduser', isEqualTo: user.coduser)
        .getDocuments();
    String documentId = userreference.documents[0].documentID;

    print(user.toRawJson());

    await database
        .collection("users")
        .document(documentId)
        .updateData(user.toJson());

    //actualizamos la base de datos
    if (data != null) {
      QuerySnapshot users = await database.collection('users').getDocuments();
      data.users.clear();

      for (var user in users.documents) {
        data.users.add(new UserModel.fromJson(user.data));
      }
    
      data.users.sort((a,b) => b.stats['total']['tiempo'].compareTo(a.stats['total']['tiempo']));
    }

    if (m != null) {
      await database.collection('meditations').add(m.toJson());
    }
  }
}
