

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/commonWidget/created_by.dart';
import 'package:meditation_app/presentation/pages/commonWidget/profile_widget.dart';

import '../config/configuration.dart';

// PASAR AQUÍ SECTION EN VEZ DE TITULO Y SUBTITULO
class BeautifulContainer extends StatelessWidget {
  
  BeautifulContainer({
    Key key,
    this.title,
    this.createdBy,
    this.subtitle,
    this.image,
    this.onPressed,
    this.color,
    this.minHeight
  }) : super(key: key);

  dynamic onPressed;
  String title, subtitle, image;
  Color color;
  Map createdBy;

  double minHeight, minWidth;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(

      
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.all(0),
        backgroundColor: Colors.white,
        side: BorderSide(color:Colors.grey.withOpacity(0.5)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Configuration.borderRadius/2)
        )
      ),
      onPressed: () { 
        onPressed();
       },
      child: Stack(
        children: [
          createdBy != null ?
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: EdgeInsets.only(left:Configuration.verticalspacing,top: Configuration.verticalspacing),
              child: doneChip(createdBy)
            )
          ): Container(),

          Column(
            children: [
              Container(
                constraints: BoxConstraints(
                  minHeight: minHeight ?? Configuration.width*0.3,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(

                      constraints: BoxConstraints(
                        maxWidth: Configuration.width*0.5
                      ),
                      margin: EdgeInsets.only(
                        left: Configuration.verticalspacing,
                        bottom: Configuration.verticalspacing  
                      ),
                      child: Text(
                        title, 
                        textScaleFactor: 1,
                        style: Configuration.text('subtitle',Colors.black)
                      )
                    ),
                    
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(Configuration.borderRadius/2)
                      ),
                      child: CachedNetworkImage(
                        imageUrl: image,
                        width: minHeight ?? Configuration.width*0.3,
                        height: minHeight ?? Configuration.width*0.3,
                        fit: BoxFit.cover 
                      ),
                    )
                  ],
                ),
              ),

              Container(
                width: Configuration.width,
                height: Configuration.verticalspacing,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(Configuration.borderRadius),
                    bottomRight: Radius.circular(Configuration.borderRadius)
                  )
                )
              )
            ],
          ),
        ],
      ),
    );
  }
}



class CurvePainter extends CustomPainter {
  
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Color.fromRGBO(132, 157, 157, 1);
    paint.style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(0, size.height - Configuration.borderRadius);
    path.lineTo(size.width, 10);

    canvas.drawRRect(
      RRect.fromLTRBR(0, size.height, size.width, size.height - 10,
        Radius.circular(Configuration.borderRadius)
      ),
      paint
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
