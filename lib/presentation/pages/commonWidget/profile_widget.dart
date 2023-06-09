
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    this.onTap,
    Key key
  }): super(key:  key);

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
              child: userImage != null && userImage.isNotEmpty && userImage.contains('<svg') ? 
              SvgPicture.string(userImage) :
              Container(),
              radius: width/2,
              backgroundColor: userImage == null || userImage.isEmpty
                  ? color != null ? color : Configuration.maincolor
                  : Colors.transparent,
              backgroundImage: userImage == null || userImage.isEmpty || userImage.contains('<svg') 
                  ? null :
                  CachedNetworkImageProvider(userImage),
                  //: FileImage(File(_userstate.user.image)),
            )),
      ),
    );
  }
}