
import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';

class CircularProgress extends StatelessWidget {
  final double strokewidth;
  final Color color;

  const CircularProgress({
    Key key,
    this.strokewidth,
    this.color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height:Configuration.verticalspacing,
      width: Configuration.verticalspacing,
      child: CircularProgressIndicator(
        color:  color != null ? color : Configuration.maincolor,
        strokeWidth: strokewidth != null ? strokewidth : Configuration.strokewidth,
      ),
    );
  }
}
