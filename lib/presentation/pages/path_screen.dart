import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/html_towidget.dart';
import 'package:meditation_app/presentation/pages/commonWidget/radial_progress.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/stage_entity.dart';
import '../../domain/entities/user_entity.dart';

class ProgressScreen extends StatelessWidget {
  ProgressScreen();

  UserState _userstate;

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
        onPressed: ()=> {
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
              pageBuilder: (context, animation1, animation2) {})
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
          iconButton('Goals of this stage', Icons.checklist, _userstate.user.stage.longdescription),
          SizedBox(height: Configuration.verticalspacing*2),
          iconButton('Obstacles', Icons.warning, _userstate.user.stage.obstacles),
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
        Text('You must complete this objectives in order to pass to the next stage', style: Configuration.text('small', Colors.black),textAlign: TextAlign.center),
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: Container(
        padding: EdgeInsets.all(Configuration.smpadding),
        child: Column(
        //direction: Configuration.width > 600 ? Axis.horizontal : Axis.vertical,
          children: [
            
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  Text('Stage ' + _userstate.user.stagenumber.toString(), 
                  style: Configuration.text('big', Colors.black)),
                  SizedBox(height: Configuration.verticalspacing/2),
          
                  Text(_userstate.user.stage.description, 
                    textAlign: TextAlign.center,
                  style:Configuration.text('small',Colors.black,font: 'Helvetica')),
                  //Text(_userstate.user.stage.description, style: Configuration.text('small',Colors.grey), textAlign: TextAlign.center,),
                  SizedBox(height: Configuration.verticalspacing),
                  porcentaje()
              ]
            ),
          
            Expanded( 
              child:labels(context)
            )
          ],
          ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);
    
    return oldPathScreen(context);

      /*
    return ListView.builder(
      itemCount: _userstate.data.stages.length,
      itemBuilder: (context,index){
        return Path(
          user: _userstate.user,
          s: _userstate.data.stages[index], 
          key: Key(index.toString())
        );
      }
    );*/
  }
}

/*
class ProgressScreen extends StatelessWidget {
  ProgressScreen({
    Key key,
    @required this.s,
    @required this.user
  }) : super(key: key);

  final Stage s;
  final User user;
  List<Map<String,IconData>> stageObjectives  = new List.empty();


  Widget labels(){
    int addedcount = 0;
    List<Widget> l = new List.empty(growable: true);

    for(var key in user.passedObjectives.keys) {
      l.add(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          user.passedObjectives[key] == true ? 
          Icon(Icons.check_circle, size: Configuration.medpadding, color: Colors.green):
          Text(user.passedObjectives[key], style:Configuration.text('medium',Configuration.maincolor)),
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
        Text('You must complete this objectives in order to pass to the next stage', style: Configuration.text('small', Colors.black),textAlign: TextAlign.center),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: l.sublist(0,l.length >= 3 ? 3 : l.length),
        ),
        l.length > 3 ? 
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: l.sublist(3),
        ): Container(),
      ] 
    );
  }
  

  Widget showStageObjectives({bool blocked}){
    
    if(stageObjectives.length == 0){
      //NO DEBERÍA DE HABER UN MÉTODO REFACTORIZAR 
      stageObjectives = s.stobjectives.printObjectives();
    }

    List<Widget> l = new List.empty(growable: true);

    for(Map<String,IconData> objective in stageObjectives) {
      l.add(
        Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(Configuration.smpadding),
            width: Configuration.width*0.2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey)
            ),
            child: Icon(
              objective.values.first
            ),
          ),
          SizedBox(height: Configuration.verticalspacing /2),
          
          Text(objective.keys.first,style: Configuration.text('small',blocked ? Colors.grey : Colors.black))
        ])
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:  [
        SizedBox(height: Configuration.verticalspacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: l.sublist(0,l.length >= 2 ? 2 : l.length),
        ),
        l.length > 3 ? 
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: l.sublist(3),
        ): Container(),
      ] 
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: Configuration.verticalspacing),
          Container(
          width: Configuration.width*0.6,
          child: AspectRatio(
            aspectRatio: 2/1,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: Configuration.width*0.5,
                    height: Configuration.width*0.25,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(Configuration.borderRadius/3)
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(          
                    height: Configuration.width*0.35,
                    width: Configuration.width*0.4,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 50,
                          width: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Configuration.borderRadius/2),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: s.shortimage,
                            ),
                          ),
                        ),
                        SizedBox(height: Configuration.verticalspacing),
                        Text('Stage ' + s.stagenumber.toString(),style: Configuration.text('smallmedium',Colors.black)),
                        SizedBox(height: Configuration.verticalspacing),
                        Text(s.description, style: Configuration.text('small',Colors.grey, font: 'Helvetica'),)
                      ],
                    ),
                  ),
                ),


              

              
              ],
            ),
          ),
        )
        ,


        showStageObjectives(
          blocked: user.stagenumber < s.stagenumber  
        )

      ]
    );
  }
}

*/