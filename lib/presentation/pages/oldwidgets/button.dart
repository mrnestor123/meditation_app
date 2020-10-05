import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';

class ButtonContainer extends StatelessWidget {
  final Color color;
  final String text;
  final String route;
  MediaQueryData data;

  ButtonContainer({this.text, this.color, this.route});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
        child: Container(
          child: Center(
              child: Text(text, style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white, fontSize: Configuration.blockSizeHorizontal*5)),)),
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.08,
          decoration: BoxDecoration(
              color: color, borderRadius: new BorderRadius.circular(30),
              boxShadow: [BoxShadow(color:Colors.grey,offset:Offset(2, 3),spreadRadius: 1,blurRadius: 3)]
              ),
        ),
        onTap: () {
          if (this.route != null) {
            Navigator.pushNamed(context, route);
          }
        });
  }
}
