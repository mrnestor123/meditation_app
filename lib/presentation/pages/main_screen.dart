import 'package:flutter/material.dart';

import 'package:meditation_app/presentation/pages/config/configuration.dart';

class MainScreen extends StatelessWidget {
  MainScreen();

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: Configuration.height*0.05),
          Container(
              width: Configuration.width * 0.9,
              height: Configuration.height * 0.2,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Configuration.accentcolor),
              child: Center(
                  child: Image(
                      width: Configuration.width * 0.6,
                      image: AssetImage('assets/stage 1/stage 1.png')))),
          SizedBox(height: Configuration.height*0.05),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Column(
              children: [
                RawMaterialButton(
                  fillColor: Configuration.secondarycolor,
                  child: Icon(Icons.timer,
                      color: Colors.white, size: Configuration.bigicon),
                  padding: EdgeInsets.all(4.0),
                  shape: CircleBorder(),
                  onPressed: () {},
                ),
                Container(
                  child: Text('Meditate',
                      style: Configuration.text('large', Colors.white)),
                  margin: EdgeInsets.only(top: 10),
                )
              ],
            ),
            Column(children: [
              RawMaterialButton(
                fillColor: Configuration.secondarycolor,
                child: Icon(Icons.emoji_events,
                    color: Colors.white, size: Configuration.bigicon),
                padding: EdgeInsets.all(4.0),
                shape: CircleBorder(),
                onPressed: () {},
              ),
              Container(
                  child: Text('Explore',
                      style: Configuration.text('large', Colors.white)),
                  margin: EdgeInsets.only(top: 10)),
            ])
          ])
        ]);
  }
}
