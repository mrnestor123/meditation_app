

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/profile_widget.dart';
import 'package:meditation_app/presentation/pages/commonWidget/progress_dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/content_entity.dart';
import '../../../domain/entities/meditation_entity.dart';
import '../../mobx/actions/meditation_state.dart';
import '../config/configuration.dart';
import '../main.dart';
import '../profile_widget.dart';

// podría estar en meditation screen
Future<dynamic> meditationModal(Meditation m) {
    
    MeditationState _meditationstate = Provider.of<MeditationState>(navigatorKey.currentContext,listen: false);

    UserState _userstate = Provider.of<UserState>(navigatorKey.currentContext,listen: false);
    
    if(m.duration != null){
      return showModalBottomSheet(
            context: navigatorKey.currentContext, 
            builder: (context){
              return Padding(
                padding: EdgeInsets.symmetric(horizontal:Configuration.smpadding),
                child: Column(mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: Configuration.verticalspacing*3),
                    Row(
                      children: [
                        Flexible(
                          flex:2,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Configuration.borderRadius/2),
                            child: CachedNetworkImage(imageUrl: m.image))
                        ),
                        SizedBox(width: Configuration.verticalspacing),
                        Flexible(
                          flex:4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(m.title, style:Configuration.text('medium', Colors.black)),
                              SizedBox(height: Configuration.verticalspacing/2),
                              Text( m.description.isNotEmpty ? m.description : ' ',style:Configuration.text('small',Colors.grey)),
                              SizedBox(height: Configuration.verticalspacing/2),
                              Row(
                                children: [
                                  Icon(Icons.timer, size:  Configuration.smicon, color: Colors.lightBlue),
                                  SizedBox(width: Configuration.verticalspacing),
                                  Text(m.duration.inMinutes.toString() + ' min ', style: Configuration.text('small',Colors.black.withOpacity(0.8))),
                                  SizedBox(width: Configuration.verticalspacing*2),
                                  Chip(
                                    avatar: Icon(m.getIcon(), size: Configuration.smicon, color: Colors.lightBlue),
                                    label:Text(m.getText(),style: Configuration.text('small',Colors.black)),
                                  )
                                ]
                              ),
                              m.createdBy != null ? 
                              GestureDetector(
                                onTap: ()=>{
                                  /*
                                   Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                        
                                      )
                                    ),
                                  )*/
                                },
                                child: Chip(
                                  backgroundColor: Colors.lightBlue,
                                  
                                  avatar: ProfileCircle(userImage: m.createdBy['image'], width: Configuration.smicon, bordercolor: Colors.white),
                                  label: Text('Created by ' + m.createdBy['nombre'], style: Configuration.text('small', Colors.white),),
                                  ),
                              )
                              : Container(),


                              
                            ],
                          )
                        )
                      ],
                    ),
                    SizedBox(height: Configuration.verticalspacing),
                    BaseButton(
                      text: 'Start',
                      onPressed: (){
                        _meditationstate.setDuration(m.duration.inMinutes);
                        
                        // _meditationstate.selectMeditation(m);
                        
                        Navigator.pop(context);
                        
                        Navigator.pushNamed(context, '/countdown');
                      },
                    ),
                    SizedBox(height: Configuration.verticalspacing*3)
                  ],
                ),
              );
            });
    }
  }






class TimeChip extends StatelessWidget {
  UserState _userstate;
  Duration seenTime;
  bool finished = false;

  String getTime(Duration d){
    String time = '';

    if(seenTime != null && !finished){    
      d = d - seenTime;
    }

    if(d.inHours >= 1){
      time += d.inHours.toString() + ' h ';
    }

    if(d.inMinutes % 60 > 0){
      time += (d.inMinutes % 60).toString()  + ' m';
    }

    if(seenTime != null && !finished){
      time += ' left';
    }

    return time;
  }

  Content c;
  
  TimeChip({
    this.c,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);
    
    if(_userstate.user.contentDone.length > 0){ 
      dynamic content = _userstate.user.contentDone.firstWhere((element) => element.cod == c.cod,
        orElse: (){}
      );

      if(content != null  && content.done != null){
        seenTime = content.done;
        finished = seenTime.inMinutes >= c.total.inMinutes;
      }
    }  

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
       
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(Configuration.borderRadius) ,
          ),
          child: Row(
            children: [
              Icon(Icons.timer,size: Configuration.tinicon, color:seenTime != null && !finished ? Colors.lightBlue :Colors.black),
              SizedBox(width: Configuration.verticalspacing/2),
              Text(getTime(c.total),style: Configuration.text('small',seenTime != null && !finished ? Colors.lightBlue:  Colors.black))
            ],
          ),
        ),
        SizedBox(width: Configuration.verticalspacing),
        
        finished ? 
        Icon(Icons.visibility,color: Colors.lightBlue)
        : Container(),
      ],
    );
  }
}



