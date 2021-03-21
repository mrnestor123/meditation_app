import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_app/core/error/exception.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/data/models/stageData.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
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

  Future updateUser({UserModel user, DataBase data, MeditationModel m});

  //We get all the users data
  Future<DataBase> getData();

  Future updateLessons(UserModel u);

  Future updateImage(PickedFile image, User u);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {

  var database;

  UserRemoteDataSourceImpl() {
    database = FirebaseFirestore.instance;
  }

  Map<int, Map<String, List<LessonModel>>> alllessons;

  Future updateLessons(UserModel u) async {}

  //sacamos todos los datos del usuario.
  //Meditaciones, lecciones y misiones. También sacamos las misiones de cada etapa
  @override
  Future<UserModel> loginUser({var usuario}) async {
    QuerySnapshot user = await database.collection('users').where('coduser', isEqualTo: usuario.uid).get();

    UserModel loggeduser;

    if (user.docs.length > 0) {
      loggeduser = new UserModel.fromJson(user.docs[0].data());

      QuerySnapshot stage = await database.collection('stages').where('stagenumber', isEqualTo: loggeduser.stagenumber).get();

      StageModel s = new StageModel.fromJson(stage.docs[0].data());

      QuerySnapshot lessons = await database.collection('content').where('stagenumber', isEqualTo: s.stagenumber).get();

      for (var content in lessons.docs) {
        if (content.data()['position'] != null) {
          content.data()['type'] == 'meditation-practice' || content.data()['type'] == 'game' ?
          s.addContent(MeditationModel.fromJson(content.data())):
          s.addContent(LessonModel.fromJson(content.data()));
        }
      }

      loggeduser.setStage(s);

      QuerySnapshot meditations = await database.collection('meditations').where('coduser', isEqualTo: loggeduser.coduser).get.data()();

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
    QuerySnapshot firststage = await database
        .collection('stages')
        .where('stagenumber', isEqualTo: 1)
        .get();
    StageModel one;

    for (DocumentSnapshot doc in firststage.docs) {
      one = new StageModel.fromJson(doc.data());
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
  Future<DataBase> getData() async  {
    DataBase d = new DataBase();
    QuerySnapshot stages = await database.collection('stages').get();
    QuerySnapshot users = await database.collection('users').get();

    for (var stage in stages.docs) {
      StageModel s = new StageModel.fromJson(stage.data());
      QuerySnapshot lessons = await database
          .collection('content')
          .where('stagenumber', isEqualTo: s.stagenumber)
          .get();

      for (var content in lessons.docs) {
        if (content.data()['position'] != null) {
           content.data()['type'] == 'meditation-practice' || content.data()['type'] == 'game' ?
          s.addContent(MeditationModel.fromJson(content.data())):
          s.addContent(LessonModel.fromJson(content.data()));
        }
      }
      
      d.stages.add(s);
    }

    for (var user in users.docs) {
      d.users.add(new UserModel.fromJson(user.data()));
    }

    d.stages.sort((a, b) => a.stagenumber.compareTo(b.stagenumber));
    d.users.sort((a, b) =>
        b.stats['total']['tiempo'].compareTo(a.stats['total']['tiempo']));

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
  Future updateUser({UserModel user, DataBase data, MeditationModel m}) async {
    QuerySnapshot userreference = await database.collection('users').where('coduser', isEqualTo: user.coduser).get();
    String documentId = userreference.docs[0].id;
    await database.collection("users").doc(documentId).update(user.toJson());

    //actualizamos la base de datos. habrá que mirarlo esto
    if (data != null) {
      QuerySnapshot users = await database.collection('users').get();
      data.users.clear();
      for (var user in users.docs) {
        data.users.add(new UserModel.fromJson(user.data()));
      }
      data.users.sort((a, b) => b.stats['total']['tiempo'].compareTo(a.stats['total']['tiempo']));
    }

    if (m != null) {
      await database.collection('meditations').add(m.toJson());
    }
  }
}
