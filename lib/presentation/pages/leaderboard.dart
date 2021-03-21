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

//aquí habrá que mostrar un mínimo
class _LeaderBoardState extends State<LeaderBoard> {
  UserState _userstate;
  var time = '';

  void sortUsers(sortparameter) {
    _userstate.data.users.sort((a, b) => a.stats['total']['tiempo'] - b.stats['total']['tiempo']);
  }

  Widget createTable(List<User> list, following) {
    String sortTime(time) {
      if (time > 1440) {
        return (time / (60 * 24)).toStringAsFixed(1) + ' d';
      }

      if (time > 60) {
        return (time / 60).toStringAsFixed(0) + ' h';
      }

      return time.toString() + ' m';
    }

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
        columnWidths: {
          0: FractionColumnWidth(0.05),
          2: FractionColumnWidth(0.42)
        },
        children: list
            .map((u) => TableRow(
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
                          (list.indexOf(u) + 1).toString(),
                          style: Configuration.text('small', Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      CircleAvatar(
                        backgroundImage:
                            u.image != null ? FileImage(File(u.image)) : null,
                        child: u.image == null ? Icon(Icons.person) : null,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(u.nombre == null ? 'Anónimo' : u.nombre,
                              style: Configuration.text(
                                  'small', Colors.black, 'bold')),
                          Text('Stage ' + u.stagenumber.toString(),
                              style: Configuration.text('tiny', Colors.grey))
                        ],
                      ),
                      //el sortTime se podría hacer en el user entity
                      texticon(
                          Icons.timer, sortTime(u.stats['total']['tiempo'])),
                      //REFINAR ESTAS CONDICIONES
                      following ||
                              u.coduser == _userstate.user.coduser ||
                              _userstate.user.following.contains(u)
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
                    TabBar(
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorWeight: 4.0,
                        indicatorColor: Configuration.maincolor,
                        tabs: [
                          Tab(
                              child: Text('All users',
                                  style: Configuration.text(
                                      'small', Colors.black))),
                          Tab(
                            child: Text('Following',
                                style:
                                    Configuration.text('small', Colors.black)),
                          )
                        ]),
                    SizedBox(height: Configuration.safeBlockVertical * 2),
                    Expanded(
                        child: TabBarView(children: [
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
