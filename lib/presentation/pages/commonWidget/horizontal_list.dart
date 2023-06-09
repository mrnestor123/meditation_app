


import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/contentWidgets/content_card.dart';

import '../../../domain/entities/content_entity.dart';
import '../contentWidgets/content_view.dart';
import '../meditation_screen.dart';



class HorizontalList extends StatelessWidget {


  List<Content> content = new List.empty(growable: true);
  
  
  HorizontalList({Key key, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return content.length > 0 ? 
      Container(
        height: Configuration.width*0.4,
        width: Configuration.width,
        constraints: BoxConstraints(
          maxHeight: 400,
          minWidth: Configuration.width
        ),
        child: ListView.builder(
          padding:EdgeInsets.all(0),
          physics: ClampingScrollPhysics(),
          itemCount:content.length,
          scrollDirection: Axis.horizontal, 
          itemBuilder: (BuildContext context, int index) {  
            Content c = content[index];
            // HAY QUE CAMBIAR CLICKABLESQUARE POR CONTENTSQUARE !>!!
            return  Container(
              margin: EdgeInsets.only(
                right: index == content.length-1 ? Configuration.smpadding:0,
                left: Configuration.smpadding

              ),
              // ESTO NO ES RESIZABLE
              width: Configuration.width*0.4,
              constraints: BoxConstraints(
                maxWidth: 400,
                minWidth: Configuration.width*0.4
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: ContentSquare(
                  content:c,
                )
              ),
            );
          }, 
        ),
      ): Container();
  }
}