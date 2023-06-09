

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:provider/provider.dart';

import '../../mobx/actions/user_state.dart';

class ReminderTimeButton extends StatefulWidget {
  dynamic onchange;

  ReminderTimeButton({Key key,  this.onchange}) : super(key: key);

  @override
  State<ReminderTimeButton> createState() => _ReminderTimeButtonState();
}

class _ReminderTimeButtonState extends State<ReminderTimeButton> {
  TimeOfDay reminderTime;
  
  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);


    return ElevatedButton(
      
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(Configuration.smpadding),
        backgroundColor: Colors.white
      ),
      onPressed: (){
        showTimePicker(
          builder: ((context, child) => TimePickerTheme(
            data: TimePickerThemeData(
              helpTextStyle: Configuration.text('small',  Colors.black)
            ),
            child: child,
          )),
          helpText: "We will remind you every day at the hour you choose",
          minuteLabelText: 'min',
          context: context, 
          initialTime: reminderTime != null ?  reminderTime : TimeOfDay(hour: TimeOfDay.now().hour, minute:0)
        ).then((value)=>{
          if(value != null){
            setState(() {
              _userstate.user.settings.reminderTime=value;
              reminderTime = value;
              if(widget.onchange != null){
                widget.onchange();
              }
            })
          }
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              _userstate.user.settings.reminderTime != null 
              ? 'We will remind you at ${_userstate.user.settings.reminderTime.format(context)}' : 
              'Set a time to be reminded',
              style: Configuration.text('small', Colors.black)
            ),
          ),
          Icon(Icons.calendar_month, color: Colors.black, size: Configuration.smicon),
        ],
      ),
    );
  }
}