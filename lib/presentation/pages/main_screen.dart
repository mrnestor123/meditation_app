
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/action_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/profile_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/mobx/login_register/login_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/profile_widget.dart';
import 'package:meditation_app/presentation/pages/commonWidget/progress_bar.dart';
import 'package:meditation_app/presentation/pages/commonWidget/user_bottom_dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/web_view.dart';


import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/contentWidgets/content_view.dart';
import 'package:meditation_app/presentation/pages/learn_screen.dart';
import 'package:meditation_app/presentation/pages/meditation_screen.dart';
import 'package:meditation_app/presentation/pages/stage/path.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../domain/entities/content_entity.dart';
import 'commonWidget/radial_progress.dart';
import 'commonWidget/stage_card.dart';

class MainScreen extends StatefulWidget {
  MainScreen();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  UserState _userstate;
  LoginState _loginstate;

  List<Content> newContent = new List.empty(growable:true);

  Color darken(Color c, [int percent = 0]) {
    assert(0 <= percent && percent <= 100);
    var f = 1 - percent / 100;
    return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(),
        (c.blue * f).round());
  }

  @override 
  void initState(){
    super.initState();
  }

  @override 
  void didChangeDependencies(){
    super.didChangeDependencies();
    _userstate = Provider.of<UserState>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      
      // HAY QUE VER QUE PASA CON GUARDAR LOS DATOS !!
      if(_userstate.data != null && (_userstate.user.version == null || _userstate.user.version < _userstate.data.lastVersion.versionNumber)){
        _userstate.setVersion(_userstate.data.lastVersion.versionNumber);

       showDialog(
         context: context, 
         builder: (context){
           return AbstractDialog(
             content: Container(
               decoration: BoxDecoration(
                 color:Colors.white,
                 borderRadius: BorderRadius.circular(Configuration.borderRadius/2)
               ),
               child: Column(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   Container(
                     width:Configuration.width,
                     decoration: BoxDecoration(
                        color:Configuration.maincolor,
                        borderRadius: BorderRadius.vertical(top:Radius.circular(Configuration.borderRadius/2)) 
                    ),
                     padding: EdgeInsets.all(Configuration.smpadding),
                     child: Center(
                       child: Text('Version ' + _userstate.data.lastVersion.versionNumber.toString(),  
                       style:Configuration.text('medium',Colors.white)),
                     )
                   ),
                   SizedBox(height:Configuration.verticalspacing),
                   Padding(
                     padding: EdgeInsets.symmetric(horizontal: Configuration.smpadding),
                     child: Text(_userstate.data.lastVersion.description, style:Configuration.text('smallmedium',Colors.black), textAlign:TextAlign.center),
                   ),
                   SizedBox(height:Configuration.verticalspacing),
                   Container(
                     width:Configuration.width,
                     color: Configuration.maincolor,
                     padding: EdgeInsets.all(Configuration.smpadding),
                     child: Text('Functionalities',style:Configuration.text('smallmedium',Colors.white))
                   ),
                   SizedBox(height:Configuration.verticalspacing/2),
                   Container(
                     padding:EdgeInsets.symmetric(horizontal: Configuration.smpadding),
                     child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: 
                      _userstate.data.lastVersion.content.map((e) {
                       return Container(
                         margin: EdgeInsets.only(top:Configuration.verticalspacing),
                         child: Row(children: [
                           Container(
                             height: Configuration.verticalspacing,
                             width: Configuration.verticalspacing,
                             decoration: BoxDecoration(
                               shape: BoxShape.circle,
                               color:Colors.black
                             ),
                           ),
                           SizedBox(width: Configuration.verticalspacing),
                           Expanded(child: 
                            Text(e['text'],style:Configuration.text('small',Colors.black))
                           )
                         ]),
                       );
                     }).toList()
                     ),
                   ),
                   SizedBox(height:Configuration.verticalspacing*2)
                    /*
                   Container(
                     padding:EdgeInsets.symmetric(horizontal: Configuration.smpadding),
                     child: Text('Make sure you have downloaded the last version from the store', style: Configuration.text('small',Colors.grey))
                    ),*/
                   //SizedBox(height:Configuration.verticalspacing),
                 ],
               ),
             )
           );
         });
    
      }
    });
  
  }

  void onBack(value){ setState(() {});}

  @override
  Widget build(BuildContext context) {
    return ListView(
    physics: ClampingScrollPhysics(),
    children: [
      SizedBox(height: Configuration.verticalspacing),
      Container(
        margin:EdgeInsets.symmetric(horizontal: Configuration.smpadding),
        padding: EdgeInsets.all(Configuration.smpadding),
        decoration: BoxDecoration(
          color: Configuration.maincolor,
          borderRadius: BorderRadius.circular(Configuration.borderRadius/2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: Configuration.width*0.7,
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      Text('You are on stage ' + _userstate.user.stagenumber.toString(), style: Configuration.text('smallmedium',Colors.white),),
                      SizedBox(height: Configuration.verticalspacing/2),
                      Text(
                        _userstate.user.stage.description, 
                        style: Configuration.text('small',Colors.white,font:'Helvetica'),
                        overflow: TextOverflow.clip,
                      )
                    ],
                  ),
                ),

                RadialProgress(
                  width: 4,
                  goalCompleted: _userstate.user.percentage/100,
                  progressColor: Colors.lightBlue,
                  progressBackgroundColor: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(Configuration.tinpadding),
                    child: Center(
                      child: Text(
                        _userstate.user.percentage.toString() + '%',
                        style: Configuration.text('tiny', Colors.white)
                      ),
                    ),
                  ),
                )

              ],
            ),
            SizedBox(height: Configuration.verticalspacing*2),
            Container(
              constraints: BoxConstraints(
                minHeight: Configuration.height*0.12
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        height: Configuration.height*0.12,
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        placeholder: (context, url) => Container(
                          color: Configuration.maincolor,
                        ),
                        imageUrl: _userstate.user.stage.shortimage,
                        fit: BoxFit.cover
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Configuration.verticalspacing),
            //StageProgressBar(user:_userstate.user),
            //SizedBox(height: Configuration.verticalspacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                    width: Configuration.width*0.25,
                   
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Configuration.lightgrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)
                        )
                      ),
                      onPressed: ()=>{
                         Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StageView(
                              stage: _userstate.data.stages[_userstate.user.stagenumber-1],
                            )
                          ),
                        ).then((value) =>
                          setState(() {
                            print('SETTING STATE');
                          })
                        )
                      }, 
                      child:Text('Learn',style: Configuration.text('tiny', Colors.black)),
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Container(
                    width: Configuration.width*0.25,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Configuration.lightgrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)
                        )
                      ),
                      onPressed: ()=>{Navigator.pushNamed(context, '/progress')}, 
                      child:Text('Objectives',style: Configuration.text('tiny', Colors.black)),
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Container(
                    width: Configuration.width*0.25,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Configuration.lightgrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)
                        )
                      ),
                      onPressed: ()=>{
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImagePath(stage: _userstate.user.stage)
                          )
                        )
                      }, 
                      child: Text('Path',style: Configuration.text('tiny', Colors.black),) 
                    ),
                  ),
                ),
              ],
            )
          ]
        ),
      ),

      /*
      _userstate.data != null && _userstate.data.newContent.length > 0 ? 
      Container(
        margin: EdgeInsets.only(top: Configuration.verticalspacing*2),
        decoration: BoxDecoration(
         //color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(Configuration.borderRadius)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: Configuration.smpadding),
              child: Text('New content', style: Configuration.text('small',Colors.black))),
            SizedBox(height: Configuration.verticalspacing),
            Container(
              height: Configuration.height*0.15,
              width: Configuration.width,
              constraints: BoxConstraints(
                minWidth: Configuration.width
              ),
              child: ListView.builder(
                padding:EdgeInsets.all(0),
                physics: ClampingScrollPhysics(),
                itemCount: _userstate.data.newContent.length,
                scrollDirection: Axis.horizontal, 
                itemBuilder: (BuildContext context, int index) {  
                  Content c = _userstate.data.newContent[index];
                  // HAY QUE CAMBIAR CLICKABLESQUARE POR CONTENTSQUARE !>!!
                  return  Container(
                    margin: EdgeInsets.only(
                      right: index == _userstate.data.newContent.length-1 ? Configuration.smpadding:0,
                      left: Configuration.smpadding),
                    width: Configuration.width*0.33,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClickableSquare(
                        selected: true,
                        border: true,
                        text: c.title,
                        blocked: _userstate.user.isContentBlocked(c),
                        blockedtext: '',
                        image: c.image,
                        onTap:(){
                          Navigator.push(context, 
                            MaterialPageRoute(builder: (context){
                              return ContentFrontPage(
                                content: c,
                                then:onBack
                              );
                            })
                          );
                        }    
                      ),
                    ),
                  );
                }, 
              ),
            ),
          ],
        ),
      ): Container(),
      */

      /*
      Center(
        child: Text('You are currently on stage ' + ,
          style: Configuration.text('smallmedium',Colors.black),
        ),
      ),*/


     // SizedBox(height: Configuration.verticalspacing),
      
      /*ElevatedButton(onPressed: (){
        scheduleNotification();
      }, child: Text("NOtification")),
      */
      //StageCard(stage: _userstate.user.stage),
      
      SizedBox(height: Configuration.verticalspacing*2),
      
      Container(
        padding: EdgeInsets.symmetric(horizontal: Configuration.smpadding),
        child: Column(
          children: [
            Container(
              child: AspectRatio(
                aspectRatio: Configuration.buttonRatio,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: Configuration.medpadding),
                    shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(Configuration.borderRadius/2)),
                    primary: Colors.grey.withOpacity(0.6)
                  ),
                  onPressed: () { 
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> Scaffold(
                        appBar:AppBar(backgroundColor: Colors.white, leading: CloseButton(color:Colors.black), elevation:0),
                        body:WebView(initialUrl:'https://www.amazon.de/-/en/John-Yates-Phd/dp/1781808201/ref=sr_1_1?adgrpid=82460957179&gclid=CjwKCAiAv_KMBhAzEiwAs-rX1Bo6Q8WImFMLs5t4p67OFcglUBMhHJkNp_cCg2N-GjbcYsLJ2UlynxoCYmoQAvD_BwE&hvadid=394592758731&hvdev=c&hvlocphy=20297&hvnetw=g&hvqmt=b&hvrand=2610658949964129015&hvtargid=kwd-488309045472&hydadcr=24491_1812059&keywords=the+mind+illuminated&qid=1637694427&sr=8-1' ,javascriptMode: JavascriptMode.unrestricted),
                      ))
                    ); 
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Text('Get The Mind Illuminated',style:Configuration.text('small',Colors.white)),
                      Image(image:AssetImage('assets/tenstages-book.png'),fit: BoxFit.cover)
                    ]
                  ),
                ),
              ),
            ),
            SizedBox(height: Configuration.verticalspacing*2),
            AspectRatio(
              aspectRatio: Configuration.buttonRatio,
              child: ElevatedButton(
                onPressed:(){
                  Navigator.pushNamed(context, '/teachers');
                },
                child: Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Find a teacher',style:Configuration.text('small',Colors.white)
                    ),
                    Row(
                      children: [
                        Icon(Icons.group,
                          size: Configuration.smicon,
                          color: Colors.white,
                        ),
                        SizedBox(width:Configuration.verticalspacing/2),
                        Icon(Icons.school,
                          size:Configuration.smicon,
                          color:Colors.white
                        )
                      ],
                    )
                  ],
                ),
                style:ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: Configuration.medpadding),
                  primary: Configuration.maincolor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Configuration.borderRadius/2))
                )
              ),
            ),
            SizedBox(height:Configuration.verticalspacing*2),
            _Timeline(),
            SizedBox(height: Configuration.verticalspacing),

          ],
        ),
      ),
      
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
  ProfileState _profileState;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies()async {
    super.didChangeDependencies();
    _userstate = Provider.of<UserState>(context);
    _profileState = Provider.of<ProfileState>(context);
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
                  showUserProfile(user:action.user)
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
                        ProfileCircle(
                          userImage: action.userimage,
                          width: 40,
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
                      fillColor: Colors.lightBlue,
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
              physics: ClampingScrollPhysics(),
              controller: _scrollController,
              children: getMessages()))
        ]));
  }
}
