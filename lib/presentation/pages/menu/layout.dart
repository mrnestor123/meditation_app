import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meditation_app/presentation/mobx/actions/lesson_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/learn/brain_widget.dart';
import 'package:provider/provider.dart';

import '../../../login_injection_container.dart';

class MainLayout extends StatefulWidget {
  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    Configuration().init(context);
    return LayoutBuilder(
      builder: (builder, constraints) {
        print(constraints.maxWidth);
        if (constraints.maxWidth < 700) {
          return MobileLayout();
        } else {
          return TabletLayout();
        }
      },
    );
  }
}

class MobileLayout extends StatefulWidget {
  @override
  _MobileLayoutState createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  final GlobalKey _scaffoldKey = new GlobalKey();
  String currentRoute = '/main';

  Widget switchMenu(_controller) {
    switch (currentRoute) {
      case '/main':
        return MainScreen();
      case '/brain':
        return Provider(
            create: (context) => sl<LessonState>(),
            child: BrainScreen(controller: _controller));
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      key: _scaffoldKey,
      drawer: SideBar(),
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Text('Drawer demo')),
      body: Container(
        color: Configuration.maincolor,
        height: Configuration.height,
        width: Configuration.width,
        padding: EdgeInsets.all(Configuration.blockSizeHorizontal * 10),
        child: Stack(children: [
          //habrá que hacer el appbar aquí
          MainScreen(),
        ]),
      ),
    );
  }
}

class TabletLayout extends StatefulWidget {
  @override
  _TabletLayoutState createState() => _TabletLayoutState();
}

class _TabletLayoutState extends State<TabletLayout> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);

    return Container(
      width: Configuration.width * 0.6,
      child: Drawer(
        elevation: 13.0,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, '/profile'),
                            child: Padding(
                              padding: EdgeInsets.all(
                                  Configuration.blockSizeHorizontal * 3),
                              child: CircleAvatar(
                                  radius: Configuration.blockSizeHorizontal * 6,
                                  child: Text(_userstate.user.usuario
                                      .substring(0, 1)
                                      .toUpperCase())),
                            )),
                        SizedBox(width: Configuration.safeBlockHorizontal * 2),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(_userstate.user.usuario,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              Text('Level 10',
                                  style: TextStyle(color: Colors.lime))
                            ])
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.explore),
                    title: Text('Explore'),
                    onTap: () {
                      Navigator.pushNamed(context, '/explore');
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.brain),
                    title: Text('Brain'),
                    onTap: () {
                      Navigator.pushNamed(context, '/learn');
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Divider(),
            ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
            ListTile(
                leading: Icon(Icons.help), title: Text('Help and Feedback'))
          ],
        ),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: Configuration.width,
          height: Configuration.height * 0.25,
          decoration: BoxDecoration(
              color: Configuration.secondarycolor,
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
        ),

      ],
    );
  }
}
