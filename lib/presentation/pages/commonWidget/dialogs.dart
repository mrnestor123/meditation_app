
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';

import '../main.dart';
import 'html_towidget.dart';

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
                Text(text,style: Configuration.text('small',Colors.black,font:'Helvetica')): Container(),
                SizedBox(height: Configuration.verticalspacing),
                
                customWidget != null ? customWidget : Container(),
                !hideNoButton ?
                BaseButton(
                  text: noText  !=  null ? noText : 'No',
                  textcolor: Colors.black,
                  color:Colors.black,
                  border:true,
                  onPressed:(){
                     if(onNo != null){
                      onNo();
                    }
                    Navigator.pop(context);
                  }
                ): Container(),
                
                SizedBox(height: Configuration.verticalspacing,),

                !hideYesButton ?
                BaseButton(
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



//Dialog for everyone
class AbstractDialog extends StatelessWidget {
  final Widget content;

  AbstractDialog({this.content});
  

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding:EdgeInsets.all(Configuration.smpadding),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: content);
  }
}


Future showInfoDialog({String header, String description, String type  = 'error',  String html,  Key key}){
   return showDialog(
    barrierDismissible: false,
    context: navigatorKey.currentContext, 
    useSafeArea: false,
    builder: (context){
      return AbstractDialog(
        content: Container(
          key: key != null ?  key : GlobalKey(),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              Configuration.borderRadius/3
            ),
          ),
          padding: EdgeInsets.all(Configuration.smpadding),
          //ESTO SE TENDRA QUE HACER PARA IPAD TAMBIEN !!!
          width: Configuration.width * 0.6,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment:MainAxisAlignment.center,
                children: [
                  Icon(
                    type == 'help' ?
                    Icons.help :
                    type == 'info' ? 
                    Icons.info_outline :
                    type  == 'error' ?
                    Icons.error: Icons.check_circle,
                    color:type  == 'error' ? Colors.red  : type == 'info' || type == 'help'  ? Colors.lightBlue : Colors.green,
                    size: Configuration.medicon,
                  ),
                  html == null ?  SizedBox(width: Configuration.verticalspacing) : Container(),
                  html == null && header != null ?
                  Flexible(
                    child: Text(
                      header != null ? header : 'An error has ocurred', style:Configuration.text('subtitle',Colors.black)
                    ),
                  ) : Container(),
                ],
              ),
              
              SizedBox(height: Configuration.verticalspacing*2),
              
              html != null ?
              htmlToWidget(html) : Container(),
              
              description != null && description.isNotEmpty ?
              Text(
                description, 
                style:
                header == null ? 
                Configuration.text('smallmedium',Colors.black):
                Configuration.text('small',Colors.black,font:'Helvetica')
              ) :  Container(),
              SizedBox(height:Configuration.verticalspacing*3),
              
              BaseButton(
                text:'OK',
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          )
        )
      );
    });
}
