
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';

void showAlertDialog({
  String title,String text, onYes, context, yesText,
  onNo, noText, noPop = false,  hideYesButton = false, String buttonText,
  Widget customWidget, hideNoButton = false, bool dismissible = true
 }){
  showDialog(
    context: context, 
    barrierDismissible: dismissible,
    builder: (_){
        return AbstractDialog(
          content: Container(
            padding:EdgeInsets.all(Configuration.medpadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Configuration.borderRadius),
              color:Colors.white
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title != null ? 
                Text(title,style: Configuration.text('subtitle',Colors.black)) : Container(),
                SizedBox(height: Configuration.verticalspacing,),
                text != null ? 
                Text(text,style: Configuration.text('small',Colors.grey,font:'Helvetica')): Container(),
                SizedBox(height: Configuration.verticalspacing*2),
                customWidget != null ? customWidget : Container(),
                !hideNoButton ?
                BaseButton(
                  noelevation: true,
                  text: noText  !=  null ? noText : 'No',
                  textcolor: Colors.black,
                  color:Colors.white,
                  border:true,
                  onPressed:(){
                     if(onNo != null){
                      onNo();
                    }
                    Navigator.pop(context);
                  }
                ): Container(),
                SizedBox(height: Configuration.verticalspacing),
                
                !hideYesButton ?
                BaseButton(
                  noelevation: true,
                  onPressed:(){
                    Navigator.pop(context);

                    if(onYes != null){
                      onYes();
                    }
                   
                    // ESTO ESTÁ MAL GESTIONADO !!!
                    if(!noPop){
                      Navigator.pop(context); 
                    }
                  }, 
                  text: yesText != null ? yesText  : 'Yes'
                ): Container(),
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