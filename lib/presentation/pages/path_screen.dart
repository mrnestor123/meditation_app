import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/radial_progress.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:provider/provider.dart';

class PathScreen extends StatelessWidget {
  PathScreen();

  UserState _userstate;

  Widget porcentaje() {
    return RadialProgress(
      goalCompleted: 100.0,
      progressColor: Colors.transparent,
      progressBackgroundColor: Colors.grey,
      child: Container(
        padding: EdgeInsets.symmetric(vertical:20, horizontal: 10),
        child: RadialProgress(
          goalCompleted: _userstate.user.percentage/100,
          progressColor: Configuration.maincolor,
          progressBackgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(vertical:15,horizontal: 35),
            child: Text(
              _userstate.user.percentage.toString() + '%',
              style: Configuration.text('medium', Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  Widget goals(context) {
    
    Widget iconButton(String text, IconData icon, modaltext){
      return GestureDetector(
        onTap: ()=> {
          showGeneralDialog(
              barrierColor: Colors.black.withOpacity(0.5),
              transitionBuilder: (context, a1, a2, widget) {
                return AbstractDialog(
                  content: Container(
                    height: Configuration.height*0.2,
                    width: Configuration.width*0.9,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(text, style: Configuration.text('smallmedium', Colors.black)),
                        SizedBox(height: 10),
                        Text(modaltext, style:Configuration.text('small', Colors.black, font: 'Helvetica'), textAlign: TextAlign.center,),
                      ],
                    )) ,
                );
              },
              transitionDuration: Duration(milliseconds: 200),
              barrierDismissible: true,
              barrierLabel: '',
              context: context,
              pageBuilder: (context, animation1, animation2) {})
        },
        child: Container(
          padding: EdgeInsets.all(6.0),
          decoration: BoxDecoration(border: Border.all(color: Configuration.maincolor), borderRadius: BorderRadius.circular(12.0)),
          child: Column(children: [
            IconButton(icon: Icon(icon), onPressed: null),
            Text(text,
                style: Configuration.text('tiny', Colors.black),
            ),
          ]),
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GridView(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 10),
          children: [
          iconButton('Goals', Icons.tab, _userstate.user.stage.goals),
          iconButton('Obstacles', Icons.tab, _userstate.user.stage.obstacles),
          iconButton('Skills', Icons.tab, _userstate.user.stage.skills),
          iconButton('Mastery', Icons.tab, _userstate.user.stage.mastery)
        ]),
      ],
    );
  }

  Widget data(dynamic value, dynamic valuestage, String text) {
    return Column(
      children: [
        value >= valuestage
            ? Icon(Icons.check_circle,
                size: Configuration.medpadding, color: Configuration.maincolor)
            : Text(
                (value).toString() + '/' + (valuestage).toString(),
                style: Configuration.text('tiny', Configuration.maincolor),
              ),
        SizedBox(height: Configuration.blockSizeVertical * 0.2),
        Text(
          text,
          style: Configuration.text('tiny', Colors.black),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  Widget labels(){
    return GridView.count(
      crossAxisSpacing: 1.5,
      crossAxisCount: 3,
      physics: NeverScrollableScrollPhysics(),
      children: _userstate.user.passedObjectives.keys.map((key) => 
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _userstate.user.passedObjectives[key] == true ? 
            Icon(Icons.check_circle, size: Configuration.medpadding, color: Configuration.maincolor):
            Text(_userstate.user.passedObjectives[key], style:Configuration.text('medium',Configuration.maincolor)),
            SizedBox(height: Configuration.blockSizeVertical * 0.2),
            Text( key, style: Configuration.text('tiny',Colors.black), textAlign: TextAlign.center)
          ],)
      ).toList()
      );
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);
    return Column(
    children: [
      Flexible(
      flex: 2,
      child:Column(
        children: [
            Text('You are currently on ', style: Configuration.text('tiny', Colors.grey)),
            Text('Stage ' + _userstate.user.stagenumber.toString(),
             style: Configuration.text('big', Configuration.maincolor)),
            Text(_userstate.user.stage.description, style: Configuration.text('small',Colors.grey), textAlign: TextAlign.center,),
            SizedBox(height: 30),
            porcentaje()
          ]
        )
      ),

      Flexible(
        flex: 2,
        child:labels() 
      ),

      Flexible( 
        flex:2,
        child: goals(context)
      )
    ],
    );
  }
}


class TabletPathScreen extends StatelessWidget {
  TabletPathScreen();

  UserState _userstate;

  Widget porcentaje() {
    return RadialProgress(
      goalCompleted: 100.0,
      progressColor: Colors.transparent,
      progressBackgroundColor: Colors.grey,
      child: Container(
        padding: EdgeInsets.all(Configuration.blockSizeHorizontal * 1),
        child: RadialProgress(
          goalCompleted: _userstate.user.percentage/100,
          progressColor: Configuration.maincolor,
          progressBackgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(80.0),
            child: Text(
              _userstate.user.percentage.toString() + '%',
              style: Configuration.tabletText('small', Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  Widget goals() {
    return Container(
      width: Configuration.width *0.45,
      padding: EdgeInsets.all(32.0),
      decoration: BoxDecoration(
          color: Configuration.maincolor,
          borderRadius: BorderRadius.circular(16)),
      child: Table(
        columnWidths: {0: FractionColumnWidth(0.3)},
        children: [
          TableRow(children:
          [
            Text('Goals ',
              style: Configuration.tabletText('tiny', Colors.black),
            ),
            Text(_userstate.user.stage.goals,
                style: Configuration.tabletText('tiny', Colors.white, font: 'Helvetica'))
          ]),
          TableRow(children: [
            Text('Obstacles ',
                style: Configuration.tabletText('tiny', Colors.black)),
            Text(_userstate.user.stage.obstacles,
                  style: Configuration.tabletText('tiny', Colors.white, font: 'Helvetica'))
          ]),
          TableRow(children: [
            Text('Skills ',
                style: Configuration.tabletText('tiny', Colors.black)),
            Text(_userstate.user.stage.skills,
            style: Configuration.tabletText('tiny', Colors.white, font: 'Helvetica'))
          ]),
          TableRow(children: [
            Text('Mastery ',
                style: Configuration.tabletText('tiny', Colors.black)),
            Text(_userstate.user.stage.mastery,
            style: Configuration.tabletText('tiny', Colors.white, font: 'Helvetica'),
            overflow: TextOverflow.visible)
          ]),
        ],
      ),
    );
  }

  Widget data(dynamic value, dynamic valuestage, String text) {
    return Column(
      children: [
        value >= valuestage
            ? Icon(Icons.check_circle,
                size: Configuration.medpadding, color: Configuration.maincolor)
            : Text(
                (value).toString() + '/' + (valuestage).toString(),
                style: Configuration.text('tiny', Configuration.maincolor),
              ),
        SizedBox(height: Configuration.blockSizeVertical * 0.2),
        Text(
          text,
          style: Configuration.text('tiny', Colors.black),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  Widget labels(){
    return GridView.count(
      crossAxisSpacing: 1,
      crossAxisCount: 3,
      physics: NeverScrollableScrollPhysics(),
      children: _userstate.user.passedObjectives.keys.map((key) => 
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _userstate.user.passedObjectives[key] == true ? 
            Icon(Icons.check_circle, size: Configuration.tinpadding, color: Configuration.maincolor):
            Text(_userstate.user.passedObjectives[key], style:Configuration.tabletText('tiny',Configuration.maincolor)),
            SizedBox(height: Configuration.blockSizeVertical * 0.1),
            Text( key, style: Configuration.tabletText('tiny',Colors.black), textAlign: TextAlign.center)
          ],)
      ).toList()
      );
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);
    return Container(
      height: Configuration.height,
      width: Configuration.width,
      color: Configuration.lightgrey,
      padding: EdgeInsets.all(32.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(children: [
                  Text('You are currently on ',style: Configuration.tabletText('tiny', Colors.black)),
                  Text('Stage ' + _userstate.user.stagenumber.toString(),style: Configuration.tabletText('tiny', Configuration.maincolor))
                ]),
                Text(_userstate.user.stage.description, style: Configuration.tabletText('tiny',Colors.black), textAlign: TextAlign.center),
                SizedBox(height: Configuration.height*0.05),
                porcentaje(),
                SizedBox(height: Configuration.height*0.1),
                Container(height: Configuration.height*0.42,width: Configuration.width*0.35,  child:labels())
              ],
            ),
            goals()
          ],
        ),
    );
  }
}


