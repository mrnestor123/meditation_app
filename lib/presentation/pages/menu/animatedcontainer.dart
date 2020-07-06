import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ContainerAnimated extends StatefulWidget {
  final Widget child;
  final String title;
  final String subtitle;

  const ContainerAnimated({Key key, this.child, this.title, this.subtitle})
      : super(key: key);

  @override
  _AnimatedState createState() => _AnimatedState();
}

class _AnimatedState extends State<ContainerAnimated> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool sidebarOpen = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: BoxDecoration(
          borderRadius: sidebarOpen
              ? BorderRadius.only(
                  topLeft: Radius.circular(30), bottomLeft: Radius.circular(30))
              : null,
          color: Colors.grey[500]),
      transform: Matrix4.translationValues(xOffset, yOffset, 0)
        ..scale(scaleFactor)
        ..rotateY(sidebarOpen ? -0.1 : 0),
      duration: Duration(milliseconds: 250),
      child: Column(
        children: <Widget>[
          Container(
            height: Configuration.height * 0.15,
            padding: EdgeInsets.all(6),
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                sidebarOpen
                    ? IconButton(
                        iconSize: Configuration.iconSize,
                        color: Colors.white,
                        icon: Icon(Icons.arrow_back),
                        onPressed: () => {
                              setState(() {
                                xOffset = 0;
                                yOffset = 0;
                                scaleFactor = 1;
                                sidebarOpen = false;
                              })
                            })
                    : IconButton(
                        icon: Icon(Icons.menu),
                        color: Colors.white,
                        iconSize: Configuration.iconSize,
                        onPressed: () => {
                          setState(() {
                            xOffset = 200;
                            yOffset = 150;
                            scaleFactor = 0.6;
                            sidebarOpen = true;
                          })
                        },
                      ),
                AutoSizeText("Train your mind",
                    style: Configuration.title,
                    minFontSize: 18,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                CircleAvatar()
              ],
            ),
          ),
          Expanded(
              child: Container(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 8),
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(25))),
                  child: widget.child))
        ],
      ),
    );
  }
}
