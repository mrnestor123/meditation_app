import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/menu/sidebar.dart';

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool sidebarOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(163, 113, 190, 100),
        body: Stack(children: [
          SideBar(),
          AnimatedContainer(
              decoration: BoxDecoration(
                  borderRadius: sidebarOpen ? BorderRadius.circular(30) : null,
                  color: Colors.white),
              transform: Matrix4.translationValues(xOffset, yOffset, 0)
                ..scale(scaleFactor)..rotateY(sidebarOpen ? -0.5:0),
              duration: Duration(milliseconds: 250),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      sidebarOpen
                          ? IconButton(
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
                              onPressed: () => {
                                setState(() {
                                  xOffset = 220;
                                  yOffset = 150;
                                  scaleFactor = 0.6;
                                  sidebarOpen = true;
                                })
                              },
                            )
                    ],
                  )
                ],
              )),
        ]));
  }
}
