
import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/mobx/login_register/login_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';
import 'package:meditation_app/presentation/pages/requests_screen.dart';
import 'package:provider/provider.dart';

import 'config/configuration.dart';

class Settings extends StatefulWidget {
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);
    final _loginstate = Provider.of<LoginState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings',style: Configuration.text('medium', Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading:   ButtonBack()
      ),
      body: Container(
        color: Configuration.lightgrey,
        width: Configuration.width,
        padding: EdgeInsets.all(Configuration.smpadding),
        child: Column(
          children: [
            SizedBox(height: 10),
            SettingsButton(
              text:'Stage Progression',
              onPressed:()=>{
                Navigator.push(context,
                MaterialPageRoute(builder: (context) =>  
                StageProgression(
                  title:'Stage Progression',
                  description: 'Choose how you want to follow the progression in the app',
                  condition: (name)=> _userstate.user.settings.progression == name,
                  action: (name){
                    _userstate.user.settings.setProgression(name);
                    setState((){});
                  },
                  options: [
                    {'text':'casual','name':'casual','description':'Follows the usual routine'},
                    {'text':'Unlock meditations','name':'unlockmeditations', 'description':'unlocks all meditations'},
                    {'text':'Unlock lessons','name':'unlocklesson', 'description': 'Unlocks all lessons'},
                    {'text':'Unlock all','name':'unlockall', 'description' : 'Unlocks all content in the app'}
                  ]
                )))
              }
            ),
            SizedBox(height: 20),
            Text('This app is based on The Mind Illuminated, written by John Yates',style: Configuration.text('small', Colors.black), textAlign: TextAlign.center),
            SizedBox(height: 5),
            Image(
              image: AssetImage('assets/tenstages-book.png'),
              width: Configuration.width*0.5,
            ),
            Spacer(),
            Container(
              width: Configuration.width,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(Configuration.borderRadius)),
                    padding: EdgeInsets.all(12)
                  ),
                  onPressed: () { 
                  _userstate.user=null;
                  _loginstate.logout();
                  Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (route) => false);
                }, child: Text('LOG OUT',style: Configuration.text('small', Colors.white),)),
            ),
            SizedBox(height: Configuration.verticalspacing*2),
          ],
        ),
      ),    
    );
  }
}


class IncreaseScreenDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserState _userstate = Provider.of<UserState>(context);

    return AbstractDialog(
      content: Container(
          height: Configuration.height * 0.3,
          width: Configuration.width,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          padding: EdgeInsets.all(Configuration.smpadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'You are going to change to the next stage while not finishing the stage before',
                  style: Configuration.tabletText('tiny', Colors.black)),
              SizedBox(height: Configuration.height * 0.05),
              Text('Are you sure?',
                  style: Configuration.tabletText('tiny', Colors.black)),
              SizedBox(height: Configuration.height * 0.01),
              ElevatedButton(
                  onPressed: (){
                    print('pressed button');
                    _userstate.updateStage(); 
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(Configuration.smpadding),
                    child: Text('Yes'),
                  ))
            ],
          )),
    );
  }
}



class StageProgression extends StatefulWidget {
  StageProgression({this.title,this.description,this.options,this.action,this.condition}) : super();

  String title,description;
  List<dynamic> options= new List.empty(growable: true);
  dynamic action,condition;

  @override
  State<StageProgression> createState() => _StageProgressionState();
}

class _StageProgressionState extends State<StageProgression> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: ButtonBack(),
        title: Text(widget.title,style:Configuration.text('small', Colors.black)
      )),
      body: Container(
        color: Configuration.lightgrey,
        width:Configuration.width,
        padding: EdgeInsets.all(Configuration.smpadding),
        child: Column(
          children: [
            SizedBox(height:Configuration.verticalspacing),
            Text(widget.description, style: Configuration.text('tiny', Colors.black)),
            SizedBox(height: Configuration.verticalspacing*2),
            Column(
              children: 
                widget.options.map((option) => 
                GestureDetector(
                  onTap:(){widget.action(option['name']); setState(() {});},
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: widget.condition(option['name']) ? Colors.grey : Colors.transparent
                    ),
                    padding: EdgeInsets.all(Configuration.smpadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: Configuration.verticalspacing * 2,
                          width: Configuration.verticalspacing*2,
                          decoration: BoxDecoration(
                            color: widget.condition(option['name']) ? Colors.black: Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black)
                          ),
                        ),
                        Text(option['text'], style:Configuration.text('small',Colors.black))
                      ]
                    ),
                  ),
                )
              ).toList(),
            )
          ],
        ),
      )
    );
  }
}


class SettingsButton extends StatelessWidget {
  SettingsButton({this.text,this.onPressed}) : super();

  String text;
  dynamic onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Configuration.width,
        child: OutlinedButton(
          style: ElevatedButton.styleFrom(
            onSurface: Colors.black,
            side: BorderSide(
              width: 1.0,
              color: Colors.black,
              style: BorderStyle.solid,
            ),
            padding: EdgeInsets.all(Configuration.smpadding)
          ),
          onPressed: onPressed,             
          child: Text(text,style: Configuration.text('small', Colors.black) )
        ),
      );
  }
}



class RadioButtons extends StatelessWidget {
  RadioButtons({this.options}) : super();

  List<dynamic> options = new List.empty(growable: true);

  Widget RadioButton(){

  }




  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}


/*
  showGeneralDialog(
            barrierColor: Colors.black.withOpacity(0.5),
            transitionBuilder: (context, a1, a2, widget) {
              // HAY QUE QUITAR ESTA ANIMACIÓN
              return Transform.scale(
                scale: a1.value,
                child: Opacity(
                  opacity: a1.value,
                  child: IncreaseScreenDialog(),
                ),
              );
            },
            transitionDuration: Duration(milliseconds: 200),
            barrierDismissible: true,
            barrierLabel: '',
            context: context,
            pageBuilder: (context, animation1, animation2) {}) 
*/