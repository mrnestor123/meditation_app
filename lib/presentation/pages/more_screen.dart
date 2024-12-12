

import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/commonWidget/wrapper_container.dart';
import 'package:meditation_app/presentation/pages/settings_widget.dart';
import 'package:provider/provider.dart';

import '../mobx/actions/meditation_state.dart';
import 'config/configuration.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {

  var _meditationstate;

  Widget chiporText(String text, bool chip, int page){
    Widget g;


    if (chip){
      g = Chip(
        padding: EdgeInsets.all(Configuration.tinpadding),
        label: Text(text, style: Configuration.text('tiny', Colors.black))
      );
    } else {
      g =Chip(
        padding: EdgeInsets.all(Configuration.tinpadding),
        label: Text(text, style: Configuration.text('tiny', Colors.black)), 
        backgroundColor: Colors.white, 
        elevation: 0.0
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _meditationstate.switchpage(page);
        });
      },
      child: g
    );
  }


  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _meditationstate = Provider.of<MeditationState>(context);
    _meditationstate.practice = PageController(initialPage: _meditationstate.currentpage);
  }

  @override
  Widget build(BuildContext context) {
    _meditationstate = Provider.of<MeditationState>(context);

    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.all(
          Configuration.smpadding
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(Configuration.smpadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Configuration.borderRadius/2),
                border: Border.all(
                  color: Colors.grey,
                  width: 0.5
                )
              ),
              child: Text('This app has been done thanks to the incredible work of Culadasa, The Mind Illuminated. With love and gratitude, I hope that meditation can help you as much as it did for me. \n\n Ernest',
                style: Configuration.text('small',Colors.black, style: 'italic'),
                textAlign: TextAlign.justify,
              ),
            ),

            SizedBox(height: Configuration.verticalspacing),

            wrapperContainer(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                child: SettingsMenu())
            )
            
          ],
        )
      ),
    );
  }
}