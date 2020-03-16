import 'package:flutter/material.dart';

class DescriptionWidget extends StatelessWidget {
  final String title;

  DescriptionWidget(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.2,
        child: Center(
            child: Text(
          title,
          textAlign: TextAlign.center,
        )));
  }
}
