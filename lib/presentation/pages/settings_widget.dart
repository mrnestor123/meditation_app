
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meditation_app/domain/entities/local_notifications.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/mobx/login_register/login_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialogs.dart';
import 'package:meditation_app/presentation/pages/commonWidget/html_towidget.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:provider/provider.dart';

import 'commonWidget/back_button.dart';
import 'commonWidget/remind_time.dart';
import 'config/configuration.dart';

class Settings extends StatefulWidget {
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Configuration.lightgrey,            // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        title: Text('Settings',style: Configuration.text('subtitle', Colors.black)),
        backgroundColor: Configuration.lightgrey,
        elevation: 1,
        centerTitle: true,
        leading:   ButtonBack(color: Colors.black)
      ),
      body: SettingsMenu()    
    );
  }
}



class SettingsMenu extends StatelessWidget {

  Widget containerSettings({String text, onPressed, isTitle = false}){

    return Container(
      alignment: Alignment.centerLeft,
      width: Configuration.width,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(
          color: Colors.grey
        ))
      ),
      child: TextButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: EdgeInsets.all(Configuration.smpadding)
        ),
        onPressed: onPressed, 
        child: Row(
          children: [
            Flexible(
              child: Text(text,style: Configuration.text('small', Colors.black, font: isTitle ? null: 'Helvetica'),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        )
      ),
    );
  }
  
  SettingsMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _userstate = Provider.of<UserState>(context);
    final _loginstate = Provider.of<LoginState>(context);
    return Container(
        color: Configuration.lightgrey,
        width: Configuration.width,
        child: Column(
          children: [

          containerSettings(
            text: 'GENERAL',
            isTitle: true
          ),       
                
          containerSettings(
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
                  _userstate.updateUser();
                  //setState((){});
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
          
          containerSettings(
            text: 'Ask a teacher',
            onPressed: ()=>{
              Navigator.push(context,
              MaterialPageRoute(builder: (context) =>  
                AskTeacherScreen()
              ))
            },
          ),

  

          containerSettings(
            text:'Request a feature / report a bug',
            onPressed:()=>{
              Navigator.pushNamed(context, '/requests')
            }
          ),


          containerSettings(
            text: 'Set a time reminder',
            onPressed: ()=>{
              Navigator.push(context,
              MaterialPageRoute(builder: (context) =>  
                TimeReminder()
              ))
            },
          ),

          /*
          containerSettings(
            text: Platform.isIOS ? 'Apple health' : 'Google fit',
            onPressed: ()=>{
            },
          ),*/

          containerSettings(
            text: 'INFO',
            isTitle: true
          ), 

          

          containerSettings(
            text: 'About the app',
            onPressed: ()=>{
              Navigator.push(context,
              MaterialPageRoute(builder: (context) =>  
                AboutPage(
                  title: 'About the app',
                  text: _userstate.data.settings.aboutApp,
                )
              ))
            },
          ),

          containerSettings(
            text: 'About the author',
            onPressed: ()=>{
              Navigator.push(context,
              MaterialPageRoute(builder: (context) =>  
                AboutPage(
                  title: 'About the author',
                  text: _userstate.data.settings.aboutMe,
                )
              ))
            },
          ),


          _userstate.data.settings != null && _userstate.data.settings.menu != null ?
          Column(
            children: _userstate.data.settings.menu.map((e) => 
              containerSettings(
                text: e.title,
                onPressed: ()=>{
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>  
                    AboutPage(
                      title: e.title,
                      text: e.text,
                    )
                  ))
                },
              )
            ).toList()
          ) : Container(),

          containerSettings(
            text: 'Delete my account',

            onPressed: (){
              showAlertDialog(
                context: context,
                title: 'Are you sure?',
                text: 'This will delete your account and all your data',
                onYes: () {
                  // CONFIRM DIALOG AGAIN
                  print('YES');
                  showAlertDialog(
                    context: context,
                    title: 'I confirm I want to delete my account',
                    text: 'All data will be lost',
                    yesText: 'DELETE ACCOUNT',
                    noText: 'CANCEL',
                    onYes: ()=> {
                      _userstate.deleteUser(),
                      _loginstate.logout(),
                      
                      Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (route) => false)
                    },
                    noPop: true
                  );
                },
                noPop: true
                
              );

            }

          ),

          SizedBox(height: Configuration.verticalspacing*2),
          
          Container(
            width: Configuration.width*0.9,
            child: BaseButton(
              text: 'Log in with another account',
              color: Colors.red,
              textcolor: Colors.red,
              onPressed: () { 
                _userstate.user=null;
                _loginstate.logout();
                Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (route) => false);
              },             
            ),
          ),
        ],
      ),
    );
  }
}


class AboutApp extends StatelessWidget {

  const AboutApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('About the app',style: Configuration.text('medium', Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading:   ButtonBack(color: Colors.black)
      ),
      body: Container(
        color: Configuration.lightgrey,
        padding: EdgeInsets.all(Configuration.smpadding),
        child: Column(
          children: [
            htmlToWidget(
              _userstate.data.settings.aboutApp
            )
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
                    //_userstate.updateStage(); 
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
        backgroundColor: Configuration.lightgrey,
        elevation: 1,
        leading: ButtonBack(color: Colors.black),
        title: Text(widget.title,style:Configuration.text('subtitle', Colors.black)
      )),
      body: Container(
        color: Configuration.lightgrey,
        width:Configuration.width,
        padding: EdgeInsets.all(Configuration.smpadding),
        child: Column(
          children: [
            SizedBox(height:Configuration.verticalspacing),
            Text(widget.description, style: Configuration.text('small', Colors.black, font: 'Helvetica')),
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
                        Text(option['text'], style:Configuration.text('small',Colors.black, font:'Helvetica'))
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


class AboutPage extends StatelessWidget {
  String title, text;

  AboutPage({Key key, this.title, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final  _userstate  = Provider.of<UserState>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Configuration.lightgrey,
        elevation: 0,
        leading: ButtonBack(color: Colors.black),
        title: Text(this.title,style:Configuration.text('subtitle', Colors.black)
      )),
      body: Container(

        constraints: BoxConstraints(
          minHeight: Configuration.height
        ),
        padding: EdgeInsets.all(Configuration.smpadding),
        decoration: BoxDecoration(
          color: Configuration.lightgrey
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              htmlToWidget(
                this.text
              )
            ],
          ),
        ),
      ),
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


class TimeReminder extends StatefulWidget {
  const TimeReminder({Key key}) : super(key: key);

  @override
  State<TimeReminder> createState() => _TimeReminderState();
}

class _TimeReminderState extends State<TimeReminder> {
  @override
  Widget build(BuildContext context) {
    final _userstate= Provider.of<UserState>(context);

    return Scaffold(
      backgroundColor: Configuration.lightgrey,
      appBar: AppBar(
        backgroundColor: Configuration.lightgrey,
        elevation: 1,
        leading: ButtonBack(color: Colors.black),
        title: Text('Meditation reminder', style: Configuration.text('subtitle', Colors.black)),
      ),

      body: Container(
        padding: EdgeInsets.all(Configuration.smpadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Configuration.verticalspacing),
            Text('Set a daily reminder to meditate', 
              style: Configuration.text('small', Colors.black,  font: 'Helvetica'),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Configuration.verticalspacing),
            ReminderTimeButton(
              onchange:()=>{setState(() {})}
            ),
            SizedBox(height: Configuration.verticalspacing*2),
           
            BaseButton(
              text: 'Set reminder',
              onPressed: _userstate.user.settings.reminderTime != null ? (){
                _userstate.updateUser();
                LocalNotifications.setReminder(
                  reminder:  _userstate.user.settings.reminderTime
                );
                
                Future.delayed(
                  Duration(milliseconds: 100),
                  (){
                    print('QUE PASA CARABASA');

                    String minutes = _userstate.user.settings.reminderTime.minute.toString()  
                    + (_userstate.user.settings.reminderTime.minute < 10 ? '0':'');

                    // the same for  reminderTime.hour
                    // add 0 to  reminderTime.hour if it is less than 10
                    // and add it to minutes

                    String hour =   _userstate.user.settings.reminderTime.hour.toString() + 
                    (_userstate.user.settings.reminderTime.hour < 10 ? '0':'');


                    showInfoDialog(
                    header: 'Reminder set',
                    description: 'You will be reminded to meditate at $hour:$minutes',
                    type:'success'
                    );
                  }
                );
              }:null,
            ),
            SizedBox(height: Configuration.verticalspacing*2),

            BaseButton(
              text: 'Cancel reminder',
              bordercolor: _userstate.user.settings.reminderTime == null ? Configuration.lightgrey : Colors.red,
              color: Configuration.lightgrey,
              border: true,
              textcolor:_userstate.user.settings.reminderTime == null ?  Colors.grey : Colors.red,
              onPressed: _userstate.user.settings.reminderTime != null ? (){
                _userstate.user.settings.reminderTime = null;
                setState(() {});
                _userstate.updateUser();
                
                LocalNotifications.cancelReminder();

              }:null,
            ),

            SizedBox(height: Configuration.verticalspacing*2),

          ],
        ),
      ),

    );
  }
}


class AskTeacherScreen extends StatefulWidget {
  const AskTeacherScreen({Key key}) : super(key: key);

  @override
  State<AskTeacherScreen> createState() => _AskTeacherScreenState();
}

class _AskTeacherScreenState extends State<AskTeacherScreen> {


  TextEditingController _controller = TextEditingController();
  String question = '';

  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);

    return Scaffold(
      appBar: AppBar(
        leading: ButtonBack(color: Colors.black),
        elevation: 1,
        backgroundColor: Configuration.lightgrey,
        title: Text('Ask a teacher', 
          style: Configuration.text('subtitle', Colors.black)
        ),
      ),

      body: Container(
        height: Configuration.height,
        width: Configuration.width,
        padding: EdgeInsets.all(Configuration.smpadding),
        color: Configuration.lightgrey,
        child: Column(
          children: [
            SizedBox(height: Configuration.verticalspacing),
            Text('Send a question to all TMI teachers.  We will update you when we have an answer.', 
              style: Configuration.text('small', Colors.black, font: 'Helvetica'),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Configuration.verticalspacing),


            // a textfield and two buttons, one for sending and other for cancelling
            TextField(
              maxLines: 6,
              controller: _controller,
              minLines: 3,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {
                question = value;
                setState((){});
              },
              style: Configuration.text('small', Colors.black, font:'Helvetica'),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText:'Ask your question' ,
                hintStyle: Configuration.text('small',Colors.grey, font: 'Helvetica'),
                labelStyle: Configuration.text('small',Colors.grey, font: 'Helvetica'),
              ),
            ),

            SizedBox(height: Configuration.verticalspacing*2),

            BaseButton(
              text: 'Send',
              onPressed: question.isNotEmpty && question.length > 5 
              ? () {
                _userstate.sendQuestion(question);
                 // HAY QUE  COMPROBAR SI SE  HA ENVIADO
                question = '';
                _controller.clear();
                FocusManager.instance.primaryFocus?.unfocus();
                setState(() {});

                Future.delayed(
                  Duration(milliseconds: 300),
                  ()=>{
                    showInfoDialog(
                      header: 'Question sent',
                      description: 'We will update you when we have an answer',
                      type: 'success'
                    )
                  }
                );
              } : null,
            ),
            
          ],
        ) 
      ),
    );
  }
}


