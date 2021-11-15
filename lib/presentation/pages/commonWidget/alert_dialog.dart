
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';

void showAlertDialog({String title,String text, onYes, context}){

  showDialog(
    context: context, 
    builder: (_){
        return AlertDialog(
          title: Text(title,style: Configuration.text('small',Colors.black)),
          content: Text(text,style: Configuration.text('tiny',Colors.grey)),
          actions: [
            TextButton(
              onPressed:()=> Navigator.pop(context), 
              child: Text('No',style: Configuration.text('small',Colors.black))
            ),
            TextButton(
              onPressed:(){
                if(onYes != null){
                  onYes();
                }
                Navigator.pop(context);Navigator.pop(context); 
              }, 
              child: Text('Yes',style: Configuration.text('small',Colors.black),)
            )
          ],
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