
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/content_entity.dart';
import '../../mobx/actions/user_state.dart';
import '../config/configuration.dart';

class TimeChip extends StatelessWidget {
  UserState _userstate;
  Duration seenTime;
  bool finished = false;

  String getTime(Duration d){

    if(c.isMeditation()){

    }


    String time = '';

    if(seenTime != null && !finished ){    
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
  

  FileContent c;
  bool isSmall =false;
  bool seen = false;
  bool transparent = false;
  
  TimeChip({
    this.c,
    this.isSmall = false,
    this.seen = false,
    this.transparent = false,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);
    
    if(seen){ 
      // ESTO DEBERÍA ESTAR SEPARADO POR ETAPA PARA HACERLO MÁS RÁPIDO !!
      DoneContent content = _userstate.user.contentDone.firstWhere((element) => element.cod == c.cod,
        orElse: (){}
      );

      if(content != null  && content.done != null){
        seenTime = content.done;
        // PODRÍA SER UNA RECORDING,UNA MEDITACIÓN O UN VIDEO !!
        finished = seenTime.inMinutes >= (c.total.inMinutes - 1);
      }
    }  

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(isSmall ? 4: 6),
          decoration: BoxDecoration(
            color: transparent ? Colors.white.withOpacity(0.7):Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(Configuration.borderRadius) ,
          ),
          child: Row(
            children: [
              Icon(Icons.timer,size: Configuration.tinicon, color:seenTime != null && !finished ? Colors.lightBlue :Colors.black),
              SizedBox(width: Configuration.verticalspacing/2),
              Text(getTime(c.total),
                style: Configuration.text(
                  isSmall ? 'tiny' : 'small',
                  seenTime != null && !finished ? Colors.lightBlue:  Colors.black
                )
              )
            ],
          ),
        ),
        
        SizedBox(width: Configuration.verticalspacing),
        
        finished ? 
        Icon(Icons.visibility,color: Colors.lightBlue, size: Configuration.smicon)
        : Container(),
      ],
    );
  }
}
