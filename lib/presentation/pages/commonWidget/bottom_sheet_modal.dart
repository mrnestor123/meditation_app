

import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/requests_screen.dart';

import '../config/configuration.dart';

Widget BottomSheetModal({Widget child}){

  return Container(
    constraints: BoxConstraints(
      minHeight: Configuration.height*0.3
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(Configuration.borderRadius))
    ),
    child: Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: EdgeInsets.only(right: Configuration.verticalspacing),
            child: CloseButton(
              color: Colors.black
            ),
          ),
        ),
        child
      ],
    ),
  );
}