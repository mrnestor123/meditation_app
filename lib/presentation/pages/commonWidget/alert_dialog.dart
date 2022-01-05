
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';

void showAlertDialog({String title,String text, onYes, context, onNo}){

  showDialog(
    context: context, 
    builder: (_){
        return AbstractDialog(
          content: Container(
            padding:EdgeInsets.all(Configuration.smpadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Configuration.borderRadius),
              color:Colors.white
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                title != null ? 
                Text(title,style: Configuration.text('small',Colors.black)) : Container(),
                SizedBox(height: Configuration.verticalspacing,),
                text != null ? 
                Text(text,style: Configuration.text('tiny',Colors.grey)): Container(),
                SizedBox(height: Configuration.verticalspacing),
                BaseButton(
                  noelevation: true,
                  text: 'No',
                  textcolor: Colors.black,
                  color:Colors.white,
                  border:true,
                  onPressed:(){
                     if(onNo != null){
                      onNo();
                    }
                    Navigator.pop(context);
                  }
                ),
                SizedBox(height: Configuration.verticalspacing),
                BaseButton(
                  noelevation: true,
                  onPressed:(){
                    if(onYes != null){
                      onYes();
                    }
                    Navigator.pop(context);Navigator.pop(context); 
                  }, 
                  text: 'Yes'
                )
              ],
            ),
          )
        );
     /* }else{
        return CupertinoAlertDialog(
          content: Text(text),

          actions: [
            CupertinoDialogAction(
              child: Text('No')
            ),
            CupertinoDialogAction(
              child: Text('Yes')
            ),
          ],
        );
      }*/
    }
  );


  if(Platform.isIOS){

  }

}