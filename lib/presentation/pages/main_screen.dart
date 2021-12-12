
import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/action_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/mobx/login_register/login_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/user_bottom_dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/web_view.dart';


import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'commonWidget/stage_card.dart';

class MainScreen extends StatefulWidget {
  MainScreen();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  UserState _userstate;
  LoginState _loginstate;

  Color darken(Color c, [int percent = 0]) {
    assert(0 <= percent && percent <= 100);
    var f = 1 - percent / 100;
    return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(),
        (c.blue * f).round());
  }

  @override
  Widget build(BuildContext context) {
    UserState _userstate = Provider.of<UserState>(context);
    return ListView(
    physics: ClampingScrollPhysics(),
    children: [
      SizedBox(height: Configuration.verticalspacing),
      /*ElevatedButton(onPressed: (){
        scheduleNotification();
      }, child: Text("NOtification")),
      */
      StageCard(stage: _userstate.user.stage),
      SizedBox(height: Configuration.verticalspacing*2),
      AspectRatio(
        aspectRatio: Configuration.buttonRatio,
        child: Container(
          width: Configuration.width,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(Configuration.borderRadius)),
              backgroundColor: Colors.grey.withOpacity(0.6)
            ),
            onPressed: () { 
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)=> WebView(initialUrl:'https://www.amazon.de/-/en/John-Yates-Phd/dp/1781808201/ref=sr_1_1?adgrpid=82460957179&gclid=CjwKCAiAv_KMBhAzEiwAs-rX1Bo6Q8WImFMLs5t4p67OFcglUBMhHJkNp_cCg2N-GjbcYsLJ2UlynxoCYmoQAvD_BwE&hvadid=394592758731&hvdev=c&hvlocphy=20297&hvnetw=g&hvqmt=b&hvrand=2610658949964129015&hvtargid=kwd-488309045472&hydadcr=24491_1812059&keywords=the+mind+illuminated&qid=1637694427&sr=8-1' ,javascriptMode: JavascriptMode.unrestricted))
              ); 
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:[
                Text('Get The Mind Illuminated',style:Configuration.text('small',Colors.black)),
                Image(image:AssetImage('assets/tenstages-book.png'),fit: BoxFit.cover)
              ]
            ),
          ),
        ),
      ),
      SizedBox(height: Configuration.verticalspacing*2),
      _Timeline(),
      SizedBox(height: Configuration.verticalspacing),

    ]);
  }
}

class _Timeline extends StatefulWidget {
  bool isTablet;

  _Timeline({this.isTablet = false});

  @override
  __TimelineState createState() => __TimelineState();
}

class __TimelineState extends State<_Timeline> {
  UserState _userstate;
  String mode = 'Today'; 
  List<User> users = new List.empty(growable: true);
  var states = ['Today','This week'];
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies()async {
    super.didChangeDependencies();
    _userstate = Provider.of<UserState>(context);
    users = await _userstate.getUsersList(_userstate.user.following);
  }

  //Pasar ESTO FUERA !!! HACERLO SOLO UNA VEZ !!
  List<Widget> getMessages() { 
      List<UserAction> sortedlist = new List.empty(growable: true);
      
      mode == 'Today' ? sortedlist.addAll(_userstate.user.todayactions) : sortedlist.addAll(_userstate.user.thisweekactions);
      
      sortedlist.sort((a,b) => b.time.compareTo(a.time));

      List<Widget> widgets = new List.empty(growable: true);

      if (sortedlist.length > 0) {
        for (var action in sortedlist) {
          widgets.add(
            GestureDetector(
              onTap: ()=> {
                if(action.user != null){
                  showUserProfile(user:action.user,context:context)
                }
              },
              child: Container(
                margin:EdgeInsets.only(top: Configuration.verticalspacing,left:Configuration.verticalspacing/2),
                width: Configuration.width,
                color: Colors.transparent,
                child: Row(mainAxisAlignment: MainAxisAlignment.start, 
                children: [
                  Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: action.user != null && action.user.image != null ? DecorationImage(image: NetworkImage(action.userimage), fit: BoxFit.fitWidth) :  action.userimage != null ? DecorationImage(image: NetworkImage(action.userimage), fit: BoxFit.fitWidth) : null,
                            color: action.userimage == null ? Configuration.maincolor : null,
                            shape: BoxShape.circle
                          ),
                          width: Configuration.width*0.1,
                          height: Configuration.width*0.1
                          ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            width: Configuration.verticalspacing*2,
                            height: Configuration.verticalspacing*2,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.lightBlue),
                            child: Icon(action.icono, color: Colors.white, size: Configuration.tinicon)),
                        ) 
                      ],
                    ),
                  SizedBox(width: Configuration.verticalspacing),
                  Expanded(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, 
                      mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                      children: [
                        //QUITAR LOS IFS DEL CÓDIGO !!!!
                        Text((action.username == _userstate.user.nombre ? 'You': action.username) + ' ' + action.message,
                            style: Configuration.text('tiny', Colors.black, font: 'Helvetica'),
                            overflow: TextOverflow.fade,
                            ),
                        SizedBox(height: Configuration.verticalspacing/2),
                        Text((mode == 'Today' ? '' : action.day + ' ') +   action.hour,
                            style: Configuration.text('tiny', Configuration.grey, font: 'Helvetica'))
                    ]),
                  )
                ]),
              ),
            ),
          );
          widgets.add(SizedBox(height: 10));
        }
      } else {
        widgets.add(SizedBox(height: Configuration.verticalspacing*2));
        widgets.add(Center(child: Text('No actions done ' + (mode == 'Today' ? 'today' : 'this week'), style: Configuration.text('small', Colors.grey, font: 'Helvetica'))));
      }

     // Timer(Duration(milliseconds: 1), () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent));

      return widgets;
    }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);

    return Container(
        decoration: BoxDecoration(
          color:Colors.white,  
          borderRadius: BorderRadius.circular(16.0), 
          border: Border.all(color: Colors.grey, width: 0.15)
        ),
        child: Column(children: [
          Container(
            padding: EdgeInsets.all(Configuration.smpadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:[ 
                DropdownButton<String>(
                      value: mode,
                      elevation: 16,
                      style: Configuration.text('small', Colors.black),
                      underline: Container(
                        height: 0,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          mode = newValue;
                        });
                      },
                      items: states.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList()
                ),
                RawMaterialButton(
                      elevation: 3.0,
                      fillColor: Configuration.maincolor,
                      child: Container(
                        child: Row(
                          children: [
                            Icon(Icons.leaderboard, color: Colors.white, size: widget.isTablet ? Configuration.tinpadding : Configuration.smicon),
                            Icon(Icons.person, color: Colors.white,size:widget.isTablet ? Configuration.tinpadding : Configuration.smicon)
                          ],
                        ),
                      ),
                      padding: EdgeInsets.all(Configuration.smpadding),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Configuration.borderRadius)),
                      onPressed: () {
                        //HABRA QUE CAMBIAR ESTO
                        widget.isTablet ? 
                        Navigator.pushNamed(context, '/tabletleaderboard').then((value) => setState(() => null)) :
                        Navigator.pushNamed(context, '/leaderboard').then((value) => setState(() => null));
                      },
                    ),
              ]
            ),
          ),
          Container(
            width:Configuration.width,
            height: 0.15,
            color: Colors.grey,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            height:Configuration.height*0.4,
            child: ListView(
              controller: _scrollController,
              children: getMessages()))
        ]));
  }
}
