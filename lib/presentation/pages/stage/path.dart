import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:photo_view/photo_view.dart';

class ImagePath extends StatelessWidget {
  ScrollController scrollController = new ScrollController(
    initialScrollOffset: Configuration.height,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            controller: scrollController,
            child: SizedBox(
              width: Configuration.width,
              height: Configuration.height,
              child: Image(
                image: AssetImage('assets/path.png') ,
                width: Configuration.width,
                height: Configuration.height,
              ),
            ),
          ),
          Positioned(
            //Place it at the top, and not use the entire screen
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back,
                    size: Configuration.smicon, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
