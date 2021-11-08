
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
      child: GestureDetector(
        onTap: onTap, 
        child: Container(
          padding: EdgeInsets.all(Configuration.strokewidth/2),
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: Configuration.maincolor,
                width: Configuration.strokewidth/2
              ),
              shape: BoxShape.circle
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: userImage == null
                  ? Configuration.maincolor
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