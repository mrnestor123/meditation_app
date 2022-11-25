

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
  Future init(User u, User me) async{
    isMe = me.coduser == u.coduser;
    loading = true;

    if(!isMe){
      selected = u;

      foldResult(
        //PORQUE NO LO COGEMOS YA EXPANDIDO ????????
        result: await repository.expandUser(u:selected),
        onSuccess: (r){
          selected = r;
          selected.checkStreak();

          if(selected.isTeacher() && selected.addedcontent.length > 0){
            selected.addedcontent.sort((a,b)=> a.stagenumber  - b.stagenumber);
          }

          loading = false;
        }
      );
    }else{
      loading = false;
      selected = me;
    }
  }

}
 