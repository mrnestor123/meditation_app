import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:provider/provider.dart';

class LeaderBoard extends StatefulWidget {
  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  UserState _userstate;

  void sortUsers(sortparameter){
    _userstate.data.users.sort((a,b) => a.stats['total']['tiempo']- b.stats['total']['tiempo']);
  }

  Widget createTable() {
    Widget texticon(IconData icon, String text) {
      return Row(children: [
        Icon(icon),
        Text(text,
            style: Configuration.text(
              'small',
              Colors.black,
            ))
      ]);
    }

    return Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: {0:FractionColumnWidth(0.05),2:FractionColumnWidth(0.4)},
        children: _userstate.data.users
            .map((u) => TableRow(
              children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical:Configuration.smpadding),
                    child: Text((_userstate.data.users.indexOf(u)+1).toString(),style: Configuration.text('small', Colors.black, 'bold')),
                  ),
                  CircleAvatar(
                    backgroundImage:
                        u.image != null ? FileImage(File(u.image)) : null,
                    child: u.image == null ? Icon(Icons.person) : null,
                  ),
                  Text(u.nombre == null ? 'Anónimo' : u.nombre,
                      style: Configuration.text('small', Colors.black)),
                  texticon(Icons.terrain, u.stagenumber.toString()),
                  texticon(Icons.timer, u.stats['total']['tiempo'].toString()),
                ]))
            .toList());
  }


  @override 
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Configuration.maincolor,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.pop(context)),
        title: Text(
          'Leaderboard',
          style: Configuration.text('medium', Colors.white),
        ),
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
            ),
            Expanded(
              child: Container(
                  padding: EdgeInsets.all(Configuration.smpadding),
                  color: Colors.white,
                  child: Column(children: [
                    TabBar(indicatorColor: Configuration.maincolor, tabs: [
                      Tab(
                          child: Text('Classic',
                              style:
                                  Configuration.text('small', Colors.black))),
                      Tab(
                        child: Text('Unlimited',
                            style: Configuration.text('small', Colors.black)),
                      )
                    ]),
                    Expanded(
                        child:
                            TabBarView(children: [createTable(), Container()]))
                  ])),
            )
          ]),
        ),
      ),
    );
  }
}
