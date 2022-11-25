import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

/** idea. 
 * GUARDAR SOLO EL CÓDIGO DEL USUARIO
 * 
*/

abstract class UserLocalDataSource {
  /// Gets the cached  which was gotten the last time
  Future<String> getUser([String usuario]);

  Future<void> cacheUser(UserModel userToCache);

  Future logout();
}

const CACHED_USER = 'CACHED_USER';

//puede ser que guarde demasiadas cosas en la cachee !!
class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences sharedPreferences;
  Stage cachedStage;

  UserLocalDataSourceImpl({@required this.sharedPreferences});

  //Añadimos el usuario a la cache con su nombre de usuario.
  @override
  Future<void> cacheUser(UserModel userToCache) async {
    sharedPreferences.setString(CACHED_USER, json.encode(userToCache.coduser));
   // sharedPreferences.setString(CACHED_USER, json.encode("upFNZQiPrbZfcIQstDd1XF7xYqG3"));
  }

  @override
  Future<String> getUser([String usuario]) async {
    final jsonUser = sharedPreferences.getString(CACHED_USER);
    if (jsonUser != null) {
      return Future.value(json.decode(jsonUser));
    } else {
      throw Exception();
    }
  }

  @override
  Future logout() async {
    return sharedPreferences.clear();   
  }
}
