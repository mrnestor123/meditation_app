//Class that stores all the configuration of the project. The colors of the leters the
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';

class Configuration {
  //the purple color
  static Color maincolor = Color.fromRGBO(135, 61, 175, 100);
  static TextStyle title = GoogleFonts.montserrat(
    textStyle: TextStyle(
      color: Colors.white,
      letterSpacing: .5,
      fontSize: 20
    ),
  );

  static TextStyle paragraph = GoogleFonts.montserrat(
    textStyle: TextStyle(
      color: Colors.black,
      letterSpacing: .5,
      fontSize: 15
    ),
  );

  static TextStyle settings = GoogleFonts.montserrat(
    textStyle: TextStyle(
      color: Colors.black,
      letterSpacing: .5,
      fontSize: 20,
      fontWeight: FontWeight.bold
    ),
  );


  static double iconSize;

  static TextStyle subtitle = GoogleFonts.montserrat(
    textStyle: TextStyle(
      color: Colors.black,
      letterSpacing: .5,
      fontSize: 25,
    ),
  );

  


  static List<Color> slidegradient = [
    Colors.grey[300],
    Colors.grey[400],
    Colors.grey[600]
  ];
  static MediaQueryData _mediaQueryData;
 
  static double width;
  static double height;
  static double blockSizeHorizontal;
  static double blockSizeVertical;
  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double safeBlockHorizontal;
  static double safeBlockVertical;
  
  
  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    width = _mediaQueryData.size.width;
    height = _mediaQueryData.size.height;
    iconSize = height *0.05;
    blockSizeHorizontal = width/100;
    blockSizeVertical = height/100;
    _safeAreaHorizontal = _mediaQueryData.padding.left +
        _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top +
        _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (width - _safeAreaHorizontal)/100;
    safeBlockVertical = (height - _safeAreaVertical)/100;

  }

  /*Configuration(context){
    this.context = context;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }*/
}
