

import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/repositories/user_repository.dart';
import 'package:meditation_app/presentation/mobx/actions/error_helper.dart';
import 'package:meditation_app/presentation/pages/main.dart';
import 'package:mobx/mobx.dart';

part 'profile_state.g.dart';

// MANEJA LA PÁGINA DE PERFIL !!
class ProfileState extends _ProfileState with _$ProfileState {
  ProfileState({UserRepository userRepository}): super(repository: userRepository);

}

abstract class _ProfileState with Store {

  @observable
  User selected;

  String coduser;

  @observable
  bool loading = false;
  

  List<User> lastUsers = new List.empty(growable: true);


  UserRepository repository;

  bool isMe = false;

  _ProfileState({this.repository});


  @action 
  Future init(User u, bool me) async{
    selected = u;
    isMe = me;
    loading = true;

    if(!isMe){
      foldResult(
        result: await repository.expandUser(u:selected),
        onSuccess: (r){
          selected = r;
          loading = false;
        }
      );
    }else{
      loading = false;
    }
  }


}
 