import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/html_towidget.dart';
import 'package:meditation_app/presentation/pages/commonWidget/radial_progress.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/stage_entity.dart';
import '../../domain/entities/user_entity.dart';

class ProgressScreen extends StatefulWidget {
  ProgressScreen();

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  UserState _userstate;

  bool pushedDialog = false;

  Widget porcentaje() {
    return Container(
      padding: EdgeInsets.all(Configuration.smpadding),
      width:Configuration.height*0.2,
      height: Configuration.height*0.2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color:Colors.grey,width: 6)
      ),
      child: RadialProgress(
        goalCompleted: _userstate.user.percentage/100,
        progressColor: Configuration.maincolor,
        progressBackgroundColor: Colors.transparent,
        child: Center(
          child: Text(
            _userstate.user.percentage.toString() + '%',
            style: Configuration.text('smallmedium', Colors.black)
          ),
        ),
      ),
    );
  }

  Widget goals(context) {
    
    Widget iconButton(String text, IconData icon, modaltext){
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.all(Configuration.smpadding),
            side: BorderSide(
            width: 1.0,
            color: Colors.grey,
            style: BorderStyle.solid,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: (){
          setState(()=> pushedDialog = true);
          showGeneralDialog(
              barrierColor: Colors.black.withOpacity(0.5),
              transitionBuilder: (context, a1, a2, widget) {
                return AbstractDialog(
                  content: Container(
                    constraints: BoxConstraints(
                      maxHeight: Configuration.height *0.5,
                      minHeight: Configuration.height*0.3,
                      minWidth: 100, maxWidth: 200
                      ),
                    padding:EdgeInsets.all(Configuration.smpadding),
                    width: Configuration.width*0.9,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(text, style: Configuration.text('smallmedium', Colors.black)),
                        SizedBox(height: Configuration.verticalspacing),
                        htmlToWidget(modaltext,fontsize: 12),
                      ],
                    )) ,
                );
              },
              transitionDuration: Duration(milliseconds: 200),
              barrierDismissible: true,
              barrierLabel: '',
              context: context,
              pageBuilder: (context, animation1, animation2) {}
          ).then((value) => setState(()=> pushedDialog = false));
        },
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text(text,style: Configuration.text('tiny', Colors.black)),
            Icon(icon, color: Configuration.maincolor,size: Configuration.medicon),
          ]),
        ),
      );
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize:MainAxisSize.min,
        children: [
          htmlToWidget(
            _userstate.user.stage.goals,
            fontsize: 12,
          )
         
         // iconButton('Goals of this stage', Icons.checklist, _userstate.user.stage.longdescription),
         // SizedBox(height: Configuration.verticalspacing*2),
         // iconButton('Tips for succeeding', Icons.lightbulb, _userstate.user.stage.obstacles),
         // SizedBox(height: Configuration.verticalspacing*2),
         // iconButton('When to advance', Icons.check, _userstate.user.stage.whenToAdvance),

        ]);
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

  Widget labels(context){
    int addedcount = 0;
    List<Widget> l = new List.empty(growable: true);

    for(var key in _userstate.user.passedObjectives.keys) {
      l.add(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _userstate.user.passedObjectives[key] == 1 ? 
          Icon(Icons.check_circle, size: Configuration.medpadding, color: Colors.green):
          Text(_userstate.user.passedObjectives[key].toString(), 
            style:Configuration.text('medium',Configuration.maincolor)
          ),
          SizedBox(height: Configuration.blockSizeVertical * 0.2),
          Container(
            width: Configuration.width*0.3,
            child: Text(key, style: Configuration.text('tiny',Colors.black), textAlign: TextAlign.center)
          )
        ])
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:  [
        Text('You should complete this objectives in order to pass to the next stage', style: Configuration.text('small', Colors.black),textAlign: TextAlign.center),
        Column(
          mainAxisSize: MainAxisSize.min,
          children:[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: l.sublist(0,l.length >= 3 ? 3 : l.length),
            ),
          l.length > 3 ? 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: l.sublist(3),
          ): Container(height: 0),
        ]),

        goals(context)

      ] 
    );
  }

  Widget oldPathScreen(context){
    return Scaffold(
      backgroundColor:Colors.white,
      body: Column(
      //direction: Configuration.width > 600 ? Axis.horizontal : Axis.vertical,
        children: [
          Container(
            color: Configuration.maincolor,
            child: Column(
              children: [
                AppBar(
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: pushedDialog ? Colors.black.withOpacity(0.01):  Configuration.maincolor, 
                    statusBarIconBrightness: Brightness.light, // For Android (dark icons)
                    statusBarBrightness: Brightness.dark, // For iOS (dark icons)
                  ),
                  backgroundColor: Configuration.maincolor,
                  elevation: 0,
                  leading: CloseButton(color: Colors.white)
                ),
                SizedBox(height: Configuration.verticalspacing),
                Text('Stage ' + _userstate.user.stagenumber.toString(), 
                style: Configuration.text('big', Colors.white)),
                SizedBox(height: Configuration.verticalspacing/3),
        
                Text(_userstate.user.stage.description, 
                  textAlign: TextAlign.center,
                style:Configuration.text('small',Colors.white,font: 'Helvetica')),

                SizedBox(height: Configuration.verticalspacing*2),
              ],
            ),
          ),

          SizedBox(height: Configuration.verticalspacing*2),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                
              porcentaje()
            ]
          ),
        
          Expanded( 
            child:Container(
              padding: EdgeInsets.all(Configuration.smpadding),
              child: labels(context)
            )
          )
        ],
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);
    
    return oldPathScreen(context);

     
  }
}

