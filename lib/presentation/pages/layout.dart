import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meditation_app/presentation/mobx/actions/meditation_state.dart';
import 'package:meditation_app/presentation/mobx/actions/profile_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/mobx/login_register/login_state.dart';
import 'package:meditation_app/presentation/pages/meditation_screen.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/learn_screen.dart';
import 'package:meditation_app/presentation/pages/main_screen.dart';
import 'package:meditation_app/presentation/pages/messages_screen.dart';
import 'package:meditation_app/presentation/pages/path_screen.dart';
import 'package:meditation_app/presentation/pages/teachers_screen.dart';

import 'package:provider/provider.dart';

import 'commonWidget/profile_widget.dart';

class Layout extends StatelessWidget {
  Layout();

  @override
  Widget build(BuildContext context) {
    //cambiar por orientation builder
       // if (orientation == Orientation.portrait) {
      return MobileLayout();
       // } else {
         // return TabletLayout();
        //}
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
  UserState _userstate;

  @override
  void initState() {
    _c = new PageController(
      initialPage: currentindex,
    );
    
    super.initState();
  }
  
  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _userstate = Provider.of<UserState>(context);
    final _loginstate = Provider.of<LoginState>(context);
    if(_userstate.user==null){
      _userstate.setUser(_loginstate.loggeduser);
    }
    if(_userstate.data == null){
      _userstate.getData();
    }
    
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentBackPressTime;

    _userstate = Provider.of<UserState>(context);
    MeditationState _meditationstate = Provider.of<MeditationState>(context);
    ProfileState _profilestate = Provider.of<ProfileState>(context);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);    

    Widget chiporText(String text, bool chip, int page){
      Widget g;

      var types = {'Guided':'guided','Free':'free','Games':'games'};

      if (chip){
        g = Chip(
          padding: EdgeInsets.all(Configuration.tinpadding),
          label: Text(text, style: Configuration.text('tiny', Colors.black))
        );
      } else {
        g =Chip(
          padding: EdgeInsets.all(Configuration.tinpadding),
          label: Text(text, style: Configuration.text('tiny', Colors.black)), 
          backgroundColor: Colors.white, 
          elevation: 0.0
        );
      }

      return GestureDetector(
        onTap: () {
          setState(() {
            _meditationstate.switchpage(page);
          });
        },
        child: g
      );
    }


    List<BottomNavigationBarItem> bottomItems(){

      return [
        BottomNavigationBarItem(
          icon: Icon(Icons.home,size: Configuration.smicon),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book,size: Configuration.smicon),
          label: 'Learn',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.self_improvement,size: Configuration.smicon),
          label:'Practice'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.terrain,size: Configuration.smicon),
          label: 'Path',
        )
      ];
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: Configuration.width > 500 ? 80 : 50,
        backgroundColor: Configuration.white,
        bottom: PreferredSize(
            child: currentindex == 2 ?
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // HACEN FALTA 3 OBSERVERS ???
                      Observer(builder: (BuildContext context) {  
                        return chiporText('Free', _meditationstate.currentpage == 0, 0);
                      }),

                      Observer(builder: (BuildContext context) {  
                        return chiporText('Guided', _meditationstate.currentpage == 1, 1);
                      }),

                      Observer(builder: (BuildContext context) {  
                        return chiporText('Games', _meditationstate.currentpage == 2, 2);
                      }),
                    ],
                  ),
                  SizedBox(height: Configuration.verticalspacing/2),
                  Container(
                    color: Colors.grey,
                    height: 1.0,
                  )
                ],
              ):
              Container(
                color: Colors.grey,
                height: 1.0,
              ),
            preferredSize: 
            currentindex == 2 ? Size.fromHeight(60) : Size.fromHeight(4.0)
            ),
        leadingWidth: Configuration.width > 500 ? 90 : 50,
        leading: GestureDetector(
          onTap: (){
            this._c.jumpToPage(0);
          },
          child: Container(
            child: Image.asset('assets/logo-no-text.png')
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          MessagesIcon(),
          SizedBox(width: Configuration.verticalspacing),
          Stack(
            alignment:Alignment.center,
            children: [
              IconButton(
                color: Colors.black,
                icon: Icon(Icons.bug_report,  size: Configuration.smicon),
                onPressed: ()=> Navigator.pushNamed(context, '/requests').then((value) => setState((){})),
              ),
              _userstate.user.notifications.where((element) => element.seen != null && !element.seen).length > 0 ?
              Positioned(
                top: 5,
                right: 5,
                child:  Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red
                  ),
                  child: Text(_userstate.user.notifications.where((element) => !element.seen).length.toString(),style: Configuration.text('small', Colors.white))
                )) : Container()
            ],
          ),
          
          SizedBox(width: Configuration.verticalspacing),
        
          Container(
            margin:EdgeInsets.only(
              right: Configuration.width > 500 ? Configuration.tinpadding : 0,
              top: 2,
              bottom: 2
            ),
            child: ProfileCircle(
              userImage: _userstate.user.image, 
              onTap: ()=>  Navigator.pushNamed(context, '/profile').then((value) => setState(()=>{}))
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey, width: 0.5))
        ),
        child: BottomNavigationBar(
          elevation: 2.0,
          selectedLabelStyle: Configuration.text("tiny", Configuration.maincolor),
          unselectedLabelStyle: Configuration.text("tiny", Colors.grey),
          unselectedItemColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          items: 
          _userstate.user.isTeacher() ? 
            bottomItems() + [
            BottomNavigationBarItem(
              icon: Icon(Icons.school,size: Configuration.smicon),
              label: 'Teacher',
            )] : bottomItems()
          ,
          currentIndex: currentindex,
          selectedItemColor: Configuration.maincolor,
          onTap: (int index) {
            {
              this._c.jumpToPage(index);
            }
          },
        ),
      ),
      body: WillPopScope(
        onWillPop:(){
          print('onpop');
          DateTime now = DateTime.now();
          if (currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 5)) {
            currentBackPressTime = now;
             ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.fixed,
                  content: Container(
                    padding: EdgeInsets.all(12.0),
                    child: Text('Press back two times to exit the app', style: Configuration.text('small', Colors.white))
                  ),
                ),
              );
            return Future.value(false);
          }
          return Future.value(true);
        },
        child: Container(
          padding: EdgeInsets.only(right: Configuration.smpadding,left: Configuration.smpadding),
          color: Configuration.lightgrey,
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _c,

            onPageChanged: (newPage) {
              setState(() {
                currentindex = newPage;
              });
            },
            children: [MainScreen(), LearnScreen(), MeditationScreen(), PathScreen(), TeachersManagement()],
          ),
        ),
      ),
    );
  }
}



/*
class TabletLayout extends StatefulWidget {
  @override
  _TabletLayoutState createState() => _TabletLayoutState();
}

class _TabletLayoutState extends State<TabletLayout> {
  Widget child;
  int currentindex = 0;
  PageController _c;
  UserState _userstate;

  @override
  void initState() {
    _c = new PageController(
      initialPage: currentindex,
    );
    super.initState();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _userstate = Provider.of<UserState>(context);
    final _loginstate = Provider.of<LoginState>(context);

    if(_userstate.user==null && _loginstate.loggeduser != null){
      _userstate.setUser(_loginstate.loggeduser);
    }
    Configuration().init(context);
  }

  @override
  Widget build(BuildContext context) {

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
          children: [TabletMainScreen(), LearnScreen(), TabletMeditationScreen(), TabletPathScreen(), TabletProfileScreen()],
        ))
      ])
    );
  }
  
}
*/