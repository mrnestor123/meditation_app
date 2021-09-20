
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';

void  stageDialog(context,stage){
  showGeneralDialog(
        context: context,
        barrierLabel: 'dismiss',
        barrierDismissible: true,
        pageBuilder:(context, anim1, anim2) {
          return AbstractDialog(
            content: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: Colors.white),
              padding: EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(image: NetworkImage(stage.shortimage)),
                  Html(data: stage.shorttext)
                ],
              ),
            ),
            );
      });
}