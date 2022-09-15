

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../domain/entities/user_entity.dart';
import '../config/configuration.dart';

class StageProgressBar extends StatelessWidget {
  StageProgressBar({this.user}) : super();

  User user;


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: Configuration.verticalspacing*2.5,
            child: Stack(
              children: [
                SizedBox(
                  height:Configuration.verticalspacing*2.5,
                  child:ClipRRect(
                  borderRadius: BorderRadius.circular(Configuration.borderRadius),
                  child: LinearProgressIndicator(
                    value: user.percentage/100,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue),
                    backgroundColor: Colors.lightBlue.withOpacity(0.2),
                  ),
                )),
                Center(child: Text(user.percentage.toString() + '%', style: Configuration.text('small',Colors.black)),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}