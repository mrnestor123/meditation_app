

import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/main.dart';

void showErrorDialog({String header, String description}){
  showDialog(
    barrierDismissible: false,
    context: navigatorKey.currentContext, 
    builder: (context){
      return AbstractDialog(
        content: Container(
          color: Colors.white,
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
                    Icons.error,
                    color: Colors.red,
                    size: Configuration.medicon,
                  ),
                  SizedBox(width: Configuration.verticalspacing),
                  Text(
                    header != null ? header : 'An error has ocurred', style:Configuration.text('medium',Colors.black)
                  ),
                ],
              ),
              SizedBox(height: Configuration.verticalspacing*2),
              Text(description, style:Configuration.text('small',Colors.black,font:'Helvetica')),
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