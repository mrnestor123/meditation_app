
//CARD CON LA STAGE 

import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';

class StageCard extends StatelessWidget {
  
  StageCard({this.stage});

  final Stage stage;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
    aspectRatio: 16/9,
      child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0)
      ),
      child: TextButton(
        onPressed: () => Navigator.pushNamed(context, '/imagepath'),
        child: Stack(
          children: [
            Text('Stage ' + stage.stagenumber.toString(),
              style: Configuration.text('small', Colors.white),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image(
                  image: stage.shortimage  != null ? 
                  NetworkImage(stage.shortimage) : 
                  AssetImage('assets/stage 1/stage 1.png')
                  ),
              ),
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
            primary: Configuration.maincolor,
            elevation: 0.0,
            onPrimary: Colors.white,
            padding: EdgeInsets.all(Configuration.smpadding),
            minimumSize: Size(double.infinity, double.infinity)),
      ),
    ),
      );
  }
}