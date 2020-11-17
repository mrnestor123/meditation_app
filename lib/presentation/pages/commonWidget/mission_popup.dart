import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meditation_app/domain/entities/mission.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/meditation/main_screen.dart';

class MissionPopup extends StatelessWidget {
  List<Mission> missions;

  MissionPopup({this.missions});

  List<Widget> getMissions() {
    List<Widget> result = new List<Widget>();

    result.add(Text("CONGRATS!",
        style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            fontSize: Configuration.blockSizeHorizontal * 10)));
    result.add(Text(
        missions.length == 1
            ? 'You passed the mission'
            : 'You passed the missions',
        style: GoogleFonts.roboto(
            fontSize: Configuration.blockSizeHorizontal * 6)));

    for (Mission m in missions) {
      result
          .add(Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Image(
            image: AssetImage(m.type == 'lesson'
                ? 'assets/books.png'
                : 'assets/meditation.png'),
            height: Configuration.blockSizeHorizontal * 9,
            width: Configuration.blockSizeHorizontal * 9),
        Text(m.description,
            style: GoogleFonts.roboto(
                fontSize: Configuration.blockSizeHorizontal * 5)),
      ]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return AbstractDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: getMissions(),
      ),
    );
  }
}

class CircleBlurPainter extends CustomPainter {
  CircleBlurPainter(
      {@required this.circleWidth, @required this.height, this.blurSigma, this.color});

  double circleWidth;
  double blurSigma;
  double height;
  Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
      ..color = color !=null ? color :Colors.white 
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke
      ..strokeWidth = circleWidth
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma);
    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, line);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
