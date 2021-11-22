//Class that stores all the configuration of the project. The colors of the leters the
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
  static double lessonratio;

  static bool nightmode = false;

  static Color maincolor2 = Colors.white;

  //buttoncolor ??

  // scaffoldcolor ??
  static Color scaffoldcolor = !nightmode ? Colors.deepPurpleAccent.withOpacity(0.8) : Colors.black;

  //the purple color
  static Color maincolor = !nightmode ? Color.fromRGBO(216, 187, 120, 1.0) : Colors.black;
  static Color darkpurple = Colors.deepPurple;
  static Color lightpurple = Colors.deepPurpleAccent.withOpacity(0.65);

  static Color white = !nightmode ? Colors.white : Colors.black;
  static Color lightgrey = Color.fromARGB(255, 242, 242, 242);

  //lighter purple
  static Color secondarycolor = Color.fromRGBO(165, 149, 248, 1.0);
  //pink
  static Color accentcolor = Color.fromRGBO(241, 212, 240, 1.0);

  static Color grey = !nightmode ? Colors.grey : Colors.blueGrey;

  // Paddings
  static double tinpadding;
  static double smpadding;
  static double medpadding;
  static double bigpadding;

  //icons
  static double tinicon;
  static double tablettinicon;
  static double tabletsmicon;
  static double smicon;
  static double medicon;
  static double bigicon;

  //margin
  static double smmargin;
  static double medmargin;
  static double bigmargin;


  static double verticalspacing;
  static double strokewidth;

  static int crossAxisCount;

  //textstyles
  /*
    fonts can be : Gotham-bold, Helvetica, Gotham-rounded, Gotham
    HACER EL TEXTO RESIZABLE PARA TODOS
  */
  static TextStyle text(String size, Color color,{String style, double spacing, String font}) {
    var px;
    var weight = FontWeight.normal;
    double letterspacing = 0;

    String fontfamily = 'Gotham-rounded';

    if (style == "bold") {
      weight = FontWeight.bold;
    }

    if (spacing != null) {
      letterspacing = spacing;
    }

    if(font != null){
      fontfamily = font;
    }
    
    if(width < 480){
      switch (size) {
        case 'mini':
          px = 8.0;
          break;
        case 'verytiny':
          px = 10.0;
          break;
        case "tiny":
          px = 12.0;
          break;
        case "small":
          px = 14.0;
          break;
        case "smallmedium":
          px = 16.0;
          break;
        case "medium":
          px = 18.0;
          break;
        case "big":
          px = 20.0;
          break;
        case "huge":
          px = 30.0;
          break;
      }
    }else{
      switch (size) {
        case 'mini':
          px = 14.0;
          break;
        case 'verytiny':
          px = 16.0;
          break;
        case "tiny":
          px = 18.0;
          break;
        case "small":
          px = 20.0;
          break;
        case "smallmedium":
          px = 22.0;
          break;
        case "medium":
          px = 24.0;
          break;
        case "big":
          px = 26.0;
          break;
        case "huge":
          px = 30.0;
          break;
      }
    }

    return TextStyle(
        fontFamily: fontfamily,
        fontSize: px,
        color: color,
        fontWeight: weight,
        letterSpacing: letterspacing);
  }


  //textstyles HAY QUE QUITAR ESTO DE AQUI !!!
  /*

    fonts can be : Gotham-bold, Helvetica, Gotham-rounded, Gotham
  */
  static TextStyle tabletText(String size, Color color, {String style, double spacing, String font}) {
    var px;
    var weight = FontWeight.normal;
    double letterspacing = 0;

    String fontfamily = 'Gotham-rounded';

    if (style == "bold") {
      weight = FontWeight.bold;
    }

    if (spacing != null) {
      letterspacing = spacing;
    }

    if(font != null){
      fontfamily = font;
    }

    switch (size) {
       case 'mini':
        px = 12.0;
        break;
      case 'verytiny':
        px =14.0;
        break;
      case "tiny":
        px = 16.0;
        break;
      case "small":
        px = 18.0;
        break;
      case "smallmedium":
        px = 20.0;
        break;
      case "medium":
        px = 22.0;
        break;
      case "big":
        px = 24.0;
        break;
      case "huge":
        px = 30.0;
        break;
    }

    return TextStyle(
        fontFamily: fontfamily,
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
    if(width > 500){
      tinpadding = 15;
      verticalspacing = 20;
      smpadding = 25;
      medpadding = 31;
      bigpadding = 36;
      smicon = 35;
      medicon = 45;
      bigicon = 50;
      strokewidth = 8;
      bigicon = safeBlockHorizontal * 5;
      crossAxisCount = 3;
      lessonratio = 11/3;
    }else {
      tinpadding = 10;
      verticalspacing = 10;
      strokewidth = 4;
      smpadding = 14;
      medpadding = 20;
      bigpadding = 30;
      crossAxisCount = 2;
      lessonratio = 8/3;
      smicon = 24;
      medicon = 30;
      bigicon = 40;
    }

    
    //icons
    tablettinicon = safeBlockHorizontal *2;
    tabletsmicon= safeBlockHorizontal *2.5;
    
  
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
