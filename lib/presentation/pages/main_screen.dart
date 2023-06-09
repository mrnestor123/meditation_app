
import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/profile_state.dart';
import 'package:meditation_app/presentation/mobx/actions/requests_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/mobx/login_register/login_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/alert_dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/beautiful_container.dart';
import 'package:meditation_app/presentation/pages/commonWidget/profile_widget.dart';
import 'package:meditation_app/presentation/pages/commonWidget/user_bottom_dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/week_list.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/profile_widget.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/content_entity.dart';
import '../../domain/entities/request_entity.dart';
import 'commonWidget/start_button.dart';

class MainScreen extends StatefulWidget {
  MainScreen();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  UserState _userstate;
  LoginState _loginstate;
  ProfileState _profileState;

  List<Content> newContent = new List.empty(growable:true);

  Color darken(Color c, [int percent = 0]) {
    assert(0 <= percent && percent <= 100);
    var f = 1 - percent / 100;
    return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(), (c.blue * f).round());
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
      if(_userstate.user != null && !_userstate.user.settings.askedProgressionQuestions){
        Future.delayed(Duration(milliseconds: 100),
          ()=>{
            showDialog(
              context: context, 
              barrierDismissible: false,
              builder: (_){
                return WelcomeMessage();
            })
          }
        );
      }
      
      /*
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
      }*/
    });
  }

  void onBack(value){ setState(() {});}

  @override
  Widget build(BuildContext context) {
    _profileState = Provider.of<ProfileState>(context);

    return ListView(
    physics: ClampingScrollPhysics(),
    children: [
      SizedBox(height: Configuration.verticalspacing),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          
          Container(
            padding: EdgeInsets.symmetric(horizontal: Configuration.smpadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WeekView(),
                SizedBox(height: Configuration.verticalspacing*2),
                // horizontal list with the teachers
                TeachersList(userstate: _userstate) 
              ],
            ),
          ),
          
          SizedBox(height: Configuration.verticalspacing*2),
          
          Container(
            padding: EdgeInsets.symmetric(horizontal: Configuration.smpadding),
            child: _Timeline()
          ),


          SizedBox(height: Configuration.verticalspacing*2)

        ]  
      )    
    ]);
  }
}

class TeachersList extends StatefulWidget {
  TeachersList({
    Key key,
    @required UserState userstate,
  }) : _userstate = userstate, super(key: key);

  final UserState _userstate;

  @override
  State<TeachersList> createState() => _TeachersListState();
}

class _TeachersListState extends State<TeachersList> {
  ScrollController _scrollController = new ScrollController();


  void moveTeachers(){
    if(_scrollController.hasClients){
      _scrollController.animateTo(_scrollController.offset != 0 ? 0 : _scrollController.position.maxScrollExtent, 
        duration: Duration(seconds: 10), 
        curve: Curves.linear
      ).then((value) => moveTeachers());
    }
  }

  @override
  void initState() {
    super.initState();


     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
       //moveTeachers();
     });
    /*
    Future.delayed(Duration(seconds: 1),() {
      _scrollController.animateTo(0, duration: Duration(seconds: 10), curve: Curves.linear).then((value) => 
      
      _scrollController.animateTo(_scrollController.initialScrollOffset, duration: Duration(seconds: 10), curve: Curves.linear)
      );
    });*/
  }


  @override
  Widget build(BuildContext context) {
   

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Configuration.borderRadius/2),
        border: Border.all(
          color: Colors.grey,
          width: 0.5
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(Configuration.smpadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Configuration.borderRadius/2),
                topRight: Radius.circular(Configuration.borderRadius/2)
              ),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Icon(Icons.people, color: Colors.black, size: Configuration.smicon),
                SizedBox(width: Configuration.verticalspacing),
                Text('Find a teacher', 
                  style: Configuration.text('subtitle',Colors.black),
                ),
              ],
            ),
          ),
          
          Container(
            height: Configuration.height * 0.16,
            width: Configuration.width,
            child: ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: widget._userstate.data.teachers.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          user: widget._userstate.data.teachers[index],
                        )
                      ),
                    )
                  },
                  child: Container(
                    height: Configuration.height*0.2,
                    margin: EdgeInsets.all(Configuration.verticalspacing),
                    child: Column(
                      children: [
                        ProfileCircle(
                          userImage: widget._userstate.data.teachers[index].image,
                          width: Configuration.height*0.1,
                        ),
                        SizedBox(height: Configuration.verticalspacing/2),
                        Flexible(child: Text(
                          widget._userstate.data.teachers[index].nombre, 
                          style: Configuration.text('small',Colors.black)))
                      ],
                    ),
                  ),
                );
              }
            ),
          )
        ]
      )
    );
  }
}

class WelcomeMessage extends StatefulWidget {
  const WelcomeMessage({Key key}) : super(key: key);

  @override
  State<WelcomeMessage> createState() => _WelcomeMessageState();
}

class _WelcomeMessageState extends State<WelcomeMessage> with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation<double> scaleAnimation;

  String whoAmI  = "My name is Ernest and I wanted to thank you personally for downloading my app. I am not a meditation teacher, I just want to share my point of view.\n\n"
  "That you don't need to escape, to be successful, to become better, to practice, in order to enjoy life. Life is much more simpler than we make it.";
 
  @override
  void initState() {
    super.initState();

    controller = 
      AnimationController(vsync: this, duration: Duration(milliseconds: 900));
    
    scaleAnimation =
      CurvedAnimation(parent: controller, curve: Curves.elasticInOut);


    controller.addListener(() {
      setState(() {});
    });
    
    controller.forward();

  }



  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      runAlignment: WrapAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          child: Stack(
            children: [
            
              Column(
                children: [
                  SizedBox(height: Configuration.width*0.15),

                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: Configuration.verticalspacing
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Configuration.borderRadius),
                      color:Colors.white
                    ),
                    padding: EdgeInsets.all(Configuration.smpadding),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: Configuration.width*0.15),
                        Text("Welcome to Inside",style: Configuration.text('subtitle',Colors.black)),
                        SizedBox(height: Configuration.verticalspacing,),
                        Text(whoAmI,style: Configuration.text('small',Colors.black,font:'Helvetica')),
                        SizedBox(height: Configuration.verticalspacing),
                        Center(
                          child: Text('You are already whole\nJust look inside \n',
                            textAlign: TextAlign.center,
                            style: Configuration.text('smallmedium',Colors.black),
                          ),
                        ),
                        SizedBox(height: Configuration.verticalspacing),
                        BaseButton(
                          color: Configuration.maincolor,
                          noelevation: true,
                          text: 'Start',
                          onPressed:() {
                            _userstate.user.settings.askedProgressionQuestions = true;
                            //_userstate.user.settings.progression = 'unlockall';        
                            _userstate.updateUser();                           
                            Navigator.pop(context);
                          }, 
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Container(
                  width: Configuration.width*0.3,
                  height: Configuration.width*0.3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2)
                  ),
                  padding: EdgeInsets.all(5),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/myself.jpeg'),
                        fit: BoxFit.contain
                      )
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );


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
  RequestState  _requestState;
  String text = '';
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
  }


  void avatarChange(){

    final TextEditingController _nameController = new TextEditingController();


    Widget sendMessage(){
      return Container(
        margin: EdgeInsets.only(
          bottom: Configuration.verticalspacing * 2
        ),
        child: TextField( 
          textCapitalization: TextCapitalization.sentences,
          maxLines:3,
          maxLength: 50,
          decoration: InputDecoration(
            hintText: 'Maximum 50 characters',
            hintStyle: Configuration.text('small', Colors.grey, font: 'Helvetica'),
            fillColor: Colors.white,
            filled:true,
            border: OutlineInputBorder()
          ),
          onChanged: (value) => {
            text = value
          },
        ),
      );
    }


    Widget changeUserName(){
      return Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.only(
            bottom: Configuration.verticalspacing
          ),
          child: TextFormField(
            autofocus: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid username';
              }else if(value.length < 3){
                return 'Please enter a username longer than three characters';
              }else if(value.length > 15){
                return 'Please enter a username shorter than fifteen characters';
              } else if(value.contains(' ')){
                return 'Please enter a username without white spaces';
              }
              return null;
            },
      
            decoration: InputDecoration(
              errorStyle: Configuration.text('small', Colors.redAccent, font: 'Helvetica'),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.redAccent),
              ),
              hintText: 'superBuddha',
              hintStyle: Configuration.text('small', Colors.grey, font: 'Helvetica'),
              fillColor: Colors.white,
              filled:true,
              border: OutlineInputBorder()
            ),
            controller: _nameController, 
            style: Configuration.text('small', Colors.black, font: 'Helvetica')
          ),
        ),
      );
    }


    return showAlertDialog(
      title:  _userstate.user.nombre == null ? 
        "Write your username" :
        "Share a message",
      text: _userstate.user.nombre == null ? 
      "This will be your username in the feed, you won't be able to change it later" :
      "Share how you are feeling, how your practice is going or anything else you'd like to share with everyone",
      
      context: context,
      customWidget:  _userstate.user.nombre == null || _userstate.user.nombre.isEmpty ? 
        changeUserName() :
        sendMessage(),
      noText: 'Cancel',
      yesText: _userstate.user.nombre == null ? 'Set':'Share',
      noPop: true,
      onYes: ()async {
        if(_userstate.user.nombre == null || _userstate.user.nombre.isEmpty) {
          if(_formKey.currentState.validate()){
            bool success = await _userstate.changeName(_nameController.text);
            /*
            if(success){
              _userstate.user.nombre = _nameController.text;
            }*/
          }

        } else {
          message = new Request(
            coduser: _userstate.user.coduser,
            content: text,
            type: 'feed',
            date: DateTime.now(),
            username: _userstate.user.nombre,
            userimage: _userstate.user.image
          );

          messages.add(message);

          _requestState.uploadToFeed(r: message);

        }
      }
    );
  }


  Request message;
  List<Request> messages = new List.empty(growable: true);

  @override
  void didChangeDependencies()async {
    super.didChangeDependencies();
    _userstate = Provider.of<UserState>(context);
    
    _userstate.getFeed().then((r){ 
      if(r != null){
        messages = r;
      }
      setState((){});
    
    });

    _requestState = Provider.of<RequestState>(context);
  }

  //Pasar ESTO FUERA !!! HACERLO SOLO UNA VEZ !!
  List<Widget> getMessages() { 

    List<Widget> widgets = new List.empty(growable: true);

    if(messages.length == 0) {
      widgets.add(
        Center(
          child: Container(
            margin: EdgeInsets.only(
              top: Configuration.verticalspacing * 2
            ),
            child: Text('No messages have been added to the feed yet',
              style: Configuration.text('small',Colors.black, font: 'Helvetica')
            ),
          ),
        )
      ); 
    } else {
      messages.sort((a,b) => b.date.compareTo(a.date));

      for (var message in messages) {
        widgets.add(
          Container(
            padding: EdgeInsets.symmetric(
              vertical: Configuration.verticalspacing
            ),
            child: ListTile(
              onTap: () => {
                showUserProfile(usercod: message.coduser)
              },
              leading: ProfileCircle(
                userImage: message.userimage
              ),
              title: Text(message.username, style: Configuration.text('small',Colors.black)),
              subtitle: Text(message.content, style: Configuration.text('small',Colors.black, font: 'Helvetica')),
            ),
          )
        );
      }
    }


    return widgets;
       /*List<UserAction> sortedlist = new List.empty(growable: true);
      
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
      */
  }


  @override
  Widget build(BuildContext context) {

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[ 
                  Row(
                    children: [
                      Icon(Icons.feed,
                        size:Configuration.smicon
                      ),
                      SizedBox(width: Configuration.verticalspacing),
                      Text('Feed', 
                        style: Configuration.text('subtitle', Colors.black),
                      ),
                    ],
                  ),

                  RawMaterialButton(
                    elevation: 3.0,
                    fillColor: Colors.lightBlue,
                    child: Row(
                      children: [
                        Icon(Icons.add, color: Colors.white, size: Configuration.smicon),
                       
                      ],
                    ),
                    padding: EdgeInsets.all(Configuration.smpadding),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Configuration.borderRadius)),
                    onPressed: () {
                      avatarChange();
                    },
                  ),


                  /*
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
                  ),*/

                  
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
            child: Stack(
              children: [
                ListView(
                  physics: ClampingScrollPhysics(),
                  controller: _scrollController,
                  children: getMessages(),
                ),

              ],
            ))
        ]));
  }
}


