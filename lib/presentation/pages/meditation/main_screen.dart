import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/commonWidget/horizontal_list.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/menu/animatedcontainer.dart';

//List of guided meditationsx
List<Map> guidedmeditations = [];

class MainScreen extends StatelessWidget {

  var controller;

  MainScreen({this.controller});

  @override
  Widget build(BuildContext context) {
    Configuration().init(context);
    return ListView(
          controller: controller,
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(height:Configuration.safeBlockVertical*4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
              Text('Level 1', style: Configuration.subtitle),
              Text('Stage 10 ', style: Configuration.subtitle),
            ],),
            SizedBox(height:Configuration.safeBlockVertical*8),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/path'),
              child: Center(child:Image(image: AssetImage('images/stage 1.png')))),
            FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, '/premeditation'),
              child: Icon(Icons.timer),
              backgroundColor: Configuration.maincolor,
            ),

            SizedBox(height: 500)
            // HorizontalList(description: "Learn from our guided meditations")
          ],
        );
  }
}
