import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/commonWidget/horizontal_list.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/menu/animatedcontainer.dart';
import 'package:meditation_app/presentation/pages/menu/sidebar.dart';

//List of guided meditationsx
List<Map> guidedmeditations = [];

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Configuration().init(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SideBar(),
          ContainerAnimated(
            title: "Train your mind",
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Image(image: AssetImage('images/meditando.png')),
                FloatingActionButton(
                  onPressed: () => Navigator.pushNamed(context,'/premeditation'),
                  child: Icon(Icons.timer),
                  backgroundColor: Configuration.maincolor,
                ),
                HorizontalList(description: "Learn from our guided meditations")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
