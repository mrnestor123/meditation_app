
import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';

class CircularProgress extends StatelessWidget {
  final double strokewidth;
  
  const CircularProgress({
    Key key,
    this.strokewidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: Configuration.maincolor,
      strokeWidth: strokewidth != null ? strokewidth : Configuration.strokewidth,
    );
  }
}
