
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/html_towidget.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';

import '../../../domain/entities/stage_entity.dart';

Future stageDialog(context,Stage stage){
  return showGeneralDialog(
        context: context,
        barrierLabel: 'dismiss',
        barrierDismissible: true,
        pageBuilder:(context, anim1, anim2) {
          return AbstractDialog(
            content: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Configuration.borderRadius/2), color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(Configuration.borderRadius/2)),
                    child: Image(
                      width: Configuration.width,
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(stage.shortimage)
                    )
                  ),
                  
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: Configuration.height*0.6,
                      minHeight: Configuration.height*0.2,
                    ),
                    child: ListView(
                      physics: ClampingScrollPhysics(),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: htmlToWidget(stage.shorttext),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            );
      });
}