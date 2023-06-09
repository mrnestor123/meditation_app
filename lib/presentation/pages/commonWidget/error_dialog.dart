

import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/html_towidget.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/main.dart';

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