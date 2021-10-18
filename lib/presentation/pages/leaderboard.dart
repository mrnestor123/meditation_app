import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/profile_widget.dart';
import 'package:meditation_app/presentation/pages/requests_screen.dart';
import 'package:provider/provider.dart';

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

  Widget createTable(List<User> list, context, following) {
    var count = 0;

    Widget texticon(IconData icon, String text) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Icon(icon),
        Text(text,style: Configuration.text('tiny',Colors.black))
      ]);
    }

    return ListView(
      children: [
          Container(
            child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: {
              0: FractionColumnWidth(0.05),
              2: FractionColumnWidth(0.42)
            },
            children: list.map((u) => 
            TableRow(
              children: [
                Container(
                padding: EdgeInsets.symmetric(
                    vertical: Configuration.smpadding,
                    horizontal: Configuration.tinpadding),
                child: Text(
                  (++count).toString(),
                  style: Configuration.text('small', Colors.black),
                  textAlign: TextAlign.center,
                ),
                ),
                CircleAvatar(
                  backgroundColor: u.image != null ? Colors.transparent : Configuration.maincolor,
                  backgroundImage: u.image != null ? NetworkImage(u.image) : null,
                  child: u.image == null ? null : null,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(u.nombre == null ? 'Anónimo' : u.nombre, style: Configuration.text('small', Colors.black)),
                    SizedBox(height: Configuration.safeBlockVertical*0.6,),
                    Text('Stage ' + u.stagenumber.toString(),style: Configuration.text('verytiny', Colors.grey, font: 'Helvetica'))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start, 
                  children: [
                    texticon(Icons.timer, u.timemeditated)
                  ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      u.coduser != _userstate.user.coduser ?
                      IconButton(
                        icon: Icon(following || u.followed != null && u.followed ? Icons.person : Icons.person_add), 
                        onPressed: () async { 
                          bool following = _userstate.user.following.contains(u.coduser);
                          
                          await showUserProfile(u,context, true, 
                          () async{
                              following = !following;
                              await _userstate.follow(u, following);
                              setState(() {
                                
                              });
                            }, following ); 
                          
                          setState((){});}
                        ) :  Container(),
                    ],
                  )
              ]
            )).toList()
        ),
          )] 
      );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies()async {
    super.didChangeDependencies();
    _userstate = Provider.of<UserState>(context);
    _userstate.getUsers();
    _userstate.getUsersList(_userstate.user.following);
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
        centerTitle: true,
        elevation: 0,
        backgroundColor: Configuration.maincolor,
        leading: ButtonBack(color: Colors.white),
        title: Text('Leaderboard', style: Configuration.text('medium', Colors.white)),
      ),
      body: DefaultTabController(
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
                  child: Row(
                    children: [
                      Container(
                      width: Configuration.width*0.85,
                      child: searching ? 
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal:16.0),
                          child: AspectRatio(
                            aspectRatio: 9/1,
                              child: TextField(
                              onChanged: (string) {
                                setState(() {
                                  condition = string;
                                });
                              },
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Username',
                                border: UnderlineInputBorder(borderSide: BorderSide(color: Configuration.maincolor, width: 3.0))
                              ),
                            ),
                          ),
                        )
                      : TabBar(
                          controller: _tabController,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorWeight: 2.5,
                          indicatorColor: Configuration.maincolor,
                          tabs: [
                            Tab(
                                child: Text('All users',style: Configuration.text('small', Colors.black))),
                            Tab(
                              child: Text('Following', style:Configuration.text('small', Colors.black)),
                            ),
                          ]),
                      ),
                      Container( 
                        width: Configuration.width *0.1,
                        child: IconButton(
                          icon: Icon(searching ? Icons.close : Icons.search), 
                          onPressed: () => setState(() { searching = !searching; _searchController.clear(); condition = true; })
                          )
                        )
                    ],
                  ),
                ),
                Observer(
                  builder: (context) {
                    return  _userstate.loading ? 
                      Container(
                        margin: EdgeInsets.only(top: 16.0),
                        child: CircularProgressIndicator(
                          color: Configuration.maincolor,
                          strokeWidth: 3.0,
                        ),
                      ) :
                      Expanded(child: 
                      TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: [
                        createTable(_userstate.users, context,false),
                        createTable(_userstate.dynamicusers, context, true),
                    ]));
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
    return Column(
      children: [
        Stack(
          children: [
            Container(
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              image: user.image != null ? DecorationImage(image: NetworkImage(user.image), fit: BoxFit.fitWidth) : null,
              border: Border.all(color: Colors.white, width: 2.5),
              shape: BoxShape.circle
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
                child: Text(position.toString(), style: Configuration.text('tiny', Colors.white)),
              )
            ) : Container(),
          ],
        ),
        SizedBox(height: 4.0),
        Text(user.nombre != null ? user.nombre : 'Anónimo', style: Configuration.text('small', Colors.black)),
        SizedBox(height: 2.0),
        Text(user.timemeditated, style: Configuration.text('tiny', Colors.white, font: 'Helvetica'))
      ],
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
              image: user.image != null ? DecorationImage(image: NetworkImage(user.image), fit: BoxFit.fitWidth) : null,
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

/*
class TabletLeaderBoard extends StatefulWidget {
  @override
  _TabletLeaderBoardState createState() => _TabletLeaderBoardState();
}

//aquí habrá que mostrar un mínimo
class _TabletLeaderBoardState extends State<TabletLeaderBoard> {
  UserState _userstate;
  final TextEditingController _searchController = new TextEditingController();

  List<User> users;

  var time = '';
  TabController _tabController;
  bool searching = false;

  dynamic showUserProfile(User user,context) {
   return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          bool following = _userstate.user.following.contains(user);

          return StatefulBuilder(
              builder:(BuildContext context, StateSetter setState ) {
              return  Container(
              height: 300,
              color: Configuration.maincolor,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Center(
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(2.0),
                                      decoration: BoxDecoration(
                                        image: user.image != null ? DecorationImage(image: NetworkImage(user.image), fit: BoxFit.fitWidth) : null,
                                        border: Border.all(color: Colors.white, width: 2.5),
                                        shape: BoxShape.circle
                                        ),
                                      height: Configuration.width* 0.1,
                                      width:  Configuration.width* 0.1,
                                    ),
                                    SizedBox(height: 4.0),
                                    Text(user.nombre != null ? user.nombre : 'Anónimo', style: Configuration.tabletText('small', Colors.white)),
                                    SizedBox(height: 2.0),
                                    Text(user.timemeditated, style: Configuration.tabletText('tiny', Colors.white, font: 'Helvetica'))
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text('Following', style: Configuration.tabletText('tiny', Colors.white)),
                                  Text(user.following.length.toString(), style: Configuration.tabletText('tiny',Colors.white))   
                                ],
                              ),
                              Column(
                                children: [
                                  Text('Followers', style: Configuration.tabletText('tiny', Colors.white)),
                                  Text(user.followsyou.length.toString(), style: Configuration.tabletText('tiny',Colors.white))
                                ],
                              )
                          ])
                        ],
                      ),
                      Column(
                        children: [
                          TabletInfoCard(
                                firstText: user.userStats.total.meditations.toString(),
                                secondText: "Meditations\ncompleted",
                                icon: Icon(Icons.self_improvement, color: Colors.lightBlue),
                                color: 'white',
                          ),
                          TabletInfoCard(
                              firstText: user.userStats.total.lessons.toString(),
                              secondText: "Lessons\ncompleted",
                              icon: Icon(Icons.book, color: Colors.lightBlue),
                              color: 'white',
                          )
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () => setState((){
                          following= !following;  
                          _userstate.follow(user, following);}), 
                        child: Text(!following ? 'Follow' : 'Unfollow', style:  Configuration.tabletText('tiny', !following ? Colors.red : Colors.lightBlue)),
                        style: OutlinedButton.styleFrom(
                        ),
                      )
                    ],
                  )
                ],
              )
            );
            }
          );
        },
    );
  }


  Widget createTable(List<User> list, following, context) {
    var count = 0;

    Widget texticon(IconData icon, String text) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Icon(icon),
        Text(text,style: Configuration.tabletText('tiny',Colors.black))
      ]);
    }

    return ListView.builder(
      itemCount: list.length,
      itemBuilder:(context, index) {
        var u = list[index];
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 1,
              child:Container(
              padding: EdgeInsets.all(12.0),
              child: Text(
                (++index).toString(),
                style: Configuration.tabletText('small', Colors.black),
                textAlign: TextAlign.center,
              ),
            )),
            Flexible(
              flex:1,
              child:CircleAvatar(
              backgroundColor: u.image != null ? Colors.transparent : Configuration.maincolor,
              backgroundImage: u.image != null ? NetworkImage(u.image) : null,
              child: u.image == null ? null : null,
            )),
            Flexible(
              flex:2,
              child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(u.nombre == null ? 'Anónimo' : u.nombre,style: Configuration.tabletText('small', Colors.black)),
                SizedBox(height: Configuration.safeBlockVertical*0.6,),
                Text('Stage ' + u.stagenumber.toString(),style: Configuration.tabletText('verytiny', Colors.grey, font: 'Helvetica'))
              ],
            )),
            //el sortTime se podría hacer en el user entity
            Flexible(flex:1,child: texticon(Icons.timer, u.timemeditated)),

            Flexible(flex:1,child: IconButton(icon: Icon(Icons.person), onPressed: () async { await showUserProfile(u,context); setState((){});}))
          ],
        );


      });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _userstate = Provider.of<UserState>(context);
    users = _userstate.data.users;
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
        centerTitle: true,
        elevation: 0,
        backgroundColor: Configuration.maincolor,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.pop(context)),
        title: Text('Leaderboard', style: Configuration.tabletText('small', Colors.white)),
      ),
      body: DefaultTabController(
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
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(bottom: 10, left: 100, child: TabletUserProfile(user: _userstate.data.users[1], large: false, position: 2,)),
                    Align(child: TabletUserProfile(user: _userstate.data.users[0], large: true, position: 1,)),
                    Positioned(bottom: 10, right: 100 , child: TabletUserProfile(user: _userstate.data.users[2], large:false, position: 3))
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 4,
              child: Column(children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Configuration.grey),
                  child: Row(
                    children: [
                      Container(
                      width: Configuration.width*0.85,
                      child: searching ? 
                        AspectRatio(
                          aspectRatio: 9/1,
                            child: TextField(
                            onChanged: (string) {
                              setState(() {
                                if(string != null || string != ''){
                                  users =  _userstate.data.users.where((u) => u.nombre != null && u.nombre.contains(string)).toList();
                                }else{
                                  users = _userstate.data.users;
                                }
                              });
                            },
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Username',
                              border: UnderlineInputBorder(borderSide: BorderSide(color: Configuration.maincolor, width: 3.0))
                            ),
                          ),
                        )
                      : TabBar(
                          controller: _tabController,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorWeight: 2.5,
                          indicatorColor: Colors.transparent,
                          tabs: [
                            Tab(
                                child: Text('All users',
                                    style: Configuration.tabletText(
                                        'small', Colors.black))),
                            Tab(
                              child: Text('Following',
                                  style:Configuration.tabletText('small', Colors.black)),
                            ),
                          ]),
                      ),
                      Container( 
                        width: Configuration.width *0.1,
                        child: IconButton(
                          icon: Icon(searching ? Icons.close : Icons.search), 
                          onPressed: ()=> setState(()=> searching = !searching)
                          )
                        )
                    ],
                  ),
                ),
                Expanded(child: 
                TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                  createTable(users, false, context),
                  createTable(_userstate.user.following, true, context),
                ]))
              ]),
            )
          ]),
        ),
      ),
    );
  }
}

*/
