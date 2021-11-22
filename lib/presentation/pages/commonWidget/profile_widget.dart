
import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/commonWidget/radial_progress.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';

class ProfileCircle extends StatelessWidget {
 
  final String userImage;
  final double width;
  final Color color, bordercolor;
  final double marginLeft;
  final double marginRight;
  final VoidCallback onTap; // Notice the variable type


  ProfileCircle({
    this.userImage,
    this.width = 60,
    this.color,
    this.bordercolor,
    this.marginLeft,
    this.marginRight,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: onTap, 
        child: Container(
          padding: EdgeInsets.all(Configuration.strokewidth/3),
          decoration: BoxDecoration(
              color:  Colors.transparent,
              border: Border.all(
                color: bordercolor!= null ? bordercolor : Configuration.maincolor,
                width: Configuration.strokewidth/2
              ),
              shape: BoxShape.circle
            ),
            child: CircleAvatar(
              radius: width/2,
              backgroundColor: userImage == null
                  ? color != null ? color : Configuration.maincolor
                  : Colors.transparent,
              backgroundImage: userImage == null
                  ? null
                  : NetworkImage(userImage) ,
                  //: FileImage(File(_userstate.user.image)),
            )),
      ),
    );
  }
}