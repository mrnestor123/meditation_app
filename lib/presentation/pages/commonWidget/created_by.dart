

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
          bordercolor: Colors.white
        ),
        label: Text(
          'Created by ' + createdBy['nombre'], 
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          textScaleFactor: 1,
          style: Configuration.text('small', Colors.white)
        ),
      )
    ),
  );
}


Widget doneChip(Map<String,dynamic> createdBy, {bool small = false}) {

  return Container(
    padding: EdgeInsets.all(small ? 4: 6),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(Configuration.borderRadius) ,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ProfileCircle(
          width: small ? 10: 20,
          userImage: createdBy['image'],
        ),
        SizedBox(width: Configuration.verticalspacing),
        Text(
          createdBy['nombre'],
          style: Configuration.text(small ? 'tiny': 'small', Colors.black),
        )
      ],
    )
  );

}

