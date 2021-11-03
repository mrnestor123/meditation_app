
import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/mobx/login_register/login_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';
import 'package:provider/provider.dart';

import 'config/configuration.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);
    final _loginstate = Provider.of<LoginState>(context);

    Widget menuButton(){
      

    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings',style: Configuration.text('medium', Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context), color: Colors.black),
      ),
      body: Container(
        color: Configuration.lightgrey,
        width: Configuration.width,
        padding: EdgeInsets.all(Configuration.smpadding),
        child: Column(
          children: [
            SizedBox(height: 10),
            Container(
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
                onPressed: () => showGeneralDialog(
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
                  pageBuilder: (context, animation1, animation2) {}) ,             
                child: Text('Increase Stage',style: Configuration.text('small', Colors.black) )
              ),
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
                    padding: EdgeInsets.all(12)
                  ),
                  onPressed: () { 
                  _userstate.user=null;
                  _loginstate.logout();
                  Navigator.pushReplacementNamed(context, '/welcome');
                }, child: Text('LOG OUT',style: Configuration.text('small', Colors.white),)),
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


