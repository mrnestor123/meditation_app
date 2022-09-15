

import 'package:flutter/material.dart';

import '../config/configuration.dart';

class CarouselBalls extends StatelessWidget {
  int index = 0;
  int items ;
  Color activecolor;

  bool showNext;
  dynamic onNext;

  CarouselBalls({this.index, this.items = 0, this.activecolor = Colors.white, Key key, this.showNext = false, this.onNext}): super(key:key);

  List<Widget> getBalls() {
      List<Widget> res = new List.empty(growable: true);
      
      for(int i = 0; i < items; i++){
         res.add(Container(
          width: Configuration.safeBlockHorizontal * 3,
          height: Configuration.safeBlockHorizontal * 3,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i == index
              ? activecolor
              : Color.fromRGBO(0, 0, 0, 0.4),
          ),
        ));
      }

      return res;
    }



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
         Align(
           alignment: Alignment.center,
           child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: getBalls(),
            ),
         ),
        
        showNext ? 
          Positioned(
            right: 10,
            bottom: Configuration.safeBlockHorizontal * 1.5,
            child: Container(
              child: GestureDetector(
                onTap:()=>{
                  onNext(index)
                }, 
                child: Text((index +1) == items ? 'Finish': 'Next', style: Configuration.text('smallmedium', Colors.white))
              ),
            ),
          ) : Container()
      ],
    );
  }
}