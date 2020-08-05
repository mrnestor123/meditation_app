import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:meditation_app/core/error/exception.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserLocalDataSource {
  /// Gets the cached [User] which was gotten the last time
  /// the user connected to the phone.
  Future<UserModel> getUser([String usuario]);

  Future<void> cacheUser(UserModel userToCache);

  Future<bool> logout();

  Future<void> addMeditation(MeditationModel meditation);
}

const CACHED_USER = 'CACHED_USER';
const CACHED_MEDITATIONS = 'CACHED_MEDITATIONS';
const CACHED_LESSONS = 'CACHED_LESSONS';

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences sharedPreferences;

  List<String> usermeditations;
  List<String> userlessons;

  UserLocalDataSourceImpl({@required this.sharedPreferences});

  //Añadimos el usuario a la cache con su nombre de usuario.
  @override
  Future<void> cacheUser(UserModel userToCache) async {
    await sharedPreferences.clear();
    sharedPreferences.setString(CACHED_USER, json.encode(userToCache.toJson()));

    usermeditations = userToCache.totalMeditations
        .map((meditation) => json.encode(meditation.toJson()))
        .toList();
    userlessons = userToCache.lessonslearned
        .map((lesson) => json.encode(lesson.toJson()))
        .toList();

    sharedPreferences.setStringList(CACHED_LESSONS, userlessons);
    return sharedPreferences.setStringList(
        CACHED_MEDITATIONS, usermeditations);
  }

  Future<bool> addMeditation(MeditationModel meditation) async {
    final jsonUser = sharedPreferences.getString(CACHED_USER);
    if (jsonUser != null) {
      usermeditations.add(json.encode(meditation.toJson()));
      return await sharedPreferences.setStringList(
          CACHED_MEDITATIONS, usermeditations);
    } else {
      throw CacheException();
    }
  }

  Future<List<MeditationModel>> getUserMeditations() async {
    List<MeditationModel> usermeditations = new List();
    final meditations = sharedPreferences.getStringList(CACHED_MEDITATIONS);
    for (var m in meditations) {
      usermeditations.add(new MeditationModel.fromJson(json.decode(m)));
    }
    return usermeditations;
  }

  @override
  Future<UserModel> getUser([String usuario]) async {
    final jsonUser = sharedPreferences.getString(CACHED_USER);
    if (jsonUser != null) {
      final user = UserModel.fromJson(json.decode(jsonUser));
      if (usuario == null || usuario != null && user.usuario == usuario) {
        if (sharedPreferences.getStringList(CACHED_LESSONS) != null) {
          userlessons =
              sharedPreferences.getStringList(CACHED_LESSONS);
          user.setLearnedLessons((userlessons)
              .map((lesson) => LessonModel.fromJson((json.decode(lesson))))
              .toList());
        }
        if (sharedPreferences.getStringList(CACHED_MEDITATIONS) !=
            null) {
          usermeditations =
              sharedPreferences.getStringList(CACHED_MEDITATIONS);
          user.setMeditations((usermeditations)
              .map((meditation) =>
                  MeditationModel.fromJson(json.decode(meditation)))
              .toList());
        }

        return Future.value(user);
      } else {
        throw Exception();
      }
    } else {
      throw Exception();
    }
  }

  @override
  Future<void> cacheMeditation(MeditationModel meditationtoCache) {
    List<String> currentmeditations =
        sharedPreferences.getStringList(CACHED_USER + " meditations");

    currentmeditations.add(meditationtoCache.toRawJson());
  }

  @override
  Future<bool> logout() {
    return sharedPreferences.clear();
  }

  @override
  Future<List<MeditationModel>> getMeditations() {}
}
