//CARD CON LA STAGE 

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialogs.dart';
import 'package:meditation_app/presentation/pages/commonWidget/html_towidget.dart';
import 'package:meditation_app/presentation/pages/commonWidget/radial_progress.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/commonWidget/wrapper_container.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import '../../../domain/entities/user_entity.dart';
import '../path_screen.dart';
import '../mainpages/stage_screen.dart';

class StageCard extends StatefulWidget {
  
  StageCard({
    this.stage, 
    this.expanded = false, 
    this.user,
    this.then
  });

  final Stage stage;
  final bool expanded;
  final User user;
  final Function then;

  @override
  State<StageCard> createState() => _StageCardState();
}

class _StageCardState extends State<StageCard> {
  
  @override
  Widget build(BuildContext context) {
    // HACER ESTO UNA VEZ???
    widget.stage.checkPercentage(widget.user);
    bool blocked = widget.stage.blocked && !widget.user.isAdmin();

    return Stack(
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.grey, width: 0.5),
            backgroundColor: Colors.white,
            padding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Configuration.borderRadius/2)
            ),
          ),
          onPressed: () => {
            if(!widget.expanded && !blocked){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StageView(stage: widget.stage) 
                )
              ).then((value){
                setState(()=>{});
                if(widget.then != null){
                  widget.then(value);
                }  
              }),
            }else if(!widget.expanded){
              showDialog(
                context: context,
                builder: (_) => AbstractDialog(
                    content: Container(
                      padding: EdgeInsets.all(Configuration.smpadding),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(Configuration.borderRadius / 2)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info, size: Configuration.smicon,color: Colors.blue),
                          SizedBox(height: Configuration.verticalspacing),

                          Text(
                            "This stage is blocked, we are working on adding more content to it" ,
                            //"You need to finish milestone " + _userstate.data.milestones[s.prevmilestone].title + " to unlock this stage",
                            style: Configuration.text('small', Colors.black,font: 'Helvetica')
                          )
                        ],
                      )
                    )
                  )
                )
              
            }
          },
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Configuration.borderRadius/2),
                      topRight: Radius.circular(Configuration.borderRadius/2),
                    ),
                    child: Stack(
                      children: [
                        widget.stage.shortimage == null || widget.stage.shortimage.isEmpty  
                        ? Container()
                        : CachedNetworkImage(
                          width: Configuration.width,
                          height: Configuration.height*0.15,
                          imageUrl: widget.stage.shortimage,
                          placeholder: (context, url) => Container(
                            width: Configuration.width,
                            height: Configuration.height*0.15,
                          ),
                          fit: BoxFit.cover,
                        ),
                  
                        Positioned(
                          left: 10,
                          top: 10,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: widget.stage.percentage >= 100 ? Colors.green : Colors.white
                            ),
                            padding: EdgeInsets.all(4),
                            child:  widget.stage.percentage >= 100 ? 
                              Padding(
                                padding: EdgeInsets.all(Configuration.tinpadding),
                                child: Icon(Icons.check, color: Colors.white, size: 20),
                              ) :
                              RadialProgress(
                              goalCompleted: widget.stage.percentage/100,
                              key: Key(widget.stage.percentage.toString()),
                              width: 4,
                              progressColor: Colors.lightBlue,
                              progressBackgroundColor: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.all(Configuration.tinpadding),
                                child: Center(
                                  child: Text(
                                    widget.stage.percentage.toString() + '%',
                                    style: Configuration.text('tiny', Colors.lightBlue)
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )),
                  
                  
                  Container(
                    padding: EdgeInsets.all(Configuration.smpadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: Configuration.verticalspacing),
                        Text (widget.stage.title, 
                          style: Configuration.text('subtitle', Colors.black)
                        ),
                        SizedBox(height: Configuration.verticalspacing),
                        Text(widget.stage.description, 
                          style: Configuration.text('small',Colors.grey)
                        )
                      ],
                    ),
              
                    
                  ),
              
                  widget.expanded && widget.stage.obstacles != null  ?  
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: Configuration.width,
                          color: Colors.grey,
                          height: 0.5,
                        ),
                        Container(
                          padding: EdgeInsets.all(Configuration.smpadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.check_box_outlined, color: Colors.black),
                                  SizedBox(width: Configuration.verticalspacing),
                                  Text('Objectives', style: Configuration.text('small',Colors.black)),
                                ],
                              ),

                              SizedBox(height: Configuration.verticalspacing),
                        
                              Text(
                                widget.stage.goals,
                                style: Configuration.text('small',Colors.black, font:'Helvetica')
                              ),

                              SizedBox(height: Configuration.verticalspacing),
                              
                              Row(
                                children: [
                                  Icon(Icons.warning,
                                    color: Colors.black
                                  ),

                                  SizedBox(
                                    width: Configuration.verticalspacing,
                                  ),

                                  Text('Obstacles', 
                                    style: Configuration.text('small',Colors.black)
                                  )

                                ],
                              ),
                      
                              SizedBox(height: Configuration.verticalspacing),
                      
                              Text(widget.stage.obstacles,
                                style: Configuration.text('small',Colors.black, font:'Helvetica')
                              ),

                              SizedBox(height: Configuration.verticalspacing),
                      
                              Row(
                                children: [
                                  Icon(Icons.star,
                                    color: Colors.black
                                  ),
                                  SizedBox(
                                    width: Configuration.verticalspacing,
                                  ),
                                  Text('Mastery', 
                                    style: Configuration.text('small',Colors.black)
                                  )
                                ],
                              ),
                              
                      
                              SizedBox(height: Configuration.verticalspacing),
                      
                              Text(widget.stage.mastery,
                                style: Configuration.text('small',Colors.black, font:'Helvetica')
                              )
                            ],
                          ),
                        ),
                      ],
                    ): Container(),
                ],
              ),
           
              blocked? 
              Positioned.fill(
              child: AnimatedContainer(
                padding: EdgeInsets.all(0),
                key: Key(widget.stage.stagenumber.toString()),
                duration: Duration(seconds: 2),
                child: blocked
                    ? Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.lock, size: Configuration.smicon, color: Colors.white),
                        SizedBox(height: 10),
                        Text('Locked', 
                          style: Configuration.text('small', Colors.white)
                        )
                      ],
                    )) : Container(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Configuration.borderRadius / 3),
                  color: widget.stage.blocked
                    ? Colors.grey.withOpacity(0.8)
                    : Colors.transparent
                ),
                curve: Curves.fastOutSlowIn,
              )
            ) :Container()
      
            ],
          ),
        ),
      
      
       
      ],
    );
  }
}