import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';

//Dialog for everyone
class AbstractDialog extends StatelessWidget {
  Widget content;
  double width, height;

  AbstractDialog({this.content, this.width, this.height}) {
    if (this.width == null) {
      this.width = Configuration.width * 0.9;
    }
    if (this.height == null) {
      this.height = Configuration.height * 0.9;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: content);
  }
}
