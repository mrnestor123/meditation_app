

import 'package:flutter/material.dart';

import '../config/configuration.dart';

Widget pageTitle(String title, String description, IconData icon){


  return Container(
    padding: EdgeInsets.all(Configuration.smpadding),
    margin: EdgeInsets.symmetric(horizontal: Configuration.smpadding),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color:Colors.grey),
      borderRadius: BorderRadius.circular(Configuration.borderRadius)
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon,  color: Colors.black, size: Configuration.smicon),
        SizedBox(width: Configuration.verticalspacing),
        Flexible(
          child: Text(description, style: Configuration.text('small',
          Colors.black)
          ),
        ),
      ],
    )
  );






}