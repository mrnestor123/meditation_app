//Class that stores all the configuration of the project. The colors of the leters the
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';

class Configuration {
  static MediaQueryData _mediaQueryData;

  static double width;
  static double height;
  static double blockSizeHorizontal;
  static double blockSizeVertical;
  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double safeBlockHorizontal;
  static double safeBlockVertical;

  static bool nightmode = false;

  //the purple color
  static Color maincolor =
      !nightmode ? Colors.deepPurpleAccent.withOpacity(0.8) : Colors.black;
  static Color darkpurple = Colors.deepPurple;
  static Color lightpurple = Colors.deepPurpleAccent.withOpacity(0.65);

  //lighter purple
  static Color secondarycolor = Color.fromRGBO(165, 149, 248, 1.0);
  //pink
  static Color accentcolor = Color.fromRGBO(241, 212, 240, 1.0);

  static Color grey = !nightmode ? Colors.grey : Colors.blueGrey;
  static Color whitecolor = !nightmode ? Colors.white : Colors.black;

  // Paddings
  static double tinpadding;
  static double smpadding;
  static double medpadding;
  static double bigpadding;

  //icons
  static double smicon;
  static double medicon;
  static double bigicon;

  //margin
  static double smmargin;
  static double medmargin;
  static double bigmargin;

  //textstyles
  static TextStyle text(String size, Color color,
      [String style, double spacing]) {
    var px;
    var weight = FontWeight.normal;
    double letterspacing = 0;

    if (style == "bold") {
      weight = FontWeight.bold;
    }

    if (spacing != null) {
      letterspacing = spacing;
    }

    switch (size) {
      case "tiny":
        px = safeBlockHorizontal * 3;
        break;
      case "small":
        px = safeBlockHorizontal * 4;
        break;
      case "smallmedium":
        px = safeBlockHorizontal * 5;
        break;
      case "medium":
        px = safeBlockHorizontal * 6;
        break;
      case "big":
        px = safeBlockHorizontal * 6;
        break;
    }

    return TextStyle(
        fontFamily: 'Gotham',
        fontSize: px,
        color: color,
        fontWeight: weight,
        letterSpacing: letterspacing);
  }

  static List<Color> slidegradient = [
    Colors.grey[300],
    Colors.grey[400],
    Colors.grey[600]
  ];

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    width = _mediaQueryData.size.width;
    height = _mediaQueryData.size.height;
    blockSizeHorizontal = width / 100;
    blockSizeVertical = height / 100;
    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (width - _safeAreaHorizontal) / 100;
    safeBlockVertical = (height - _safeAreaVertical) / 100;

    //Paddings
    tinpadding = blockSizeHorizontal * 2;
    smpadding = blockSizeHorizontal * 4;
    medpadding = blockSizeHorizontal * 8;
    bigpadding = blockSizeHorizontal * 10;

    //icons
    smicon = safeBlockHorizontal * 6;
    medicon = safeBlockHorizontal * 11;
    bigicon = safeBlockHorizontal * 15;

    //Paddings
    smmargin = blockSizeHorizontal * 1;
    medmargin = blockSizeHorizontal * 2;
    bigmargin = blockSizeHorizontal * 4;
  }

  void leftRollDialog(context, dialog) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(opacity: a1.value, child: dialog),
          );
        },
        transitionDuration: Duration(milliseconds: 300),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }

  /*Configuration(context){
    this.context = context;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }*/
}
