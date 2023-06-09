


import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../config/configuration.dart';
import '../main.dart';

Widget htmlToWidget(data, {color = Colors.black, double fontsize = 15.0, TextAlign align  = TextAlign.left}){

  //  HAY QUE METERLE ESTILO AL TEXTO
  return Html(
    data: data,
    onLinkTap: ((url, context, attributes, element) {
      Navigator.push(
        navigatorKey.currentContext,
        MaterialPageRoute(
          builder: (context)=> Scaffold(
            appBar: AppBar(
              leading: CloseButton(color: Colors.black),
              backgroundColor:Colors.white,
              elevation: 0,
            ),
            body: WebView(
              initialUrl:url,
              javascriptMode: JavascriptMode.unrestricted),
          ))
      );
    }),
    customImageRenders: {
      networkSourceMatcher():networkImageRender(width: Configuration.width*0.3, loadingWidget: ()=> Container())
    },
    style: {
      "body": Style(
        color: color,
        fontFamily: 'OpenSans',
        textAlign: align,
        fontSize: FontSize(Configuration.htmlTextSize), 
        lineHeight: LineHeight(1.4), 
        margin: EdgeInsets.all(0)
      ),
      "table":Style(
        border:Border.all(color:Colors.grey,width:1)
      ),
      "img": Style(
        width: Configuration.width*0.4,
        alignment: Alignment.center,
      ),
      "td":Style(
        border: Border(top: BorderSide(color:Colors.grey, width:1)),
        padding: EdgeInsets.all(Configuration.smpadding)
      ),
      "ul":Style(
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.all(0),
        alignment: Alignment.center,
        listStyleType: ListStyleType.fromWidget(
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top:Configuration.verticalspacing/2),
                  width: Configuration.width > 500 ? 10 :  7,
                  height: Configuration.width > 500 ? 10 : 7, 
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
        listStylePosition: ListStylePosition.INSIDE,
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.all(0),
        alignment: Alignment.bottomCenter,
        color: color,
        fontSize: FontSize(Configuration.htmlTextSize), 
        textDecorationStyle: TextDecorationStyle.solid
      ),
      "li": Style(
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.symmetric(vertical: Configuration.verticalspacing*1.5)),
      "h2":Style(textAlign: TextAlign.center)
  });

  
}