
import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/commonWidget/radial_progress.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';

class ProfileCircle extends StatelessWidget {
 
  final String userImage;
  final double width;
  final String height;
  final Color color;
  final double marginLeft;
  final double marginRight;
  final VoidCallback onTap; // Notice the variable type


  ProfileCircle({
    this.userImage,
    this.width,
    this.height,
    this.color,
    this.marginLeft,
    this.marginRight,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: marginLeft !=null ? marginLeft:  Configuration.medmargin, right: marginRight !=null ? marginRight   : Configuration.bigmargin),
      child: GestureDetector(
        onTap: onTap, 
        child: RadialProgress(
            width: width != null  ? width: Configuration.safeBlockHorizontal * 0.7,
            progressColor: color != null ? color: Configuration.maincolor,
            goalCompleted: 1,
            child: CircleAvatar(
              backgroundColor: userImage == null
                  ? Configuration.lightgrey
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