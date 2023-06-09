
//CARD CON LA STAGE 

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/presentation/pages/commonWidget/radial_progress.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/learn_screen.dart';
import 'package:meditation_app/presentation/pages/path.dart';

import '../../../domain/entities/user_entity.dart';

class StageCard extends StatefulWidget {
  StageCard({
    this.learnscreen = false, 
    this.stage, 
    this.onPressed,
    this.background,
    this.textcolor, 
    this.showButtons = false, 
    this.user,
    this.then
  });

  final Stage stage;
  final Color background;
  final Color textcolor;
  final bool showButtons;
  final User user;
  final bool learnscreen;
  final Function then;
  final Function onPressed;

  @override
  State<StageCard> createState() => _StageCardState();
}

class _StageCardState extends State<StageCard> {
  @override
  Widget build(BuildContext context) {
    // HACER ESTO UNA VEZ???
    widget.stage.checkPercentage(widget.user);

    return Wrap(
      children:[Container(
      width: Configuration.width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(Configuration.borderRadius)),
      child: ElevatedButton(
        onPressed: () => 
          widget.onPressed != null ? 
          widget.onPressed() :
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => widget.learnscreen ?
              StageView(stage: widget.stage) :
              ImagePath(stage: widget.stage)
            )
          ).then((value){
            setState(()=>{});
            if(widget.then != null){
              widget.then(value);
            }  
          }),
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [ 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: Configuration.width*0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Stage ' + widget.stage.stagenumber.toString(),style: Configuration.text('subtitle', widget.textcolor != null ? widget.textcolor : Colors.white)),
                      SizedBox(height: Configuration.verticalspacing),
                      Text(widget.stage.description,style: Configuration.text('small',Colors.white)),
                    ],
                  )
                ),
                RadialProgress(
                  width: 4,
                  goalCompleted: widget.stage.percentage/100,
                  key: Key(widget.stage.percentage.toString()),
                  progressColor: Colors.lightBlue,
                  progressBackgroundColor: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(Configuration.tinpadding),
                    child: Center(
                      child: Text(
                        widget.stage.percentage.toString() + '%',
                        style: Configuration.text('tiny', Colors.white)
                      ),
                    ),
                  ),
                ),
              ],
            ),
    
            SizedBox(height: Configuration.verticalspacing),

            // image of  the path
            Container(
              constraints: BoxConstraints(
                minWidth: Configuration.width
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Configuration.borderRadius/2),
                child:CachedNetworkImage(
                  // loading image
                  imageUrl: widget.stage.shortimage,
                  placeholder: (context, url) => Container(
                    width: Configuration.width,
                    height: widget.stage.stagenumber < 3 ?
                      Configuration.height*0.12:
                      Configuration.height*0.15,
                  ),
                  fit: BoxFit.cover,
                )
              ),
            ),
            
            /*
            showButtons && false ?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  flex: 3,
                  child: Container(
                    width: Configuration.width*0.35,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Configuration.lightgrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)
                        )
                      ),
                      onPressed: ()=>{
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StageView(
                              stage: stage,
                            )
                          ),
                        )
                      }, 
                      child:Text('Learn',style: Configuration.text('tiny', Colors.black)),
                    ),
                  ),
                ),
                
                Flexible(
                  flex: 3,
                  child: Container(
                    width: Configuration.width*0.35,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Configuration.lightgrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)
                        )
                      ),
                      onPressed: ()=>{
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImagePath(stage: stage)
                          )
                        )
                      }, 
                      child: Text('Path',style: Configuration.text('tiny', Colors.black),) 
                    ),
                  ),
                ),
              ],
            ) : Container()*/
          
          
          
          ],
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          primary: this.widget.background != null ? this.widget.background : Configuration.maincolor,
          elevation: 2.0,
          onPrimary: Colors.white,
          padding: EdgeInsets.all(Configuration.smpadding)
        ),
      ),
      ),
      ]
    );
  }
}


