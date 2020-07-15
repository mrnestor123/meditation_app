import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meditation_app/core/error/exception.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserLocalDataSource {
  /// Gets the cached [User] which was gotten the last time
  /// the user connected to the phone.
  ///
  /// Throws [NoLocalDataException] if no cached data is present.
  Future<UserModel> getUser();

  Future<void> cacheUser(UserModel userToCache);
}

const CACHED_USER = 'CACHED_USER';
const CACHED_MEDITATIONS ='CACHED_MEDITATIONS';

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences sharedPreferences;

  UserLocalDataSourceImpl({@required this.sharedPreferences});

  //Añadimos el usuario a la cache.
  @override
  Future<void> cacheUser(UserModel userToCache) {
     return sharedPreferences.setString(
    CACHED_USER, json.encode(userToCache.toJson())
    );
  }

  @override
  Future<UserModel> getUser() {
    final jsonUser = sharedPreferences.getString(CACHED_USER);
    if (jsonUser != null) {
    return Future.value(UserModel.fromJson(json.decode(jsonUser)));
    } else {
    throw CacheException();
    }
  }
}
