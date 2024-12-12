import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/profile_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/circular_progress.dart';
import 'package:meditation_app/presentation/pages/commonWidget/profile_widget.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:provider/provider.dart';

import 'commonWidget/back_button.dart';
import 'commonWidget/dialogs.dart';
import 'commonWidget/user_bottom_dialog.dart';


/*
  acercar letra a barra de tabbar
  linea bajo del tabbar
*/
class LeaderBoard extends StatefulWidget {
  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

//aquí habrá que mostrar un mínimo
class _LeaderBoardState extends State<LeaderBoard> {
  UserState _userstate;
  final TextEditingController _searchController = new TextEditingController();

  var time = '';
  TabController _tabController;
  dynamic condition = true;
  bool searching = false;
  int hiddenFromLeaderboard = 0;

  Widget createTable(List<User> list, context, dynamic value(User u)) {
    var count = 0;

    Widget texticon(IconData icon, String text) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Icon(icon, size: Configuration.smicon),
        Text(text, 
          overflow: TextOverflow.ellipsis,
          style: Configuration.text('tiny',Colors.black)
        )
      ]);
    }

    if(_userstate.loading){
      return Center(
        child: CircularProgress(),
      );
    } else if(list.length == 0){
      return Center(
        child: Text('No users were found',
          style: Configuration.text('small', Colors.black),
        ),
      );
    } else {
      return ListView(
      physics:ClampingScrollPhysics(),
      shrinkWrap: true,
      children: list.map((u) => 
        GestureDetector(
          onTap: ()=>{
              showUserProfile(user:u)
            },
          child: Row(
            children: [
              Container(
                constraints: BoxConstraints(
                  minWidth: Configuration.width * 0.75,
                  maxWidth:  Configuration.width * 0.75
                ),
                child: Row(
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        minWidth: 60,
                        maxWidth: 60
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

              Icon(Icons.timer, size: Configuration.smicon),

              Flexible(
                child: Text(value(u),
                  style: Configuration.text('small', Colors.black),
                ),
              )
            ]
          ),
        )).toList()
          
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies()async {
    super.didChangeDependencies();
    _userstate = Provider.of<UserState>(context);
    
    // ESTO PARA SACAR LOS USUARIOS, CADA VEZ !!! ??? NO ES SEGURO AL 100%%%%
    _userstate.getUsers();
   // _userstate.getUsersList(_userstate.user.following);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Configuration.maincolor, 
          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.light, // For Android (dark icons)
          statusBarBrightness: Brightness.dark, // For iOS (dark icons)
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Configuration.maincolor,
        leading: ButtonBack(color: Colors.white),
        actions: [
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
                    _userstate.updateUser().then((value) {
                      _userstate.getUsers();
                      setState(() {});
                    });
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
            icon: Icon(Icons.settings, color: Colors.white)
          )
        ],
        title: Text('Leaderboard', style: Configuration.text('subtitle', Colors.white)),
      ),
      body: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Container(
          height: Configuration.height,
          width: Configuration.width,
          child: Column(children: [
            Flexible(
              flex: 2,
                child: Container(
                width: Configuration.width,
                color: Configuration.maincolor,
                child: Observer(
                  builder: (context) {
                    return !_userstate.loading && _userstate.users.length > 0 ? 
                     Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned(bottom: 10, left: 45, child: UserProfile(user: _userstate.users[1], large: false, position: 2,)),
                        Align(child: UserProfile(user:_userstate.users[0], large: true, position: 1,)),
                        Positioned(bottom: 10, right: 45 , child: UserProfile(user: _userstate.users[2], large:false, position: 3))
                      ],
                    ): Container();
                  }
                ) ,
              ),
            ),
            Flexible(
              flex: 4,
              child: Column(children: [
                Container(
                  decoration: BoxDecoration(color: Configuration.lightgrey),
                  padding: EdgeInsets.symmetric(horizontal:Configuration.smpadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: searching 
                        ? TextField(
                              onChanged: (string) {
                                setState(() {
                                  _userstate.filteredusers = _userstate.users.where((element) => element.nombre != null && element.nombre.contains(string)).toList();
                                });
                              },
                              controller: _searchController,
                              style: Configuration.text('small',Colors.black),
                              decoration: InputDecoration(
                                constraints: BoxConstraints.expand(height:Configuration.height*0.05),
                                hintText: 'Username',
                                border: UnderlineInputBorder(borderSide: BorderSide(color: Configuration.maincolor, width: 3.0))
                              ),
                        )
                        : TabBar(
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: Configuration.blue,
                          labelColor: Colors.black,
                          labelStyle: Configuration.text('small',Colors.black),
                          tabs:[
                            Tab(text: 'All users'),
                            
                            Tab(text: 'This month')
                        ])
                      ),

                      IconButton(
                        iconSize: Configuration.smicon,
                        icon: Icon(searching ? Icons.close : Icons.search), 
                        onPressed: () => 
                        setState(() { 
                          if(searching){
                            _userstate.filteredusers = _userstate.users;
                          }
                          searching = !searching; 
                          _searchController.clear(); 
                          condition = true; 
                          })
                        )
                    ],
                  ),
                ),
                Observer(
                  builder: (context) {
                    return Expanded(
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children:[
                          createTable(
                            _userstate.users, 
                            context, 
                            (User u) => u.timemeditated
                          ),
                          createTable(
                            _userstate.thisMonthMeditators, 
                            context, 
                            (User u) => u.timeMeditatedMonth
                          )
                        ]
                      ),
                    );
                  }
                )
              ]),
            )
          ]),
        ),
      ),
    );
  }
}


class UserProfile extends StatelessWidget {
  final User user;
  final int position;
  final bool large;

  UserProfile({this.user,this.large = false, this.position});

  @override
  Widget build(BuildContext context) {
    var _profileState = Provider.of<ProfileState>(context);
    return GestureDetector(
      onTap: ()=> {
        showUserProfile(user:user)
      },
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2.5),
                  shape: BoxShape.circle
                ),
                child: ProfileCircle(
                  userImage: user.image,
                ),
                height: !large  ?  Configuration.width*0.2 : Configuration.width* 0.25,
                width: !large ? Configuration.width*0.2 : Configuration.width* 0.25,
              ),
              position != null ?
              Positioned(
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(Configuration.tinpadding),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.lightBlue),
                  child: Text(position.toString(), style: Configuration.text('small', Colors.white)),
                )
              ) : Container(),
            ],
          ),
          SizedBox(height: 4.0),
          Text(user.nombre != null ? user.nombre : 'Anónimo', style: Configuration.text('small', Colors.black)),
          SizedBox(height: 2.0),
          Text(user.timemeditated, style: Configuration.text('small', Colors.white))
        ],
      ),
    );
  }
}



/*
  acercar letra a barra de tabbar
  linea bajo del tabbar
*/
class TabletUserProfile extends StatelessWidget {
  final User user;
  final int position;
  final bool large;

  TabletUserProfile({this.user,this.large = false, this.position});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              image: user.image != null && user.image.isNotEmpty ? DecorationImage(image: CachedNetworkImageProvider(user.image), fit: BoxFit.fitWidth) : null,
              border: Border.all(color: Colors.white, width: 2.5),
              shape: BoxShape.circle
              ),
            height: !large  ?  Configuration.width* 0.1 : Configuration.width* 0.15,
            width: !large ? Configuration.width * 0.1 : Configuration.width* 0.15,
            ),
            position != null ?
            Positioned(
              top: 0,
              child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.lightBlue),
                child: Text(position.toString(), style: Configuration.tabletText('tiny', Colors.white)),
              )
            ) : Container(),
          ],
        ),
        SizedBox(height: 4.0),
        Text(user.nombre != null ? user.nombre : 'Anónimo', style: Configuration.tabletText('small', Colors.black)),
        SizedBox(height: 2.0),
        Text(user.timemeditated, style: Configuration.tabletText('tiny', Colors.white, font: 'Helvetica'))
      ],
    );
  }
}
