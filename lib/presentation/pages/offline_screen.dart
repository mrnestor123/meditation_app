
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/meditation_screen.dart';

class OfflinePage extends StatelessWidget {
  const OfflinePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          child: Container(
              color: Colors.grey,
              height: 1.0,
            ),
          preferredSize: Size.fromHeight(4.0)
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/logo-no-text.png',
              height:AppBar().preferredSize.height * 0.8
            ),
            SizedBox(width: Configuration.verticalspacing),
            Text('Inside', 
              style: Configuration.text('subtitle',Colors.black)
            ),
          ],
        ),
      ),
      body: Container(
        color: Configuration.lightgrey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: Configuration.verticalspacing),
            Padding(
              padding: EdgeInsets.all(Configuration.smpadding),
              child: Text('You are using the app in offline mode. The meditations done, will be stored and saved in the database when your internet is up',
                style: Configuration.text('small',Colors.grey,font: 'Helvetica'),
              ),
            ),
            Expanded(
              child: MeditationScreen(
                offline: true,
              ),
            ),
          ],
        ),
      )
    );
  }
}