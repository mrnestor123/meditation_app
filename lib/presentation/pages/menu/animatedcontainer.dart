import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meditation_app/login_injection_container.dart';
import 'package:meditation_app/presentation/mobx/actions/lesson_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/bottom_menu.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/learn/learn_widget.dart';
import 'package:meditation_app/presentation/pages/meditation/main_screen.dart';
import 'package:meditation_app/presentation/pages/meditation/meditation_lessons.dart';
import 'package:provider/provider.dart';

//elements for the sidebar
List<Map> sidebarItems = [
  {
    'icon': Icons.explore,
    'text': 'Explore',
    'route': '/main',
    'title': 'Time to wake up'
  },
  {
    'icon': Icons.school,
    'text': 'Meditation',
    'route': '/meditate',
    'title': 'Meditation'
  },
  {
    'icon': FontAwesomeIcons.brain,
    'text': 'Brain',
    'route': '/brain',
    'title': 'Brain'
  },
  {'icon': Icons.chat, 'text': 'Chat', 'route': '/main', 'title': 'Chat'},
];

class ContainerAnimated extends StatefulWidget {
  const ContainerAnimated({Key key}) : super(key: key);

  @override
  _AnimatedState createState() => _AnimatedState();
}

class _AnimatedState extends State<ContainerAnimated> {
  //bool showstages;
  bool sidebarOpen = false;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  String currentRoute = '/main';
  String title = 'Time to wake up';

  Widget sidebar(_userstate) {
    return Container(
        padding: EdgeInsets.only(top: 40, bottom: 60, left: 20),
        color: Configuration.maincolor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(children: <Widget>[
              GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                  child: CircleAvatar(child: Text('ERN'))),
              SizedBox(width: Configuration.safeBlockHorizontal * 2),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(_userstate.user.nombre,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    Text('Level 10', style: TextStyle(color: Colors.grey))
                  ])
            ]),
            Column(
                children: sidebarItems
                    .map((element) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                xOffset = 0;
                                yOffset = 0;
                                scaleFactor = 1;
                                currentRoute = element['route'];
                                title = element['title'];
                                sidebarOpen = false;
                              });
                            },
                            child: Row(children: <Widget>[
                              Icon(element['icon'],
                                  color: element['route'] == currentRoute
                                      ? Colors.white
                                      : Colors.white60,
                                  size: Configuration.iconSize),
                              SizedBox(
                                  width: Configuration.safeBlockHorizontal * 4),
                              Text(
                                element['text'],
                                style: TextStyle(
                                    color: element['route'] == currentRoute
                                        ? Colors.white
                                        : Colors.white60),
                              )
                            ]),
                          ),
                        ))
                    .toList()),
            Row(
              children: <Widget>[
                Icon(Icons.settings, color: Colors.white),
                SizedBox(width: 10),
                Text('Settings', style: TextStyle(color: Colors.white)),
                SizedBox(width: 10),
                Container(width: 2, height: 20, color: Colors.white),
                SizedBox(width: 10),
                Text('Log out', style: TextStyle(color: Colors.white))
              ],
            )
          ],
        ));
  }

  Widget switchMenu() {
    switch (currentRoute) {
      case '/main':
        return MainScreen();
      case '/meditate':
        return LearnMeditation();
      case '/brain':
        return Provider(
            create: (context) => sl<LessonState>(), child: LearnScreen());
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    Configuration().init(context);
    // showstages = widget.menuindex =='Meditation'|| widget.menuindex == 'Brain';
    final _userstate = Provider.of<UserState>(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          sidebar(_userstate),
          AnimatedContainer(
            decoration: BoxDecoration(
                borderRadius: sidebarOpen
                    ? BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30))
                    : null,
                color: Colors.grey[500]),
            transform: Matrix4.translationValues(xOffset, yOffset, 0)
              ..scale(scaleFactor)
              ..rotateY(sidebarOpen ? -0.1 : 0),
            duration: Duration(milliseconds: 250),
            child: Column(
              children: <Widget>[
                Container(
                  height: Configuration.height * 0.15,
                  padding: EdgeInsets.all(6),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      sidebarOpen
                          ? IconButton(
                              iconSize: Configuration.iconSize,
                              color: Colors.white,
                              icon: Icon(Icons.arrow_back),
                              onPressed: () => {
                                    setState(() {
                                      xOffset = 0;
                                      yOffset = 0;
                                      scaleFactor = 1;
                                      sidebarOpen = false;
                                    })
                                  })
                          : IconButton(
                              icon: Icon(Icons.menu),
                              color: Colors.white,
                              iconSize: Configuration.iconSize,
                              onPressed: () => {
                                setState(() {
                                  xOffset =
                                      Configuration.safeBlockHorizontal * 50;
                                  yOffset =
                                      Configuration.safeBlockVertical * 20;
                                  scaleFactor = 0.6;
                                  sidebarOpen = true;
                                })
                              },
                            ),
                      Text(title, style: Configuration.title),
                      GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/profile'),
                          child: CircleAvatar(child: Text('ERN')))
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 8),
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(25))),
                  child: switchMenu(),
                )),
                currentRoute == '/meditate ' || currentRoute == '/brain'
                    ? BottomMenu(selectedindex: 1)
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
