import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meditation_app/presentation/mobx/actions/lesson_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/learn/brain_widget.dart';
import 'package:meditation_app/presentation/pages/learn_screen.dart';
import 'package:meditation_app/presentation/pages/main_screen.dart';
import 'package:meditation_app/presentation/pages/path_screen.dart';
import 'package:provider/provider.dart';

import '../../login_injection_container.dart';

class Layout extends StatelessWidget {
  Layout();

  @override
  Widget build(BuildContext context) {
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
  MobileLayout();

  @override
  _MobileLayoutState createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  Widget child;
  int currentindex = 0;

  @override
  Widget build(BuildContext context) {
    Configuration().init(context);

    switch (currentindex) {
      case 0:
        child = MainScreen();
        break;
      case 1:
        child = LearnScreen();
        break;
      case 2:
        child = PathScreen();
        break;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Configuration.maincolor,
        bottom: PreferredSize(
            child: Container(
              color: Colors.white,
              height: 1.0,
            ),
            preferredSize: Size.fromHeight(4.0)),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              icon: Icon(Icons.account_circle, color: Colors.white),
              iconSize: Configuration.medicon,
              onPressed: null)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: Configuration.text("tiny", Configuration.maincolor),
        unselectedLabelStyle: Configuration.text("tiny", Colors.white),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.terrain),
            label: 'Path',
          ),
        ],
        currentIndex: currentindex,
        selectedItemColor: Configuration.maincolor,
        onTap: (int index) {
          {
            setState(() {
              currentindex = index;
            });
          }
        },
      ),
      body: Container(
        height: Configuration.height,
        width: Configuration.width,
        color: Configuration.maincolor,
        padding: EdgeInsets.symmetric(horizontal: Configuration.medpadding),
        child: child,
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
