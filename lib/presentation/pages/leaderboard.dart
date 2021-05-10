import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:provider/provider.dart';

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
  var time = '';

  Widget createTable(List<User> list, following) {
    var count = 0;

    Widget texticon(IconData icon, String text) {
      return Row(children: [
        Icon(icon),
        Text(text,style: Configuration.text('small',Colors.black))
      ]);
    }

    return Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: {
          0: FractionColumnWidth(0.05),
          2: FractionColumnWidth(0.35)
        },
        children: list.map((u) => TableRow(
                    decoration: BoxDecoration(
                        color: u.coduser == _userstate.user.coduser
                            ? Colors.grey.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12.0)),
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
                          Text(u.nombre == null ? 'Anónimo' : u.nombre,style: Configuration.text('small', Colors.black)),
                          SizedBox(height: Configuration.safeBlockVertical*0.6,),
                          Text('Stage ' + u.stagenumber.toString(),style: Configuration.text('verytiny', Colors.grey, font: 'Helvetica'))
                        ],
                      ),
                      //el sortTime se podría hacer en el user entity
                      texticon(Icons.timer, u.timemeditated),
                      //REFINAR ESTAS CONDICIONES
                      /*
                      following || u.coduser == _userstate.user.coduser || u.follows
                          ? GestureDetector(
                              onTap: () async {
                                await _userstate.follow(u, false);
                                setState(() => null);
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: Configuration.smmargin),
                                padding:
                                    EdgeInsets.all(Configuration.tinpadding),
                                child: u.coduser == _userstate.user.coduser
                                    ? Container()
                                    : !following
                                        ? Icon(Icons.done)
                                        : Icon(Icons.person_remove),
                              ),
                            )
                          : GestureDetector(
                              onTap: () async {
                                await _userstate.follow(u, true);
                                setState(() => null);
                              },
                              child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: Configuration.smmargin),
                                  padding:
                                      EdgeInsets.all(Configuration.tinpadding),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Configuration.maincolor),
                                      shape: BoxShape.circle),
                                  child: Icon(Icons.person_add)),
                            )
                      */
                    ]))
            .toList());
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Configuration.maincolor,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.pop(context)),
        title: Text('Leaderboard',style: Configuration.text('medium', Colors.white)),
      ),
      body: DefaultTabController(
        length: 2,
        child: Container(
          height: Configuration.height,
          width: Configuration.width,
          child: Column(children: [
            Container(
              height: Configuration.height * 0.25,
              width: Configuration.width,
              color: Configuration.maincolor,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(bottom: 10, left: 45, child: UserProfile(user: _userstate.data.users[1], large: false, position: 2,)),
                  Align(child: UserProfile(user: _userstate.data.users[0], large: true, position: 1,)),
                  Positioned(bottom: 10, right: 45 , child: UserProfile(user: _userstate.data.users[2], large:false, position: 3))
                ],
              ),
            ),
            Expanded(
              child: Container(
                  color: Colors.white,
                  child: Column(children: [
                    TabBar(
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorWeight: 3.0,

                        indicatorColor: Configuration.maincolor,
                        tabs: [
                          Tab(
                              child: Text('All users',
                                  style: Configuration.text(
                                      'small', Colors.black))),
                          Tab(
                            child: Text('Following',
                                style:Configuration.text('small', Colors.black)),
                          )
                        ]),
                    SizedBox(height: Configuration.safeBlockVertical * 2),
                    Expanded(child: 
                    TabBarView(children: [
                      createTable(_userstate.data.users, false),
                      createTable(_userstate.user.following, true)
                    ]))
                  ])),
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

  UserProfile({this.user,this.large, this.position});

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
             Positioned(
              top: 0,
              child: Container(
                padding: EdgeInsets.all(Configuration.tinpadding),
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.lightBlue),
                child: Text(position.toString(), style: Configuration.text('tiny', Colors.white)),
              )
            ),
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
