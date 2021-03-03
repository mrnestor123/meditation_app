
import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';
import 'package:provider/provider.dart';

import 'config/configuration.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings'),),
      body: ListView(
        children: [
          RaisedButton(
          onPressed: () => showGeneralDialog(
              barrierColor: Colors.black.withOpacity(0.5),
              transitionBuilder: (context, a1, a2, widget) {
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
              pageBuilder: (context, animation1, animation2) {}),
          child: Padding(
            padding: EdgeInsets.all(Configuration.smpadding),
            child: Text('Increase Stage',
                style: Configuration.text('big', Colors.white)),
          ),
        )
        ],
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
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          padding: EdgeInsets.all(Configuration.smpadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'You are going to change to the next stage while not finishing the stage before',
                  style: Configuration.text('small', Colors.black)),
              SizedBox(height: Configuration.height * 0.05),
              Text('Are you sure?',
                  style: Configuration.text('small', Colors.black)),
              SizedBox(height: Configuration.height * 0.01),
              RaisedButton(
                  onPressed: ()=> _userstate.updateStage(),
                  child: Padding(
                    padding: EdgeInsets.all(Configuration.smpadding),
                    child: Text('Yes'),
                  ))
            ],
          )),
    );
  }
}
