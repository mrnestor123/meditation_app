


import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../config/configuration.dart';

Widget htmlToWidget(data, {color = Colors.black, double fontsize = 15.0}){

  //  HAY QUE METERLE ESTILO AL TEXTO
  return Html(
    data: data,
    style: {
      "body": Style(color: color,fontSize: FontSize(fontsize), lineHeight: LineHeight(1.2)),
      "table":Style(
        border:Border.all(color:Colors.grey,width:1)
      ),
      "td":Style(
        border:Border(top: BorderSide(color:Colors.grey, width:1)),
        padding: EdgeInsets.all(Configuration.smpadding)
      ),
      "ul":Style(
        alignment: Alignment.center,
        listStyleType: ListStyleType.fromWidget(
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top:5),
                  width: 9,
                  height: 9, 
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    border: Border.all(
                      color: color
                    )
                  ),
                ),
              ),
            ],
          )
        )
      ),
      "ol":Style(
        color: color,
        textDecorationStyle: TextDecorationStyle.solid
      ),
      "li": Style(
        markerContent: Container(child: Text('QUE PASA')),
        margin: EdgeInsets.symmetric(vertical: Configuration.verticalspacing*1.5)),
      "h2":Style(textAlign: TextAlign.center)
  });

  
}