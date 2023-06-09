

import 'package:flutter/material.dart';

import '../config/configuration.dart';

class BeautifulContainer extends StatelessWidget {
  
  BeautifulContainer({
    Key key,
    this.title,
    this.subtitle,
    this.image,
    this.onPressed,
    this.color
  }) : super(key: key);

  dynamic onPressed;
  String title, subtitle, image;
  Color color;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.all(0),
        backgroundColor: Colors.white,
        side: BorderSide(
          color:Colors.grey.withOpacity(0.5),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Configuration.borderRadius/2)
        )
      ),
      onPressed: () {
        showDialog(
          context: context, 
          builder: (context){
            return Container(
              color: Colors.white,
              padding: EdgeInsets.all(Configuration.smpadding),
              child: Text('A TEXT'),
            );
          }
        );
       // Navigator.pushNamed(context, '/learn');
      },
      child: Column(
        children: [
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(left: Configuration.verticalspacing),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(subtitle, style: Configuration.text('small',Colors.black, font: 'Helvetica')),
                    Text(title, style: Configuration.text('subtitle',Colors.black)),
                    SizedBox(height: Configuration.verticalspacing)
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(Configuration.borderRadius/2),
                  topLeft: Radius.circular(Configuration.borderRadius/2)
                ),
                child: Image.asset(
                  image,
                  width: Configuration.width*0.3,
                  height: Configuration.width*0.3,
                  fit: BoxFit.cover 
                ),
              )
            ],
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
            ),
          )
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
