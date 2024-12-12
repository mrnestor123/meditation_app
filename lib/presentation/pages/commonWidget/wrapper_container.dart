
import 'package:flutter/material.dart';

import '../config/configuration.dart';

Widget wrapperContainer({Widget child}){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Configuration.borderRadius/2),
        border: Border.all(
          color: Colors.grey,
          width: 0.5
        ),
      ),
      child: child
    );
  }