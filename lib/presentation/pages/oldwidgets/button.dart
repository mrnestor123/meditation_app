import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
              child: Text(text, style: Theme.of(context).textTheme.button)),
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.08,
          decoration: BoxDecoration(
              color: color, borderRadius: new BorderRadius.circular(5)),
        ),
        onTap: () {
          if (this.route != null) {
            Navigator.pushNamed(context, route);
          }
        });
  }
}
