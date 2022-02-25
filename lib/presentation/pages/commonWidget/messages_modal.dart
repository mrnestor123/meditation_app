
import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/message.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:provider/provider.dart';



class MessagesIcon extends StatefulWidget {
  Color color;
  MessagesIcon({this.color}) : super();

  @override
  State<MessagesIcon> createState() => _MessagesIconState();
}

class _MessagesIconState extends State<MessagesIcon> {

  UserState _userstate;

  void showMessages(context){
    User user =  _userstate.user;
    _userstate.seeMessages();

    StateSetter stateSetter;

    // HACER DIFERENTES TIPOS DE MENSAJE !!!
    Widget message(Message m){
      return ListTile(
        contentPadding: EdgeInsets.all(Configuration.tinpadding),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            Text(m.username,style: Configuration.text('small', Colors.black)),
            Text(m.text,style: Configuration.text('small',Colors.black, font: 'Helvetica')),
          ],
        ),
        //trailing: ,
        subtitle: Text(
          m.date.toString().substring(0,16),style: Configuration.text('small',Colors.grey)),
        trailing:m.type == 'classrequest' ?
        Row(
          mainAxisSize:MainAxisSize.min,
          children: [
            IconButton(onPressed: (){_userstate.acceptStudent(m, true);  stateSetter((){});},color: Colors.green, icon: Icon(Icons.check_circle_outline),iconSize: Configuration.smicon),
            IconButton(onPressed: (){_userstate.acceptStudent(m, false); stateSetter((){});},color: Colors.red, icon: Icon(Icons.highlight_off),iconSize: Configuration.smicon)        
          ],
        ): IconButton(
          onPressed: (){
            _userstate.deleteMessage(m);
            stateSetter((){});
          }, 
          icon: Icon(Icons.delete),
          color: Colors.red, 
          iconSize: Configuration.smicon
          ), 
      );
    }

    showDialog(
      context: context, 
      builder: (context){
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState ){
            stateSetter = setState;
            return AbstractDialog(
              content: Container(
                height:Configuration.height*0.5,
                width: Configuration.height*0.5,
                decoration: BoxDecoration(
                  color:Colors.white,
                  borderRadius: BorderRadius.circular(Configuration.borderRadius)
                ),
                child: Column(
                  children: [
                    Container(
                      width: Configuration.width,
                      padding: EdgeInsets.all(Configuration.smpadding),
                      decoration: BoxDecoration(
                        color:Configuration.maincolor,
                        borderRadius: BorderRadius.vertical(top:Radius.circular(Configuration.borderRadius))
                      ),
                      child: Center(
                        child: Text('Messages',
                          style:Configuration.text('smallmedium',Colors.white)
                        ),
                      )
                    ),
                    Expanded(
                      child:user.messages.length > 0 ?
                        ListView.separated(
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context,i){
                            return message(user.messages[i]);
                          }, 
                          separatorBuilder: (context,int){
                            return Divider(height:2);
                          }, 
                          itemCount: user.messages.length
                        ) : 
                      Center(
                          child: Padding(
                            padding:  EdgeInsets.all(Configuration.smpadding),
                            child: Text('There are no messages at the moment', style:Configuration.text('small',Colors.black)),
                          )
                        )
                    )
                  ],
                ),
              ),
            );
          }
        );
    }).then((value) => setState((){}));
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);
    List<Message> unreadMessages = _userstate.user.messages.where((element) => !element.read).toList();

    return Stack(
       alignment:Alignment.center,
        children:[
          IconButton(
            onPressed:(){
              showMessages(context);
            }, 
            icon: Icon(Icons.mail),
            color: widget.color != null ? widget.color : Colors.black,
            iconSize: Configuration.smicon
          ),
          unreadMessages.length > 0 ?
          Positioned(
            top:0,
            right:0,
            child: Container(
              padding: EdgeInsets.all(Configuration.tinpadding -
              2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.lightBlue
              ),
              child:  Text(unreadMessages.length.toString(), style: Configuration.text('tiny',Colors.white)),
            ) 
          ):  Container()
        ]
      );
  }
}







void sendMessage({UserState state, User to, then, context}){
    TextEditingController controller = new TextEditingController();

    showDialog(
    context: context, 
    builder: (context){
      return AbstractDialog(
        content: Container(
          padding: EdgeInsets.all(Configuration.smpadding),
          width:Configuration.width,
          height: Configuration.height*0.5,
          decoration: BoxDecoration(
            color:Colors.white,
            borderRadius: BorderRadius.circular(Configuration.borderRadius)
          ),
          child: Column(
            children: [
              Text('Send a message to ' + (to !=null ? to.nombre : 'everyone'),style:Configuration.text('small',Colors.black)),
              SizedBox(height: Configuration.verticalspacing),
              Expanded(
                child: TextField(
                  controller:controller,
                  maxLines:null,
                  decoration: InputDecoration(
                    hintText: 'Write your message here',
                    fillColor: Configuration.lightgrey,
                    filled:true,
                    border: OutlineInputBorder()
                  ),
                  expands: true,
                ),
              ),
              SizedBox(height: Configuration.verticalspacing),
              BaseButton(
                text:'Send Message',
                color: Colors.lightBlue,
                onPressed: (){
                  if(controller.text.isNotEmpty){
                    state.sendMessage(to, 'text', controller.text);
                    Navigator.pop(context);
                  } 
                },
              ),
              SizedBox(height:Configuration.verticalspacing),

              BaseButton(
                text:'Cancel',
                color: Colors.red,
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              
            ],
          ),
        ),
      );
    }).then((value) {if(then !=null){then();}});




}