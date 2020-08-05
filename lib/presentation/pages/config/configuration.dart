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

  //the purple color
  static Color maincolor = Color.fromRGBO(135, 61, 175, 100);
  static Color grey = Colors.grey;


  // TextStyles are title, subtitle, subtitle2,subtilte3, paragraph1,paragraph2,paragraph3
  static TextStyle title = GoogleFonts.montserrat(
    textStyle: TextStyle(
        color: Colors.white,
        letterSpacing: .5,
        fontSize: safeBlockHorizontal * 6),
  );

  static TextStyle subtitle = GoogleFonts.montserrat(
    textStyle: TextStyle(
      color: Color.fromRGBO(135, 61, 175, 100),
      letterSpacing: .5,
      fontSize: Configuration.safeBlockHorizontal * 6,
    ),
  );

  static TextStyle subtitle2 = GoogleFonts.montserrat(
    textStyle: TextStyle(
      color: Colors.white,
      letterSpacing: .5,
      fontSize: Configuration.safeBlockHorizontal * 10,
    ),
  );

  static TextStyle paragraph = GoogleFonts.montserrat(
      textStyle: TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.bold,
        letterSpacing: .5,
      ),
      fontSize: safeBlockHorizontal * 5);

  static TextStyle paragraph2 = GoogleFonts.montserrat(
    textStyle: TextStyle(
      color: Colors.black,
      letterSpacing: .5,
      fontSize: Configuration.safeBlockHorizontal * 6,
    ),
  );

  static TextStyle paragraph3 = GoogleFonts.montserrat(
    textStyle: TextStyle(
      color: Color.fromRGBO(135, 61, 175, 100),
      letterSpacing: .5,
      fontSize: Configuration.safeBlockHorizontal * 5,
    ),
  );

  static TextStyle paragraph4 = GoogleFonts.montserrat(
    textStyle: TextStyle(
      color: Colors.black,
      letterSpacing: .5,
      fontSize: Configuration.safeBlockHorizontal * 5,
    ),
  );

  static TextStyle longtext = GoogleFonts.montserrat(
      textStyle: TextStyle(
    color: Colors.black,
    fontSize: Configuration.safeBlockHorizontal * 5,
  ));

  static TextStyle modaltitle = GoogleFonts.montserrat(
    textStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
        letterSpacing: .5,
        fontSize: safeBlockHorizontal * 6),
  );

  static TextStyle modalsubtitle = GoogleFonts.montserrat(
    textStyle: TextStyle(
        color: Colors.black,
        letterSpacing: .5,
        fontSize: safeBlockHorizontal * 4),
  );

  static TextStyle settings = GoogleFonts.montserrat(
    textStyle: TextStyle(
      color: Colors.black,
      letterSpacing: .5,
      fontSize: blockSizeHorizontal * 6,
    ),
  );

  static TextStyle nombre = GoogleFonts.montserrat(
      textStyle: TextStyle(
          color: Colors.white,
          letterSpacing: .5,
          fontSize: blockSizeHorizontal * 10));

  static double iconSize;

  static TextStyle numbers = GoogleFonts.montserrat(
      textStyle: TextStyle(
        color: Colors.white,
        letterSpacing: .5,
      ),
      fontSize: safeBlockHorizontal * 15);

  static TextStyle lessontext = GoogleFonts.montserrat(
      textStyle: TextStyle(
          color: Colors.white, letterSpacing: .5, fontWeight: FontWeight.bold),
      fontSize: safeBlockHorizontal * 3.5);

  static TextStyle infoCardnumber = GoogleFonts.montserrat(
      textStyle: TextStyle(
        color: Colors.black,
        letterSpacing: .5,
        fontWeight: FontWeight.bold,
      ),
      fontSize: safeBlockHorizontal * 5);

  static TextStyle infoCarddescription = GoogleFonts.montserrat(
      textStyle: TextStyle(
        color: Colors.black,
        letterSpacing: .5,
      ),
      fontSize: safeBlockHorizontal * 3);

  static List<Color> slidegradient = [
    Colors.grey[300],
    Colors.grey[400],
    Colors.grey[600]
  ];

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    width = _mediaQueryData.size.width;
    height = _mediaQueryData.size.height;
    iconSize = height * 0.05;
    blockSizeHorizontal = width / 100;
    blockSizeVertical = height / 100;
    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (width - _safeAreaHorizontal) / 100;
    safeBlockVertical = (height - _safeAreaVertical) / 100;
  }

  /*Configuration(context){
    this.context = context;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }*/
}
