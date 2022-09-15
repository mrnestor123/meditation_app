
//CARD CON LA STAGE 

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/stage/path.dart';

class StageCard extends StatelessWidget {
  StageCard({this.stage, this.background, this.textcolor});

  final Stage stage;
  final Color background;
  final Color textcolor;

  @override
  Widget build(BuildContext context) {
    return Container(
    width: Configuration.width,
    height: Configuration.width > 500 ? Configuration.height*0.25 : Configuration.height*0.21,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(Configuration.borderRadius)),
    child: ElevatedButton(
      onPressed: () => 
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ImagePath(stage: stage)
          )
        ),
      child: Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        children: [ 
          Text('Stage ' + stage.stagenumber.toString(),style: Configuration.text('medium', textcolor != null ? textcolor : Colors.white)),
          SizedBox(height: Configuration.verticalspacing),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image(
                width: Configuration.width,
                image: stage.shortimage  != null ? CachedNetworkImageProvider(stage.shortimage) : AssetImage('assets/stage 1/stage 1.png'),
                fit: BoxFit.cover
                ),
            ),
          ),
        ],
      ),
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          primary: this.background != null ? this.background : Configuration.maincolor,
          elevation: 2.0,
          onPrimary: Colors.white,
          padding: EdgeInsets.all(Configuration.smpadding),
          minimumSize: Size(double.infinity, double.infinity)),
    ),
    );
  }
}


