import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meditation_app/presentation/pages/commonWidget/horizontal_list.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/menu/animatedcontainer.dart';
import 'package:meditation_app/presentation/pages/profile/profile_widget.dart';

//List of guided meditationsx
List<Map> guidedmeditations = [];

class MainScreen extends StatelessWidget {
  var controller;

  MainScreen({this.controller});

  @override
  Widget build(BuildContext context) {
    Configuration().init(context);
    return ListView(
      controller: controller,
      shrinkWrap: true,
      children: <Widget>[
        SizedBox(height: Configuration.safeBlockVertical * 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SquareContainer(
                icon: Icon(Icons.star, color: Colors.white),
                modal: AbstractDialog(
                    height: Configuration.height * 0.35,
                    width: Configuration.width * 0.85,
                    content: ListView.separated(
                        itemBuilder: (context, index) {
                          return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SquareContainer(),
                                Text('Meditate 5 times',
                                    style: Configuration.paragraph4),
                                Icon(Icons.check_box_outline_blank)
                              ]);
                        },
                        separatorBuilder: (context, index) {
                          return Divider(color: Colors.grey);
                        },
                        itemCount: 8))),
            SquareContainer(
              icon: Icon(FontAwesomeIcons.chartBar, color: Colors.white),
              modal: AbstractDialog(
                height: Configuration.height * 0.4,
                width: Configuration.width * 0.9,
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      LevelBar(width:Configuration.width*0.9),

                    ],
                  ),
                ),
              ),
            ),
            SquareContainer(
                icon: Icon(FontAwesomeIcons.moon, color: Colors.white),
                modal: AbstractDialog())
          ],
        ),
        SizedBox(height: Configuration.safeBlockVertical * 8),
        GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/path'),
            child:
                Center(child: Image(image: AssetImage('images/stage 1.png')))),
        FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/premeditation'),
          child: Icon(Icons.timer),
          backgroundColor: Configuration.maincolor,
        ),

        SizedBox(height: 500)
        // HorizontalList(description: "Learn from our guided meditations")
      ],
    );
  }
}

class SquareContainer extends StatelessWidget {
  Icon icon;
  Widget modal;
  SquareContainer({this.icon, this.modal});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(),
        child: ButtonTheme(
          minWidth: 40,
          height: 40,
          child: RaisedButton(
              color: Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)),
              onPressed: () =>
                  showDialog(context: context, builder: (_) => modal),
              child: icon),
        ));
  }
}

//Dialog for everyone
class AbstractDialog extends StatelessWidget {
  Widget content;
  double width, height;

  AbstractDialog({this.content, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
            padding: EdgeInsets.all(Configuration.blockSizeHorizontal * 2),
            height: height,
            width: width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), color: Colors.white),
            child: content));
  }
}

class UserModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


class LevelBar extends StatelessWidget {
  double width;
  LevelBar({this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(Configuration.safeBlockVertical*3),
      width: width,
      height: Configuration.height*0.1,
      decoration: BoxDecoration(borderRadius:BorderRadius.circular(12)),
      child: Stack(
        children: [
         Align(
           alignment:Alignment.topLeft,
              child: RadialProgress(
              width: Configuration.safeBlockHorizontal * 2,
              progressColor: Configuration.maincolor,
              progressBackgroundColor: Configuration.grey,
              goalCompleted: 0.2,
              child:Container(height: Configuration.height*0.1,width: Configuration.width*0.1,)
              ),
         ),
        ]),
      );
  }
}