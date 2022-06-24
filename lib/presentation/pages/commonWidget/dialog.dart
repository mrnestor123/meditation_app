import 'package:flutter/material.dart';

//Dialog for everyone
class AbstractDialog extends StatelessWidget {
  final Widget content;

  AbstractDialog({this.content});
  

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: content);
  }
}
