import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WidgetTextField extends StatelessWidget {
  final String text;
  final Icon icon;
  final TextEditingController controller;

  WidgetTextField({this.text, this.icon,this.controller});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: MediaQuery.of(context).size.width*0.9,
      child: TextField( 
        controller: controller,
          decoration: InputDecoration(
        filled: true,
        labelText: text,
        border: new OutlineInputBorder(
            borderSide: new BorderSide(color: Colors.purpleAccent)),
        prefixIcon: icon,
      )),
    );
  }
}
