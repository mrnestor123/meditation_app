
//CARD CON LA STAGE 

import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/stage/path.dart';

class StageCard extends StatelessWidget {
  
  StageCard({this.stage});

  final Stage stage;

  @override
  Widget build(BuildContext context) {
    return Container(
    width: Configuration.width,
    height: Configuration.width > 500 ? Configuration.height*0.28 : 180,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(Configuration.borderRadius)
    ),
    child: ElevatedButton(
      onPressed: () => 
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ImagePath(stage: stage)
          )
        ),
      child: Stack(
        children: [
          Text('Stage ' + stage.stagenumber.toString(),
            style: Configuration.text('medium', Colors.white),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image(
                image: stage.shortimage  != null ? 
                NetworkImage(stage.shortimage) : AssetImage('assets/stage 1/stage 1.png'),
                height:Configuration.width > 500 ? 240 : 110,
                width: Configuration.width,
                fit: BoxFit.cover
                ),
            ),
          ),
        ],
      ),
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          primary: Configuration.maincolor,
          elevation: 2.0,
          onPrimary: Colors.white,
          padding: EdgeInsets.all(Configuration.smpadding),
          minimumSize: Size(double.infinity, double.infinity)),
    ),
    );
  }
}