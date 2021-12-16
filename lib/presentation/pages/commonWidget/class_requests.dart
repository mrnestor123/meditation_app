
import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/message.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';

void showClassRequests(context,User user){
  var messages ={
    'classrequest': '',
  };


  Widget message(Message r){
    return ListTile(
      contentPadding: EdgeInsets.all(Configuration.tinpadding),
      title: Text(r.username + ' has requested a class',style: Configuration.text('small',Colors.black)),
      subtitle: Text(r.date.toString(),style: Configuration.text('small',Colors.grey)),
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
                padding: EdgeInsets.all(Configuration.tinpadding),
                decoration: BoxDecoration(
                  color:Configuration.maincolor,
                  borderRadius: BorderRadius.vertical(top:Radius.circular(Configuration.borderRadius))
                ),
                child: Center(
                  child: Text('Class Requests', 
                    style:Configuration.text('smallmedium',Colors.white)
                  ),
                )
              ),
              Expanded(
                child:
                user.messages.length > 0 ?
                  ListView.separated(
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
                      child: Text('There are no class requests at the moment', style:Configuration.text('small',Colors.black)),
                    )
                  )
                
                )
            ],
          ),
        ),
      );
    });


}