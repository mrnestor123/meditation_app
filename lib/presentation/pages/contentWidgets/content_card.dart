

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/commonWidget/created_by.dart';
import 'package:meditation_app/presentation/pages/commonWidget/html_towidget.dart';
import 'package:meditation_app/presentation/pages/contentWidgets/content_view.dart';
import 'package:meditation_app/presentation/pages/contentWidgets/meditation_screens.dart';
import 'package:meditation_app/presentation/pages/main.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/content_entity.dart';
import '../../../domain/entities/stage_entity.dart';
import '../../mobx/actions/user_state.dart';
import '../commonWidget/time_chip.dart';
import '../config/configuration.dart';

void selectContent({Content content, dynamic then, Stage stage, List<Content> path}) {

  if(content.isTechnique()){
    // modal bottom sheet 
    showModalBottomSheet(
      context: navigatorKey.currentContext,
      isScrollControlled: true,
      isDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Configuration.borderRadius/2)),
      ),
      builder: (context){
        return Wrap(
          children: [
             Container(
              constraints: BoxConstraints(
                maxHeight: Configuration.height*0.8,
                minHeight: Configuration.height*0.5,
              ),
              child: ListView(
                physics: ClampingScrollPhysics(),
                children: [
                  SizedBox(height: Configuration.verticalspacing),

                  Center(
                    child: Container(
                      width: Configuration.width*0.5,
                      height: Configuration.width*0.5,
                      decoration: BoxDecoration(     
                        borderRadius: BorderRadius.circular(
                          Configuration.borderRadius
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],                             
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Configuration.borderRadius),
                        child: CachedNetworkImage(
                          imageUrl: content.image
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: Configuration.verticalspacing),
                  Padding(
                    padding:EdgeInsets.all(Configuration.smpadding),
                    child: Text(
                      content.title,
                      style: Configuration.text('medium',Colors.black),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(Configuration.smpadding),
                    child: htmlToWidget(
                      content.description
                    ),
                  ),
                  SizedBox(height: Configuration.verticalspacing),
                ],
              ),
            )
          ]
        );
      }
    );

  }else{
    if(content.isRecording()){
      Navigator.push(
        navigatorKey.currentContext,
        MaterialPageRoute(
          builder: (context){
            return CountDownScreen(
              content:content,
              then: then,
            );
          }
        )
      );
    }else{
      Navigator.push(
        navigatorKey.currentContext,
        MaterialPageRoute(
          builder: (context){
            return ContentFrontPage(
              content:content,
              stage: stage,
              path:path,
              then: then,
            );
          }
        )
      );
    }
  }
}






class ContentCard extends StatelessWidget {
  Content content, unlocksContent;
  dynamic onPressed,then;
  bool blocked,seen;

  List<Content> path; 
  String title;





  ContentCard({this.content,this.then, this.path, this.title, this.onPressed, this.blocked = false, this.unlocksContent, this.seen = false ,key}):super(key:key);

  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);
    seen = _userstate.user.contentDone.any((element) => element.cod == content.cod);

    return AspectRatio(
      aspectRatio: Configuration.lessonratio,
      child: Container(
          width: Configuration.width,
          margin: EdgeInsets.only(top:Configuration.verticalspacing),
          child: ElevatedButton(
            onPressed: (){
              if(!blocked){
                selectContent(content: content, then:then, path:path);
              } 
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(0),
              backgroundColor: Colors.white,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Configuration.borderRadius / 3)),
                minimumSize: Size(double.infinity, double.infinity)
              ),
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: content.image != null && content.image != '' ?
                    Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Configuration.borderRadius/3),
                        child: CachedNetworkImage(
                          imageUrl: content.image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.white,
                          ),
                          errorWidget: (context, url, error) =>
                            Icon(Icons.error),
                        ),
                      ),
                    ): Container(),
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(Configuration.smpadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              content.category != null ?
                              Chip(
                                backgroundColor: Colors.lightBlue,
                                avatar: Icon(content.getCategoryIcon(), color: Colors.white, size: Configuration.smicon),
                                label: Text(
                                  content.category.substring(0,1).toUpperCase() +
                                  content.category.substring(1), 
                                  textScaleFactor: 1,
                                  style: Configuration.text('tiny',Colors.white)
                                )
                              )
                              : Icon(
                                content.getIcon(),
                                color: Colors.black, 
                              ), 
    
                              SizedBox(width: Configuration.verticalspacing),
    
    
                              content.isRecording() || content.isVideo() || content.isMeditation() ?
                              TimeChip(c:content, seen: seen , transparent:false, isSmall: true) : 
                              seen ? Icon(Icons.visibility, color: Colors.grey,size: Configuration.smicon) : Container(),
                    
    
                              SizedBox(width: Configuration.verticalspacing),
    
                              /*                              
                              content.isNew != null && content.isNew ?
                              Container(
                                margin: EdgeInsets.only(left: Configuration.blockSizeHorizontal * 1),
                                child: Chip(
                                  backgroundColor: Colors.lightBlue,
                                  label: Text('New', style: Configuration.text('tiny',Colors.white))
                                ),
                              ) : Container(),
                              */

                              content.createdBy != null ?
                              Container(
                                margin: EdgeInsets.only(left: Configuration.blockSizeHorizontal * 1),
                                child: doneChip(
                                  content.createdBy,
                                  small: true
                                )
                              ) : Container(),

                            ],
                          ),
                    
                          
                    
                          
                    
                        ],
                      ),
                    ),
    
    
                    Container(
                      width: Configuration.width*0.7,
                      padding: EdgeInsets.only(left:Configuration.smpadding, right: Configuration.smpadding, bottom: Configuration.smpadding),
child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: Configuration.width * 0.5,
                                maxHeight: Configuration.height * 0.1,
                              ),
                              child: Text(
                                content.title,
                                textScaleFactor: 1,
                                overflow: TextOverflow.fade,
                                style: Configuration.text(
                                  "small",
                                  blocked ? Colors.grey : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
    
                  ],
                ),
              
                /*
                Positioned(
                  left: 0,
                  bottom: 0,
                  right: 0,
                  top: 0,
                  child: AnimatedContainer(
                    padding: EdgeInsets.all(0),
                    key: Key(content.cod),
                    duration: Duration(seconds: 2),
                    child: blocked
                        ? Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.lock, size: Configuration.smicon),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: Configuration.smpadding),
                                child: Text(
                                  _userstate.user.stagenumber < content.stagenumber && content.position == 0 ? 
                                  "Unlocked when you reach stage " + (_userstate.user.stagenumber+1).toString() :
                                  'Unlocked after ' + 
                                    (  unlocksContent.type == 'meditation-practice' ? 'doing ' 
                                      : unlocksContent.type == 'video' ? 'watching '
                                      : 'reading '
                                    ) + unlocksContent.title,
                                    style: Configuration.text('tiny', Colors.white),
                                    textAlign: TextAlign.center),
                              ),
                            ],
                          ))
                        : Container(),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            Configuration.borderRadius / 3),
                        color: blocked
                            ? Colors.grey.withOpacity(0.8)
                            : Colors.transparent),
                    curve: Curves.fastOutSlowIn,
                  ),
                ),

                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: content.image != null && content.image != '' ?
                    Container(
                      height:  Configuration.height * 0.09,
                      width:  Configuration.height * 0.09,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Configuration.borderRadius/3),
                        child: CachedNetworkImage(
                          imageUrl: content.image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.white,
                          ),
                          errorWidget: (context, url, error) =>
                            Icon(Icons.error),
                        ),
                      ),
                    ): Container(),
                )*/
              ],
            ),
          ),
        ),
    );
   }
}




// HAY QUE AÑADIR AQUI EL WIDGET DE  CUADRADO !!
class ContentSquare extends StatelessWidget {
  Content content;
  Stage stage;
  bool blocked, seen;
  Function then;

  ContentSquare({ this.content,this.blocked = false, this.then, this.stage}) : super();

  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);
    blocked = _userstate.user.isContentBlocked(content);
    seen = _userstate.user.contentDone.any((element) => element.cod == content.cod);


    return AspectRatio(
      aspectRatio: 1,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.all(0),
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Configuration.borderRadius/2)),
            minimumSize: Size(double.infinity, double.infinity)
        ),
        onPressed: () {
          // DEBERÍAMOS BLOQUEAR ?
          if(!blocked){
            selectContent(content: content, then: then, stage: stage);
          }
        },
        child: Stack(
          children: [
            Positioned.fill(child: ClipRRect(
              borderRadius: BorderRadius.circular(Configuration.borderRadius/2),
              child: Container(color: Colors.white))
            ),
        
            Positioned.fill(child:ClipRRect(
              borderRadius: BorderRadius.circular(Configuration.borderRadius/2),
              child: content.image != null && content.image != '' ? 
              CachedNetworkImage(
                fit: BoxFit.contain,
                imageUrl: content.image
              ) : Container(),
            )),

            Positioned(
              top: 10,
              left: 5,
              child: Row(
                children: [
                  content.isMeditation() ?
                  TimeChip(c:content, seen: seen , transparent:false, isSmall: true) : 
                  seen ? Icon(Icons.visibility_sharp, color: Colors.lightBlue,size: Configuration.smicon) : 
                  Container(),
                ],
              )
            ),
              
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(12.0),
                    bottomLeft: Radius.circular(12.0),
                  ),
                  color: blocked ? Colors.transparent : Colors.black.withOpacity(0.5),
                ),
                child: Center(
                  child: Text(
                    content.title,
                    style: Configuration.text('small', Colors.white),
                    textAlign: TextAlign.center,
                  ),
                )
              )
            ),
        
            Positioned.fill(
              child: AnimatedContainer(
                padding: EdgeInsets.all(0),
                //key: Key(text),
                duration: Duration(seconds: 2),
                decoration:BoxDecoration(
                  color: blocked
                  ? Colors.black.withOpacity(0.7).withOpacity(0.8)
                  : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: blocked ?
                  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.lock, size:Configuration.smicon,color: Colors.white),
                    SizedBox(height: 4),
                    Text('This lesson is blocked', style: Configuration.text('tiny', Colors.white), textAlign: TextAlign.center,)
                  ],
                ): Container(), 
              ),
            ),
        
            /*
            rightlabel != null ?
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.only(right:4, top:4),
                child: rightlabel,
              ),
            ): Container(),*/
          ],
        )
      ),
    );
  }
}
