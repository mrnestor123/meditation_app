


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/menu/GridDashboard.dart';

class MenuWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Color(0xff392850),
        body:Column(
          children: <Widget>[
            GridDashboard()
        ]
        ) 
    );
  } 
}