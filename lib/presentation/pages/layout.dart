import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meditation_app/presentation/mobx/actions/meditation_state.dart';
import 'package:meditation_app/presentation/mobx/actions/profile_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/mobx/login_register/login_state.dart';
import 'package:meditation_app/presentation/pages/mainpages/game_screen.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/mainpages/social_screen.dart';
import 'package:meditation_app/presentation/pages/more_screen.dart';
import 'package:meditation_app/presentation/pages/welcome/loading_widget.dart';

import 'package:provider/provider.dart';

import 'commonWidget/profile_widget.dart';
import 'mainpages/explore_screen.dart';
import 'mainpages/home_screen.dart';
import 'mainpages/meditation_screen.dart';
import 'mainpages/stage_screen.dart';

class Layout extends StatelessWidget {
  Layout();

  @override
  Widget build(BuildContext context) {
    return MobileLayout();
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
  bool gotData = false;
  int currentVersion = 8;

  int gamespage = 3;

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
    
    if(_userstate.user == null){
      _userstate.setUser(_loginstate.loggeduser);
    }
    
    if(_userstate.gettingData != null){
      _userstate.gettingData.whenComplete(() => setState((){gotData = true; checkUpdate();}));
    } else {
      _userstate.getData();
      _userstate.gettingData.whenComplete(() => setState((){gotData = true; checkUpdate();}));
    }
  }


  void checkUpdate(){
    if(
      _userstate.data != null  && _userstate.data.settings != null && _userstate.data.settings.requiredUpdate != null && 
      _userstate.data.settings.requiredUpdate && _userstate.data.settings.version > currentVersion
    ){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => UpdatePage()),
        (Route<dynamic> route) => false,
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    DateTime currentBackPressTime;
    _userstate = Provider.of<UserState>(context);
    MeditationState _meditationstate = Provider.of<MeditationState>(context);
    
    Widget chiporText(String text, bool chip, int page){
      Widget g;

      if (chip){
        g = Chip(
          padding: EdgeInsets.all(Configuration.tinpadding),
          label: Text(text, style: Configuration.text('tiny', Colors.black))
        );
      } else {
        g = Chip(
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
          icon: Icon(Icons.landscape,size: Configuration.smicon),
          label: 'Stages',
        ),
        
        BottomNavigationBarItem(
          label: 'Explore',
          icon: Icon(Icons.explore, size: Configuration.smicon),
        ),
        
        BottomNavigationBarItem(
          label: 'Timer',
          icon: Icon(Icons.timer, size: Configuration.smicon),
        )
      ];
    }

    return Scaffold(
      body: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            extendBodyBehindAppBar: false,
            
            appBar: AppBar(
                systemOverlayStyle: SystemUiOverlayStyle(
                // Status bar color
                statusBarColor: Colors.transparent, 
                statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
                statusBarBrightness: Brightness.light, // For iOS (dark icons)
              ),
              elevation: 0.0,
              toolbarHeight: Configuration.width > 500 ? 80 : 50,
              backgroundColor: Configuration.white,
              bottom: PreferredSize(
                  child: currentindex == gamespage ?
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // HACEN FALTA 3 OBSERVERS ???
                            Observer(builder: (BuildContext context) {  
                              return chiporText('Timer', _meditationstate.currentpage == 0, 0);
                            }),

                            Observer(builder: (BuildContext context) {  
                              return chiporText('Games', _meditationstate.currentpage == 1, 1);
                            }),
                          ],
                        ),
                        SizedBox(height: Configuration.verticalspacing/2),
                        Container(
                          color: Colors.grey,
                          height: 1.0,
                        )
                      ]
                    ) :
                    Container(
                      color: Colors.grey,
                      height: 1.0,
                    ),
                  preferredSize: //Size.fromHeight(4.0)
                  currentindex == gamespage ? Size.fromHeight(60) : Size.fromHeight(4.0)
                ),
              //leadingWidth: Configuration.width*0.5,
              //centerTitle: true,
              title:Text(
                'TenStages',
                style: Configuration.text('subtitle', Colors.black),
                textAlign: TextAlign.center,
              ),
              automaticallyImplyLeading: false,
              actions: [
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
                      top: 2,
                      right: 5,
                      child:  Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red
                        ),
                        child: Text(_userstate.user.notifications.where((element) => !element.seen).length.toString(),style: Configuration.text('tiny', Colors.white))
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
                )
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
                items: bottomItems(),
                currentIndex: currentindex,
                selectedItemColor: Configuration.maincolor,
                onTap: (int index) {
                  if(!gotData){
                    return;
                  }
                  this._c.jumpToPage(index);
                }
              ),
            ),
            body: WillPopScope(
              onWillPop:(){
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
                padding:  EdgeInsets.only(top:0),
                color: Configuration.lightgrey,
                child: !gotData ?
                  Center(
                  child: CircularProgressIndicator(
                    color: Configuration.maincolor,
                  )) :
                 PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _c,
                  onPageChanged: (newPage) {
                    setState(() {
                      currentindex = newPage;
                    });
                  },
                  children: [ MainScreen(), StageScreen(), ExploreScreen(),  MeditationScreen()],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DateTime currentBackPressTime;

Future checkPop( context){
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
}
