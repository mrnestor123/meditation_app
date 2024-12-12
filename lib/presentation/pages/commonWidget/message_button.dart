import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialogs.dart';
import 'package:meditation_app/presentation/pages/commonWidget/profile_widget.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/user_entity.dart';
import '../../mobx/actions/user_state.dart';
import '../config/configuration.dart';

class ChatDialog extends StatefulWidget {
  User user;

  ChatDialog({Key key, this.user}) : super(key: key);

  @override
  State<ChatDialog> createState() => _ChatDialogState();
}


class _ChatDialogState extends State<ChatDialog> {

  String text;
    
  Widget sendMessage(){
    return TextField( 
      textCapitalization: TextCapitalization.sentences,
      maxLines:4,
      maxLength: 400,
      decoration: InputDecoration(
        hintText: 'Write your message here',
        hintStyle: Configuration.text('small', Colors.grey, font: 'Helvetica'),
        fillColor: Colors.white,
        filled:true,
        border: OutlineInputBorder()
      ),
      onChanged: (value) => {
        setState((){
          text = value;
        })
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var _userstate = Provider.of<UserState>(context);

    return AbstractDialog(
      content: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            Configuration.borderRadius/3
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Configuration.borderRadius/3),
                    topRight: Radius.circular(Configuration.borderRadius/3)
                  ),
                  color: Configuration.maincolor
                ),
               child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Contact to', style: Configuration.text('small', Colors.white)),
                  SizedBox(width: Configuration.verticalspacing),
                  Chip(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Configuration.borderRadius/2),
                      side: BorderSide(
                        color: Colors.grey,
                        width: 0.5
                      )
                    ),
                    avatar: ProfileCircle(
                      userImage: widget.user.image,
                    ),
                    
                    label: Text('${widget.user.nombre}')
                    
                  ),
                ],
                         ),
             ),

            Container(
              padding: EdgeInsets.all(Configuration.smpadding),
              child: Column(
                children: [
                  Text('Feel free to send a mail to ${widget.user.nombre}, he will contact you as soon as possible',
                    style: Configuration.text('tinyu', Colors.black, font: 'Helvetica'),
                  ),
            
                  SizedBox(height: Configuration.verticalspacing*1.5),
                  
                  sendMessage(),
                  
                  SizedBox(height: Configuration.verticalspacing*2),
                  BaseButton(
                    text: 'Send message',
                    color: text == null || text.length < 10 ? Configuration.lightgrey : Configuration.maincolor,
                    textcolor: text == null || text.length < 10 ? Configuration.lightgrey : Configuration.maincolor,
                    onPressed: text == null || text.length < 10 ? null : 
                    (){
                      
                      _userstate.sendMessage(
                        text: text,
                        to: widget.user
                      );
                      
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: Configuration.verticalspacing*2),
                  BaseButton(
                    text: 'Cancel',
                    color: Colors.red,
                    onPressed: (){
                      
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}