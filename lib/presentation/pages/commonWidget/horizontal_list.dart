import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';

class HorizontalList extends StatelessWidget {
  List<Map> elements;
  String description;

  HorizontalList({this.elements, this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 32),
      child: Column(children: <Widget>[
        Text(
          description,
          style: Configuration.paragraph,
          textAlign: TextAlign.left,
        ),
        Divider(
          color: Configuration.maincolor,
          thickness: 5,
          indent: 20,
          endIndent: 200,
          height: 20,
        ),
        Row(
          children: <Widget>[
            Expanded(
          child: Container(
            height: Configuration.height*0.12,
            child:ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(16),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right:8,left:8),
                    width: Configuration.width*0.1,
                    decoration: BoxDecoration(color: Colors.grey),
                  );
                }))),
          ],
        )
      ]),
    );
  }
}
