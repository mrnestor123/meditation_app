import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meditation_app/presentation/mobx/actions/lesson_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/meditation_screen.dart';
import 'package:meditation_app/presentation/pages/more_screen.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/learn/brain_widget.dart';
import 'package:meditation_app/presentation/pages/learn_screen.dart';
import 'package:meditation_app/presentation/pages/main_screen.dart';
import 'package:meditation_app/presentation/pages/path_screen.dart';
import 'package:provider/provider.dart';

import '../../login_injection_container.dart';
import 'commonWidget/radial_progress.dart';

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
  PageController _c;

  @override
  void initState() {
    _c = new PageController(
      initialPage: currentindex,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Configuration().init(context);
    UserState _userstate = Provider.of<UserState>(context);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Configuration.white,
        bottom: PreferredSize(
            child: Container(
              color: Colors.white,
              height: 1.0,
            ),
            preferredSize: Size.fromHeight(4.0)),
        leading: IconButton(
            icon: Icon(Icons.logout,
                color: Colors.red, size: Configuration.smicon),
            onPressed: () async {
              await _userstate.logout();
              Navigator.pushReplacementNamed(context, '/welcome');
            }),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              icon: Icon(Icons.ac_unit),
              color: Colors.black,
              onPressed: () => Navigator.pushNamed(context, '/selectusername')),
          Container(
            margin: EdgeInsets.only(
                left: Configuration.medmargin, right: Configuration.bigmargin),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/profile'),
              child: RadialProgress(
                  width: Configuration.safeBlockHorizontal * 1,
                  progressColor: Configuration.maincolor,
                  goalCompleted: 1,
                  child: CircleAvatar(
                    backgroundColor: _userstate.user.image == null
                        ? Configuration.lightgrey
                        : Colors.transparent,
                    backgroundImage: _userstate.user.image == null
                        ? null
                        : NetworkImage(_userstate.user.image) ,
                        //: FileImage(File(_userstate.user.image)),
                  )),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 20.0,
        selectedLabelStyle: Configuration.text("tiny", Configuration.maincolor),
        unselectedLabelStyle: Configuration.text("tiny", Colors.grey),
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.shifting,
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
            icon: Icon(Icons.self_improvement),
            label:'Meditate'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.terrain),
            label: 'Path',
          )
        ],
        currentIndex: currentindex,
        selectedItemColor: Configuration.maincolor,
        onTap: (int index) {
          {
            this._c.animateToPage(index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut);
          }
        },
      ),
      body: PageView(
        controller: _c,
        onPageChanged: (newPage) {
          setState(() {
            currentindex = newPage;
          });
        },
        children: [MainScreen(), LearnScreen(), MeditationScreen(), PathScreen()],
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
