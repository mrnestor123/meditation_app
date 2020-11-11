import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meditation_app/login_injection_container.dart';
import 'package:meditation_app/presentation/mobx/actions/lesson_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/learn/brain_widget.dart';
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
    'icon': FontAwesomeIcons.brain,
    'text': 'Learn',
    'route': '/brain',
    'title': 'Learn'
  },
  // {
  //   'icon': FontAwesomeIcons.brain,
  //   'text': 'Brain',
  //   'route': '/brain',
  //   'title': 'Brain'
  // },
  // {'icon': Icons.chat, 'text': 'Chat', 'route': '/main', 'title': 'Chat'},
];

class ContainerAnimated extends StatefulWidget {
  const ContainerAnimated({Key key}) : super(key: key);

  @override
  _AnimatedState createState() => _AnimatedState();
}

class _AnimatedState extends State<ContainerAnimated> {
  //bool showstages;
  bool sidebarOpen = false;
  bool scrolled = false;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  String currentRoute = '/main';
  String title = 'Time to wake up';
  var _controller = ScrollController();

  Widget sidebar(_userstate) {
    final _loginstate = Provider.of<UserState>(context);
    Configuration().init(context);
    return Container(
        padding: EdgeInsets.only(top: 60, bottom: 60, left: 50),
        color: Configuration.maincolor,
        //decoration: BoxDecoration(image: DecorationImage(image: AssetImage('/images/cascadita.jpg'),fit: BoxFit.cover)) ,
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
                    Text(_userstate.user.usuario,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    Text('Level 10', style: TextStyle(color: Colors.lime))
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
                GestureDetector(
                    onTap: () {
                      _loginstate.logout();
                      Navigator.pushNamed(context, '/welcome');
                    },
                    child: Text('Log out', style: TextStyle(color: Colors.red)))
              ],
            )
          ],
        ));
  }

  Widget switchMenu(_controller) {
    switch (currentRoute) {
      case '/main':
        return MainScreen(controller: _controller);
      case '/meditate':
        return LearnMeditation(controller: _controller);
      case '/brain':
        return Provider(
            create: (context) => sl<LessonState>(),
            child: BrainScreen(controller: _controller));
    }
    return Container();
  }

  @override
  void initState() {
    super.initState();

    // set up listener here
    _controller.addListener(() {
      if (_controller.position.pixels < 50) {
        setState(() {
          scrolled = false;
        });
      } else {
        setState(() {
          scrolled = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // showstages = widget.menuindex =='Meditation'|| widget.menuindex == 'Brain';
    final _userstate = Provider.of<UserState>(context);

    return Scaffold(
      backgroundColor: Configuration.whitecolor,
      body: Stack(
        children: <Widget>[
          sidebar(_userstate),
          GestureDetector(
            onTap: () => sidebarOpen
                ? setState(() {
                    xOffset = 0;
                    yOffset = 0;
                    scaleFactor = 1;
                    sidebarOpen = false;
                  })
                : null,
            child: AnimatedContainer(
              decoration: BoxDecoration(
                borderRadius: sidebarOpen
                    ? BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30))
                    : null,
                color: Colors.grey[500],
              ),
              transform: Matrix4.translationValues(xOffset, yOffset, 0)
                ..scale(scaleFactor)
                ..rotateY(sidebarOpen ? -0.1 : 0),
              duration: Duration(milliseconds: 250),
              child: Column(
                children: <Widget>[
                  Container(
                    height: Configuration.height * 0.15,
                    padding: EdgeInsets.all(6),
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
                            onTap: () =>
                                Navigator.pushNamed(context, '/profile'),
                            child: CircleAvatar(child: Text('ERN')))
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: scrolled
                                ? Radius.circular(0)
                                : Radius.circular(25))),
                    child: switchMenu(_controller),
                  )),
                  /*currentRoute == '/meditate' || currentRoute == '/brain'
                      ? Container(
                        width: Configuration.width,
                        color: Colors.transparent,
                        child: FloatingActionButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/premeditation'),
                          child: Icon(Icons.timer),
                          backgroundColor: Configuration.maincolor,
                        ),
                      )
                      : Container(),*/
                  currentRoute == '/meditate' || currentRoute == '/brain'
                      ? BottomMenu(
                          selectedindex: _userstate.user.stagenumber - 1,
                          controller: _controller)
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//Variables for bottom menu
List<Map> menuitems = [
  {'icon': FontAwesomeIcons.diceOne, 'title': "Stage 1", 'index': 0},
  {'icon': FontAwesomeIcons.diceTwo, 'title': "Stage 2", 'index': 1},
  {'icon': FontAwesomeIcons.diceThree, 'title': "Stage 3", 'index': 2},
  {'icon': FontAwesomeIcons.diceFour, 'title': "Stage 4", 'index': 3},
  {'icon': FontAwesomeIcons.diceFive, 'title': "Stage 5", 'index': 4},
  {'icon': FontAwesomeIcons.diceSix, 'title': "Stage 6", 'index': 5},
  {'icon': Icons.plus_one, 'title': "Stage 7", 'index': 6},
  {'icon': Icons.plus_one, 'title': 'Stage 8', 'index': 7},
  {'icon': Icons.plus_one, 'title': 'Stage 9', 'index': 8},
  {'icon': Icons.plus_one, 'title': 'Stage 10', 'index': 9}
];

class BottomMenu extends StatefulWidget {
  int selectedindex;
  ScrollController controller;

  BottomMenu({Key key, this.selectedindex, this.controller}) : super(key: key);

  @override
  _BottomMenuState createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  int _selectedIndex;
  var _userstate;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedindex;
  }

  /* @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);
    return BottomAppBar(
      clipBehavior: Clip.antiAlias,
      notchMargin: 2.0,
      shape: CircularNotchedRectangle(),
      child: BottomNavigationBar(
        unselectedItemColor: Colors.black,
        items: menuitems,
        currentIndex: _selectedIndex,
        selectedItemColor: Configuration.maincolor,
        onTap: (index) => setState(() {
          widget.controller.animateTo(0,
              duration: Duration(milliseconds: 500), curve: Curves.ease);
          _userstate.changeBottomMenu(index);
          _selectedIndex = index;
        }),
      ),
    );
  }
*/

  List<Widget> buildItems() {
    List<Widget> result = new List();
    for (var e in menuitems) {
      result.add(GestureDetector(
        onTap: () => setState(() {
          if (_userstate.user.stagenumber >= e['index'] +1) {
            widget.controller.animateTo(0,duration: Duration(milliseconds: 500), curve: Curves.ease);
            _userstate.changeBottomMenu(e['index']);
            _selectedIndex = e['index'];
          }
        }),
        child: Container(
          width: Configuration.width * 0.15,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                e['icon'],
                color: e['index'] == _selectedIndex
                    ? Configuration.maincolor
                    : _userstate.user.stagenumber >= e['index']+1 ? Colors.black : Colors.grey,
                size: Configuration.height * 0.04,
              ),
              e['index'] == _selectedIndex
                  ? Text(
                      e['title'],
                      style: TextStyle(color: Configuration.maincolor),
                    )
                  : Container()
            ],
          ),
        ),
      ));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);
    return Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.symmetric(
                horizontal: Configuration.safeBlockHorizontal * 4),
            height: Configuration.height * 0.08,
            width: Configuration.width,
            decoration: BoxDecoration(color: Colors.grey[100]),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: buildItems()),
            )),
      ],
    );
  }
}
