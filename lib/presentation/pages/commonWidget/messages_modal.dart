
import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/message.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';

void showMessages(context,UserState state){
  

  User user =  state.user;

  // HACER DIFERENTES MENSAJES !!!
  Widget message(Message m){





    return ListTile(
      contentPadding: EdgeInsets.all(Configuration.tinpadding),
      title: Text(m.text,style: Configuration.text('small',Colors.black)),
      subtitle: Text(m.date.toString(),style: Configuration.text('small',Colors.grey)),
      trailing:m.type == 'classrequest' ?
       Row(
        mainAxisSize:MainAxisSize.min,
        children: [
          IconButton(onPressed: ()=> {state.changeRequest(m, true)},color: Colors.green, icon: Icon(Icons.check_circle_outline),iconSize: Configuration.smicon),
          IconButton(onPressed: ()=> {state.changeRequest(m, false)},color: Colors.red, icon: Icon(Icons.highlight_off),iconSize: Configuration.smicon)        
        ],
      ): Container(), 
    );
  }

  showDialog(
    context: context, 
    builder: (context){
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
                child:
                user.messages.length > 0 ?
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
    });

}