import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meditation_app/presentation/mobx/actions/meditation_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/meditation_screen.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/learn_screen.dart';
import 'package:meditation_app/presentation/pages/main_screen.dart';
import 'package:meditation_app/presentation/pages/path_screen.dart';
import 'package:meditation_app/presentation/pages/profile_widget.dart';
import 'package:provider/provider.dart';

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
    MeditationState _meditationstate = Provider.of<MeditationState>(context);
    
    Widget chiporText(String text, bool chip){
      Widget g;

      var types = {'Guided':'guided','Free':'free','Games':'games'};

      if (chip){
        g = Chip(label: Text(text, style: Configuration.text('tiny', Colors.black)));
      } else {
        g = Text(text, style: Configuration.text('tiny', Colors.black));
      }

      return GestureDetector(
        onTap: () {
          setState(() {
            _meditationstate.switchtype(types[text]);
          });
        },
        child: g
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Configuration.white,
        bottom: PreferredSize(
            child: currentindex == 2 ?
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Observer(builder: (BuildContext context) {  
                        return chiporText('Free', _meditationstate.currentpage == 0);
                      },),
                      
                      Observer(builder: (BuildContext context) {  
                        return chiporText('Guided', _meditationstate.currentpage == 1);
                      },),
                      
                      Observer(builder: (BuildContext context) {  
                        return chiporText('Games', _meditationstate.currentpage == 2);
                      }),
                      
                    ],
                  ),
                ],
              ):
              Container(
                color: Colors.white,
                height: 1.0,
              ),
            preferredSize: currentindex == 2 ? Size.fromHeight(Configuration.blockSizeVertical* 8) : Size.fromHeight(4.0)),
        leading: Container(
          padding: EdgeInsets.all(4),
          child: Image.asset('assets/logo-no-text.png')
        ),
        
        
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              icon: Icon(Icons.ac_unit),
              color: Colors.black,
              onPressed: () => Navigator.pushNamed(context, '/selectusername')),
          Container(
            padding: EdgeInsets.symmetric(vertical: 4),
            margin: EdgeInsets.only(left: Configuration.medmargin, right: Configuration.bigmargin),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/profile'),
              child: RadialProgress(
                  width: Configuration.safeBlockHorizontal * 0.7,
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
        type: BottomNavigationBarType.fixed,
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
            label:'Practice'
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
            this._c.jumpToPage(index);
          }
        },
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
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

    return Scaffold(
      body: Row(children: [
        NavigationRail(
          onDestinationSelected: (int index) {
            setState(()  {
              this._c.jumpToPage(index);
              currentindex = index;
            });
          },
          minWidth: Configuration.width*0.1,
          labelType: NavigationRailLabelType.selected,
          destinations: <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.home, size: Configuration.smpadding),
                selectedIcon:Icon(Icons.home, color: Configuration.maincolor, size: Configuration.smpadding), 
                label: Text('Home', style: Configuration.tabletText('verytiny', Colors.black)),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.book, size: Configuration.smpadding),
                selectedIcon:Icon(Icons.book, color: Configuration.maincolor, size: Configuration.smpadding), 
                label: Text('Learn',  style: Configuration.tabletText('verytiny', Colors.black)),
              ),
              NavigationRailDestination(
                  icon: Icon(Icons.self_improvement, size: Configuration.smpadding),
                  selectedIcon:Icon(Icons.self_improvement, color: Configuration.maincolor, size: Configuration.smpadding), 
                  label:Text('Practice', style: Configuration.tabletText('verytiny', Colors.black))
              ),
              NavigationRailDestination(
                  icon: Icon(Icons.terrain, size: Configuration.smpadding),
                  selectedIcon:Icon(Icons.terrain, color: Configuration.maincolor, size: Configuration.smpadding), 
                  label:Text('Path', style: Configuration.tabletText('verytiny', Colors.black))
              ),
              NavigationRailDestination(
                  icon: Icon(Icons.person, size: Configuration.smpadding),
                  selectedIcon:Icon(Icons.person, color: Configuration.maincolor, size: Configuration.smpadding), 
                  label:Text('Profile', style: Configuration.tabletText('verytiny', Colors.black))
              ),
            ], 
        selectedIndex: currentindex),  
        Expanded(
          child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _c,
          children: [TabletMainScreen(), TabletLearnScreen(), TabletMeditationScreen(), TabletPathScreen(), TabletProfileScreen()],
        ))
      ])
    );
  }
  
}
