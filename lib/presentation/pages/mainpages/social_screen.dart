

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/date_tostring.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/commonWidget/wrapper_container.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/request_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../../mobx/actions/profile_state.dart';
import '../../mobx/actions/requests_state.dart';
import '../commonWidget/circular_progress.dart';
import '../commonWidget/dialogs.dart';
import '../commonWidget/profile_widget.dart';
import '../commonWidget/user_bottom_dialog.dart';
import '../config/configuration.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({Key key}) : super(key: key);

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {

  UserState _userstate;

  List<dynamic> titles = [{
    "title":"Teachers Hub",
    "description": "A place for teachers to share their work, their knowledge and experience.",
    "icon":Icons.school
  },{
    "title":"Community",
    "description": "Feel free to share your thoughts, ideas and questions with everyone.",
    "icon":Icons.people
  },{
    "title":"Ranking",
    "description":"Get encouraged and motivated by others. ",
    "icon":Icons.leaderboard
  }];

  int _index = 2;

  String text = '';

  bool isLoading = false;
  bool justPressed = false;

  int hiddenFromLeaderboard = 0;


  
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _userstate = Provider.of<UserState>(context);
    //_requestState = Provider.of<RequestState>(context);

    
    // ESTO SOLO DEBERÍA DE HACERSE UNA VEZ
    /*_requestState.getFeed().then((r){ 
      if(r != null){
        feedMessages = r.where((element) => element.type == 'feed').toList();
        teacherMessages = r.where((element) => element.type == 'teacher').toList();
      }
    });*/
  }


 
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard', style:Configuration.text('subtitle',Colors.white)),
        backgroundColor: Configuration.maincolor,
        
      ),
      body: Container(
        padding: EdgeInsets.all(Configuration.smpadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Configuration.borderRadius/2),
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.5
                  )
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal:Configuration.smpadding),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: Configuration.verticalspacing),
    
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(titles[_index]['icon'], color: Colors.lightBlue,),
                                  SizedBox(width: Configuration.verticalspacing),
                                  Text(titles[_index]['title'], style: Configuration.text('subtitle', Colors.black),),
                                ],
                              ),
    
                              IconButton(
                                style: IconButton.styleFrom(
                                  minimumSize: Size(0,0),
                                  maximumSize: Size(0,0),
                                ),
                                iconSize: Configuration.smicon,
                                onPressed: ()=>{
    
                                  if(hiddenFromLeaderboard < 3){
                                    showAlertDialog(
                                      title: 'Leaderboard settings',
                                      context: context,
                                      text: "You can configure wether you'd like to appear on the leaderboard or not. Do you want to appear on the leaderboard?",
                                      yesText: _userstate.user.settings.hideInLeaderboard ? 'Show me' : 'Hide me',
                                      onYes: (){
                                        hiddenFromLeaderboard++;
                                        _userstate.user.settings.hideInLeaderboard = !_userstate.user.settings.hideInLeaderboard;
                                        _userstate.updateUser().then((value) => 
                                          setState(() {})
                                        );
                                        //setState(() {});
                                      },
                                      noPop: true,
                                      hideNoButton: true
                                    )
                                  }else {
                                    showAlertDialog(
                                      noPop: true,
                                      hideYesButton: true,
                                      context: context,
                                      noText: 'OK',
                                      text:'You have changed settings too many times. You can only change settings three times a day.'
                                    )
                                  }
                                }, 
                                icon: Icon(Icons.settings, color: Colors.grey,)
                              )
    
                              
                            ],
                          ),
    
                          SizedBox(height: Configuration.verticalspacing),
    
                          Text(titles[_index]['description'], style: Configuration.text('small', Colors.grey),),
                          SizedBox(height: Configuration.verticalspacing*2)
                        ],
                      ),
                    ),
    
                    
    
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(Configuration.borderRadius/2)),
                          color: Configuration.lightgrey
                        ),
                        child: LeaderBoard(key: _userstate.user.settings.hideInLeaderboard ? Key('hide') : Key('show'))
                      )
                    )
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}

/*
  acercar letra a barra de tabbar
  linea bajo del tabbar
*/
class LeaderBoard extends StatefulWidget {
  const LeaderBoard({Key key}) : super(key: key);

  // add key
  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

//aquí habrá que mostrar un mínimo
class _LeaderBoardState extends State<LeaderBoard> with TickerProviderStateMixin {
  UserState _userstate;
  final TextEditingController _searchController = new TextEditingController();

  var time = '';
  dynamic condition = true;
  bool searching = false;

  List<User> thisweekMeditators = new List.empty(growable: true);
  List<User> thismonthMeditators = new List.empty(growable: true);

  int showing = 0;
  int allTime = 0;
  int month = 1;
  int week = 2;


  TabController _tabController; 

  Widget createTable({List<User> users, context, condition,  String text, Widget icon}) {
    var count = 0;

    if(users.length == 0){
      return Center(
        child: Text( text != null ? text :'No users were found',
          style: Configuration.text('small', Colors.black),
        ),
      );
    }else {
      return ListView(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      children: users.map((u) => 
        GestureDetector(
          onTap: ()=>{
            showUserProfile(user:u)
          },
          child: Row(
            children: [
              Container(
                constraints: BoxConstraints(
                  minWidth: Configuration.width * 0.7,
                  maxWidth:  Configuration.width * 0.7
                ),
                child: Row(
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        minWidth: 50,
                        maxWidth: Configuration.verticalspacing*5
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: Configuration.smpadding,
                        horizontal: Configuration.tinpadding
                      ),
                      child: Text(
                        (++count).toString(),
                        style: Configuration.text('small', Colors.black),
                        textAlign: TextAlign.left,
                    )),
                
                    ProfileCircle(
                      key:Key(u.coduser),
                      width: 30,
                      userImage: u.image,
                    ),
                
                    SizedBox(width: Configuration.verticalspacing*1.5),
              
                    Flexible(child: Text(u.nombre == null ? 'Anónimo' : u.nombre, style: Configuration.text('small', Colors.black))),
                      
                  ],
                ),
              ),


              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    icon,

                    Text(condition(u),
                      style: Configuration.text('small', Colors.black),
                      textAlign: TextAlign.end,
                    ),
                    SizedBox(height: Configuration.verticalspacing)
                  ],
                ),
              )
            ]
          ),
        )).toList()
          
      );
    }
  }

  Widget topUsers({List<User> users}){
    return users.length == 0  ?
      Container() :      
      Container(
        color: Configuration.lightgrey,
        child: Column(
          children: [
            users.length > 0 ?
            UserProfile(user:users[0], large: true, position: 1,)
            : Container(),
      
            users.length > 1 ?
            UserProfile(
              user: users[1], 
              large: false, 
              position: 2): Container(),
            
           
      
            users.length > 2  ?
            UserProfile(user: users[2], large:false, position: 3) :
            Container(),
          ],
        ),
      );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this
    );
  }

  @override
  void didChangeDependencies()async {
    super.didChangeDependencies();

    _userstate = Provider.of<UserState>(context);
    _userstate.getUsers();

  }

  /*
  showAlertDialog(
    context: context,
    title: 'Settings',
    text: "You can configure wether you'd like to appear on the leaderboard or not. Do you want to appear on the leaderboard?",
    yesText:  _userstate.user.settings.hideInLeaderboard ? 'Show me' : 'Hide me',
    onYes: () {
      _userstate.user.settings.hideInLeaderboard = !_userstate.user.settings.hideInLeaderboard;
      _userstate.updateUser();
      setState(() {});
    },
    noPop: true,
    hideNoButton: true,
  )*/


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        height: Configuration.height,
        width: Configuration.width,
        child: Column(children: [

          //topUsers(users: _userstate.users.where((element) => !element.settings.hideInLeaderboard).toList()),
          /* Container(
            width: Configuration.width*0.2,
            child: BaseButton(
              color: Colors.lightBlue,
              child: Text('Hide me', 
                style: Configuration.text('tiny', Colors.blue),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
          width: Configuration.width,
          child: Observer(
            builder: (context) {
              return !_userstate.loading && _userstate.users.length > 0 ? 
                topUsers(
                  users:  _tabController.index == 0 ? 
                    _userstate.users :
                    _tabController.index == 1 ?
                    _userstate.thisMonthMeditators :
                    _userstate.thisWeekMeditators
                ): Container();
            }
          )) */     
          Expanded(
            child: Column(children: [
             /* Container(
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                child: TabBar(
                  controller: _tabController,
                  onTap:  (index) => setState(() {
                    _tabController.index = index;
                  }),
                  indicatorColor: Configuration.maincolor,
                  labelStyle: Configuration.text('small', Colors.green),
                  unselectedLabelStyle: Configuration.text('small', Colors.black),
                  labelColor: Configuration.maincolor,
                  unselectedLabelColor: Colors.grey,
                  
                  tabs: [
                    Tab(text: 'All'),
                    //Tab(text: 'Week'),
                    //Tab(text: 'Streak')
                  ] 
                ),
              ),*/
              
              Observer(
                builder: (context) {
                  return _userstate.loading ? 
                  Expanded(
                    child: Center(
                      child: CircularProgress(),
                    ),
                  ) :
                  Expanded(
                    child: createTable(
                      users:_userstate.users.where((element) => !element.settings.hideInLeaderboard).toList(),
                      icon: Icon(Icons.timer, size: Configuration.smicon),
                      context: context,
                      condition: (user)=> getTimeMeditatedString(time:user.userStats.timeMeditated) 
                    ) 
                  );
                }
              )
            ]),
          )
        ]),
      );
  }
}


class UserProfile extends StatelessWidget {
  User user;
  final int position;
  final bool large;

  UserProfile({this.user  ,this.large = false, this.position});

  @override
  Widget build(BuildContext context) {
    var _profileState = Provider.of<ProfileState>(context);

    if(user == null){
      user = new User(
        image: '',
        nombre: ''
      );
    }

    return GestureDetector(
      onTap: ()=> {
        showUserProfile(user:user)
      },
      child: ListTile(
        minLeadingWidth: Configuration.width*0.05,
        leading: Container(
          padding: EdgeInsets.all(Configuration.tinpadding),
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.lightBlue),
          child: Text(position.toString(), style: Configuration.text('small', Colors.white)),
        ),
        title: Row(
          children: [
            ProfileCircle(
              width: 30,
              userImage: user.image,
            ),
            SizedBox(width: Configuration.verticalspacing),
            Text(user.nombre != null ? user.nombre : 'Anónimo', style: Configuration.text('small', Colors.black)),
          ],
        ),
        trailing: Text(user.timemeditated, style: Configuration.text('small', Colors.black)),
       ),
    );
  }
}

