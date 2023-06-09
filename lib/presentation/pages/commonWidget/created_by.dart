

import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/commonWidget/profile_widget.dart';
import 'package:meditation_app/presentation/pages/commonWidget/user_bottom_dialog.dart';

import '../config/configuration.dart';

Widget createdByChip(Map<String, dynamic> createdBy){

  return Container(
      constraints: BoxConstraints(
        maxWidth: Configuration.width*0.6
      ),
      child: GestureDetector(
        onTap: ()=>{
          showUserProfile(usercod: createdBy['coduser'], isTeacher: true)
        },
        child: Chip(
          padding: EdgeInsets.all(Configuration.tinpadding),
          backgroundColor: Colors.lightBlue,
          avatar: ProfileCircle(
            userImage: createdBy['image'], 
            width: Configuration.verticalspacing*4, 
            bordercolor: Colors.white),
          label: Text('Created by ' + createdBy['nombre'], 
          style: Configuration.text('small', Colors.white),),
        )
      ),
    );


}