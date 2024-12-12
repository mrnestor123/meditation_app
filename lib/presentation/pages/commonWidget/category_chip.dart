

// category chip

import 'package:flutter/material.dart';

import '../config/configuration.dart';


class CategoryChip extends StatelessWidget {
  final String category;

  const CategoryChip({Key key, this.category});

  

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Configuration.borderRadius),
        side: BorderSide(
          color: Colors.grey,
          width: 1,
        ),
      ),
      label: Text(
        category,
        style: TextStyle(
          color:  Colors.black,
        ),
      ),
    );
  }
}